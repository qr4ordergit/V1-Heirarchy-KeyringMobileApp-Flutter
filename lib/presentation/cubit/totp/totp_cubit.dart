import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/domain/repositories/totp/totp_repository.dart';
import '../../../core/config/app_config.dart';
import 'totp_state.dart';

class TotpCubit extends Cubit<TotpState> {
  static const int interval = 120;
  final TotpRepository repository;
  final String secretKey;

  Timer? _timer;
  int? _lastTimeStep;

  TotpCubit({required this.repository, required this.secretKey}) : super(const TotpState());

  void start() {
    _timer?.cancel();
    _lastTimeStep = null;
    _updateOtp();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateOtp(),
    );
  }

  void _updateOtp() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeStep = now ~/ interval;
    final remaining = interval - (now % interval);

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
          interval: interval,
          digits: 6,
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
