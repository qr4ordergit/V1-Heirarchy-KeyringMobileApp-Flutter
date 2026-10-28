import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/domain/repositories/totp/totp_repository.dart';
import '../../../core/config/app_config.dart';
import 'totp_state.dart';

class TotpCubit extends Cubit<TotpState> {
  static const int digits = 6;

  final TotpRepository repository;
  final String secretKey;

  Timer? _timer;
  int? _lastTimeStep;
  int _interval;

  TotpCubit({
    required this.repository,
    required this.secretKey,
    required this._interval,
  }) : super(const TotpState());

  void start({required String keyringCategoryId}) {
    if (_interval <= 0) return;

    _timer?.cancel();
    _lastTimeStep = null;
    _updateOtp(keyringCategoryId: keyringCategoryId);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateOtp(keyringCategoryId: keyringCategoryId),
    );
  }

  void updateInterval({required int interval, required String keyringCategoryId}) {
    log("Update Interval: $interval");

    if (interval <= 0 || interval == _interval) return;

    log('Updating TOTP interval: $_interval -> $interval');

    _interval = interval;
    _lastTimeStep = null;

    // Immediately recalculate OTP and remaining time
    start(keyringCategoryId: keyringCategoryId);
  }


  void _updateOtp({required String keyringCategoryId}) {
    if (_interval <= 0) return;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeStep = now ~/ _interval;
    final remaining = _interval - (now % _interval);

    try {
      if (secretKey.trim().isEmpty) {
        emit(
          TotpState(remainingSeconds: remaining, errorMessage: secretKeyIsUnavailable),
        );
        return;
      }

      var code = state.otpCode;

      if (_lastTimeStep != timeStep || code.isEmpty) {
        code = repository.generateCode(
          secretKey: secretKey,
          interval: _interval,
          digits: digits,
        );

        _lastTimeStep = timeStep;
      }

      emit(TotpState(otpCode: code, remainingSeconds: remaining));
    } catch (_) {
      _lastTimeStep = null;

      emit(TotpState(errorMessage: unableToGenerateOtp, remainingSeconds: remaining));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
