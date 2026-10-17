class NotificationPayload {
  final String? requestId;
  final String? keyringCategoryId;
  // final String? keyringCategoryName;
  // final String? otp;

  const NotificationPayload({
    this.requestId,
    this.keyringCategoryId,
    // this.keyringCategoryName,
    // this.otp,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const NotificationPayload();

    return NotificationPayload(
      requestId: map["request_id"],
      keyringCategoryId: map["keyring_category_id"],
      // keyringCategoryName: map["keyring_category_name"],
      // otp: map["otp"],
    );
  }

  bool get isEmpty =>
      requestId == null &&
          keyringCategoryId == null;
          // keyringCategoryName == null;
          // otp == null;

  bool get isNotEmpty => !isEmpty;
}