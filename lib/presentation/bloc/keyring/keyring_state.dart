
import 'package:keyring/core/enums/enums.dart';

import '../../../core/services/notifications/notification_payload.dart';
import '../../../data/models/keyring/keyring_model.dart';

class KeyringState {
  final ApiStatus apiStatus;
  final String? errorMessage;
  final List<KeyringData> originalKeyringData;
  final String searchQuery;

  final ApiStatus apiActionStatus;
  final String? actionErrorMessage;
  final String? verifiedKeyringCategoryId;

  final ApiStatus requestStatus;
  final List<NotificationPayload> notificationPayloads;
  final String? loadingRequestId;
  final bool? loadingIsAccept;


  const KeyringState({
    this.apiStatus = ApiStatus.initial,
    this.errorMessage,
    this.apiActionStatus = ApiStatus.initial,
    this.originalKeyringData = const [],
    this.actionErrorMessage,
    this.verifiedKeyringCategoryId,
    this.searchQuery = "",
    this.notificationPayloads = const [],
    this.requestStatus = ApiStatus.initial,
    this.loadingRequestId,
    this.loadingIsAccept,

});


  List<KeyringData> get keyringData {
    if (searchQuery.trim().isEmpty) return originalKeyringData;

    return originalKeyringData.
    where((keyring) => keyring.keyringCategoryName.toString().toLowerCase().
    contains(searchQuery.toString().toLowerCase()))
        .toList();
  }

  KeyringState copyWith({
    ApiStatus? apiStatus,
    String? errorMessage,
    List<KeyringData>? originalKeyringData,
    ApiStatus? apiActionStatus,
    String? actionErrorMessage,
    String? verifiedKeyringCategoryId,
    String? searchQuery,

    ApiStatus? requestStatus,
    List<NotificationPayload>? notificationPayloads,
    String? loadingRequestId,
    bool? loadingIsAccept,
    bool clearLoading = false,
    
  }) {
    return KeyringState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      originalKeyringData: originalKeyringData ?? this.originalKeyringData,
      apiActionStatus: apiActionStatus ?? this.apiActionStatus,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      verifiedKeyringCategoryId: verifiedKeyringCategoryId ?? this.verifiedKeyringCategoryId,

      notificationPayloads: notificationPayloads ?? this.notificationPayloads,
      requestStatus: requestStatus ?? this.requestStatus,

      loadingRequestId: clearLoading
          ? null
          : loadingRequestId ?? this.loadingRequestId,

      loadingIsAccept: clearLoading
          ? null
          : loadingIsAccept ?? this.loadingIsAccept,
    );
  }
}