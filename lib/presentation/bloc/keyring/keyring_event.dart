abstract class KeyringEvent {}

class GetKeyringDetailsEvent extends KeyringEvent {}

class GetKeyringPasswordEvent extends KeyringEvent {
  final String keyringCategoryId;
  final String otp;
  GetKeyringPasswordEvent({required this.keyringCategoryId, required this.otp});
}

class ResetKeyringActionEvent extends KeyringEvent {
  final String keyringCategoryId;
  ResetKeyringActionEvent({required this.keyringCategoryId});

}

class KeyringCategorySearchEvent extends KeyringEvent {
  final String query;
  KeyringCategorySearchEvent(this.query);
}