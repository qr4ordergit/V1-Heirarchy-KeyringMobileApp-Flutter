
import 'package:keyring/core/enums/enums.dart';

import '../../../data/models/keyring/keyring_model.dart';

class KeyringState {
  final ApiStatus apiStatus;
  final String? errorMessage;
  final List<KeyringData> originalKeyringData;
  final String searchQuery;

  final ApiStatus apiActionStatus;
  final String? actionErrorMessage;
  final String? verifiedKeyringCategoryId;

  const KeyringState({
    this.apiStatus = ApiStatus.initial,
    this.errorMessage,
    this.apiActionStatus = ApiStatus.initial,
    this.originalKeyringData = const [],
    this.actionErrorMessage,
    this.verifiedKeyringCategoryId,
    this.searchQuery = ""
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

}) {
    return KeyringState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      originalKeyringData: originalKeyringData ?? this.originalKeyringData,
      apiActionStatus: apiActionStatus ?? this.apiActionStatus,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
      verifiedKeyringCategoryId: verifiedKeyringCategoryId ?? this.verifiedKeyringCategoryId,
    );
  }
}