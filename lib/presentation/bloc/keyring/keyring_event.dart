import '../../../data/models/notifications/notification_payload.dart';

abstract class KeyringEvent {}

class GetKeyringDetailsEvent extends KeyringEvent {}

class GetKeyringPasswordEvent extends KeyringEvent {
  final String keyringCategoryId;
  final String secretKey;
  GetKeyringPasswordEvent({required this.keyringCategoryId, required this.secretKey});
}

class ResetKeyringActionEvent extends KeyringEvent {
  final String keyringCategoryId;
  ResetKeyringActionEvent({required this.keyringCategoryId});

}

class KeyringCategorySearchEvent extends KeyringEvent {
  final String query;
  KeyringCategorySearchEvent(this.query);
}

class AddNotificationPayloadEvent extends KeyringEvent {
  final NotificationPayload payload;
  AddNotificationPayloadEvent(this.payload);
}

class AcceptRejectKeyringRequest extends KeyringEvent {
  final String keyringCategoryId;
  final String action;
  final String requestId;

  AcceptRejectKeyringRequest({
    required this.keyringCategoryId,
    required this.action,
    required this.requestId,
});
}

class LoadSavedIntervalEvent extends KeyringEvent {}

class GetIntervalEvent extends KeyringEvent {}

class UpdateIntervalEvent extends KeyringEvent {
  int interval;
  UpdateIntervalEvent({required this.interval});
}
