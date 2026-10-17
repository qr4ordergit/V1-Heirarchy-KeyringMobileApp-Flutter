import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/enums/enums.dart';
import 'package:keyring/core/errors/api_exceptions.dart';
import 'package:keyring/domain/repositories/keyring/keyring_repository.dart';
import '../../../core/services/notifications/notification_payload.dart';
import '../../../data/models/keyring/keyring_model.dart';
import 'keyring_event.dart';
import 'keyring_state.dart';

class KeyringBloc extends Bloc<KeyringEvent, KeyringState> {
  final KeyringRepository keyringRepository;

  KeyringBloc({required this.keyringRepository}) : super(KeyringState()) {
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

    bool isSame(NotificationPayload a, NotificationPayload b) {
      if (a.requestId != null && b.requestId != null) {
        return a.requestId == b.requestId;
      }
      return a.keyringCategoryId == b.keyringCategoryId && a.otp == b.otp;
    }

    if (state.notificationPayloads.any((e) => isSame(e, payload))) return;

    emit(state.copyWith(
      notificationPayloads: [...state.notificationPayloads, payload],
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
      final data = {
        "request_id": event.requestId,
        "keyring_category_id": event.keyringCategoryId,
        "action": event.action,  // accepted or rejected
        "otp": event.otp
      };

      final response = await keyringRepository.acceptRejectKeyringRequest(data: data);


        emit(state.copyWith(
          requestStatus: ApiStatus.success,
          clearLoading: true,
          notificationPayloads: state.notificationPayloads
              .where((e) => e.requestId != event.requestId)
              .toList(),
        ));
    } on NotFoundException catch (e) {
      log('404 NotFound ${e.message} || Response body: ${e.data}');
      emit(state.copyWith(
        requestStatus: ApiStatus.failure,
        clearLoading: true,
        actionErrorMessage: e.message,
      ));
    } catch (e) {
      log('Error On Accept Reject otp: $e');
      emit(state.copyWith(
        requestStatus: ApiStatus.failure,
        clearLoading: true,
        actionErrorMessage: e.toString(),
      ));
    }
  }
  // Notification Section End

  Future<void> _onKeyringDetails(GetKeyringDetailsEvent event, Emitter<KeyringState> emit) async {
    emit(state.copyWith(apiStatus: ApiStatus.loading));
    try {
      final KeyringModel responseModel = await keyringRepository.getKeyringDetails();
      emit(state.copyWith(apiStatus: ApiStatus.success, originalKeyringData: responseModel.data ?? []));
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

  Future<void> _onKeyringReset(ResetKeyringActionEvent event, Emitter<KeyringState> emit) async {
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



}

