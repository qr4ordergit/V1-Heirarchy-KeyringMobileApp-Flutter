import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/config/app_config.dart';
import 'package:keyring/core/enums/enums.dart';
import 'package:keyring/core/errors/api_exceptions.dart';
import 'package:keyring/core/services/notifications/notification_service.dart';
import 'package:keyring/domain/repositories/keyring/keyring_repository.dart';
import 'package:keyring/domain/repositories/totp/totp_repository.dart';
import '../../../data/models/notifications/notification_payload.dart';
import '../../../data/models/keyring/keyring_model.dart';
import '../../cubit/totp/totp_cubit.dart';
import 'keyring_event.dart';
import 'keyring_state.dart';

class KeyringBloc extends Bloc<KeyringEvent, KeyringState> {
  final KeyringRepository keyringRepository;
  final TotpRepository totpRepository;

  KeyringBloc({required this.keyringRepository, required this.totpRepository}) : super(KeyringState()) {
    on<GetKeyringDetailsEvent>(_onKeyringDetails);
    on<GetKeyringPasswordEvent>(_onKeyringPassword);
    on<ResetKeyringActionEvent>(_onKeyringReset);
    on<KeyringCategorySearchEvent>(_onKeyringCategorySearch);

    on<AddNotificationPayloadEvent>(_onAddPayload);
    on<AcceptRejectKeyringRequest>(_onAcceptRejectKeyring);
  }

  // Notification Section Start
  void _onAddPayload(AddNotificationPayloadEvent event, Emitter<KeyringState> emit) {
    final payload = event.payload;
    if (payload.isEmpty) return;
    // Foreground notification: {keyring_category_id: 6ad216b886b2576c66e5733f, keyring_category_name: 2 TOTP 2 Factor New, type: message, request_id: sup-ironman-473#6ad216b886b2576c66e5733f}

    final requestId = payload.requestId;

    // Prevent duplicate requests with the same requestId
    final alreadyExists = state.pendingRequests.any(
          (request) => request.id == requestId,
    );

    if (alreadyExists) return;

    final AccessRequest newRequest  = AccessRequest(
      id: payload.requestId,
      keyringCategoryId: payload.keyringCategoryId,
      accessUsername: payload.keyringCategoryName
    );

    emit(state.copyWith(
      pendingRequests: [...state.pendingRequests, newRequest],
    ));
  }

  Future<void> _onAcceptRejectKeyring(AcceptRejectKeyringRequest event, Emitter<KeyringState> emit) async {
    emit(state.copyWith(
      requestStatus: ApiStatus.loading,
      loadingRequestId: event.requestId,
      loadingIsAccept: event.action == 'accepted',
      actionErrorMessage: null,
    ));

    try {
      // Find the keyring for this category.
      final keyring = state.originalKeyringData.firstWhere(
            (item) => item.id == event.keyringCategoryId,
      );

      final secretKey = keyring.secretKey;

      if (secretKey == null || secretKey.isEmpty) {
        emit(state.copyWith(
          requestStatus: ApiStatus.failure,
          clearLoading: true,
          actionErrorMessage: secretKeyIsUnavailable,
        ));
        return;
      }

      // Generate a fresh OTP when Accept or Reject is tapped.
      final otp = totpRepository.generateCode(
        secretKey: secretKey,
        interval: TotpCubit.interval,
        digits: TotpCubit.digits,
      );

      final data = {
        'request_id': event.requestId,
        'keyring_category_id': event.keyringCategoryId,
        'action': event.action,
        'otp': otp,
      };

      await keyringRepository.acceptRejectKeyringRequest(data: data);

      await NotificationService.clearSpecificNotification(id: event.requestId);

      final updatedRequests = state.pendingRequests
          .where((request) => request.id != event.requestId)
          .toList();

      emit(state.copyWith(
        requestStatus: ApiStatus.success,
        clearLoading: true,
        pendingRequests: updatedRequests,
      ));
    } on NotFoundException catch (e) {
      emit(state.copyWith(
        requestStatus: ApiStatus.failure,
        clearLoading: true,
        actionErrorMessage: e.toString(),
      ));
    } catch (e) {
      log('Error on Accept/Reject: $e');
      emit(state.copyWith(
        requestStatus: ApiStatus.failure,
        clearLoading: true,
        actionErrorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onKeyringReset(ResetKeyringActionEvent event, Emitter<KeyringState> emit) async {
    // totpRepository.removeOtp(event.keyringCategoryId);
    final updatedList = state.originalKeyringData.map((keyring) {
      if (keyring.id == event.keyringCategoryId) {
        return keyring.copyWith(
          keyringCategoryPasswords: {},
        );
      }
      return keyring;
    }).toList();

    emit(state.copyWith(
      originalKeyringData: updatedList,
      apiActionStatus: ApiStatus.initial,
      verifiedKeyringCategoryId: null,
      actionErrorMessage: null,
    ));

  }

  // Notification Section End

  Future<void> _onKeyringDetails(GetKeyringDetailsEvent event, Emitter<KeyringState> emit) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final KeyringModel responseModel = await keyringRepository.getKeyringDetails();
      final keyringList = responseModel.data ?? [];

      final pendingRequests = (responseModel.accessRequests?.data ?? [])
          .where((request) => request.status == 'pending')
          .toList();

      emit(state.copyWith(
        apiStatus: ApiStatus.success,
        originalKeyringData: keyringList,
        pendingRequests: pendingRequests,
      ));

    }catch(e) {
      log("Error On Keyring List: $e");
      emit(state.copyWith(apiStatus: ApiStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onKeyringCategorySearch(KeyringCategorySearchEvent event, Emitter<KeyringState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onKeyringPassword(GetKeyringPasswordEvent event, Emitter<KeyringState> emit) async {
    emit(state.copyWith(
      apiActionStatus: ApiStatus.loading,
      verifiedKeyringCategoryId: event.keyringCategoryId,
    ));
    try {
      final response = await keyringRepository.getKeyringPassword(
          keyringCategoryId: event.keyringCategoryId, otp: event.otp
      );

      final data = response['data'];

      if (data == null || data['keyring_category_passwords'] == null) {
        throw Exception('Keyring passwords not found in API response');
      }

      final Map<String, dynamic> keyringPasswords =
      Map<String, dynamic>.from(
        data['keyring_category_passwords'] as Map,
      );

      final updatedList = state.originalKeyringData.map((keyring) {
        if (keyring.id == event.keyringCategoryId) {
          return keyring.copyWith(
            keyringCategoryPasswords: keyringPasswords,
          );
        }
        return keyring;
      }).toList();

      emit(state.copyWith(
        originalKeyringData: updatedList,
        apiActionStatus: ApiStatus.success,
        verifiedKeyringCategoryId: event.keyringCategoryId,
      ));

    }catch(e) {
      log("Error On Get Keyring Password: $e");
      emit(state.copyWith(apiActionStatus: ApiStatus.failure, actionErrorMessage: e.toString()));
    }
  }




}

