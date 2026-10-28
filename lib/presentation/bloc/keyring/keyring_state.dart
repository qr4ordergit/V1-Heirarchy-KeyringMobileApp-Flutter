
import 'package:keyring/core/enums/enums.dart';

import '../../../data/models/notifications/notification_payload.dart';
import '../../../data/models/keyring/keyring_model.dart';

class KeyringState {
  final ApiStatus apiStatus;
  final String? errorMessage;
  final List<KeyringData> originalKeyringData;
  final List<AccessRequest> pendingRequests;
  final String searchQuery;

  final ApiStatus apiActionStatus;
  final String? actionErrorMessage;
  final String? verifiedKeyringCategoryId;

  final ApiStatus requestStatus;
  final String? loadingRequestId;
  final bool? loadingIsAccept;

  final ApiStatus intervalStatus;
  final ApiStatus intervalUpdateStatus;
  final String? intervalMessage;
  final int interval;

  const KeyringState({
    this.apiStatus = ApiStatus.initial,
    this.errorMessage,
    this.apiActionStatus = ApiStatus.initial,
    this.originalKeyringData = const [],
    this.pendingRequests = const [],
    this.actionErrorMessage,
    this.verifiedKeyringCategoryId,
    this.searchQuery = "",
    this.requestStatus = ApiStatus.initial,
    this.loadingRequestId,
    this.loadingIsAccept,

    this.intervalStatus = ApiStatus.initial,
    this.intervalUpdateStatus = ApiStatus.initial,
    this.intervalMessage,
    this.interval = 120,
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
    List<AccessRequest>? pendingRequests,
    ApiStatus? apiActionStatus,
    String? actionErrorMessage,
    String? verifiedKeyringCategoryId,
    String? searchQuery,

    ApiStatus? requestStatus,
    String? loadingRequestId,
    bool? loadingIsAccept,
    bool clearLoading = false,

    ApiStatus? intervalStatus,
    ApiStatus? intervalUpdateStatus,
    String? intervalMessage,
    int? interval,
  }) {
    return KeyringState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      originalKeyringData: originalKeyringData ?? this.originalKeyringData,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      apiActionStatus: apiActionStatus ?? this.apiActionStatus,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      verifiedKeyringCategoryId: verifiedKeyringCategoryId ?? this.verifiedKeyringCategoryId,
      intervalStatus: intervalStatus ?? this.intervalStatus,
      intervalUpdateStatus: intervalUpdateStatus ?? this.intervalUpdateStatus,
      intervalMessage: intervalMessage,
      interval: interval ?? this.interval,

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