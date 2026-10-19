class NotificationPayload {
  final String? requestId;
  final String? keyringCategoryId;
  final String? keyringCategoryName;

  const NotificationPayload({
    this.requestId,
    this.keyringCategoryId,
    this.keyringCategoryName,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const NotificationPayload();

    return NotificationPayload(
      requestId: map["request_id"],
      keyringCategoryId: map["keyring_category_id"],
      keyringCategoryName: map["keyring_category_name"],
    );
  }

  bool get isEmpty =>
      requestId == null &&
          keyringCategoryId == null &&
          keyringCategoryName == null;

  bool get isNotEmpty => !isEmpty;
}