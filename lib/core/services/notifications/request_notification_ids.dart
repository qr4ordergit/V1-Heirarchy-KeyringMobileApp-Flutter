
class RequestNotificationIds {
  RequestNotificationIds._();

  // Stable ID for the same request across app launches.
  static int fromRequestId(String requestId) {
    var hash = 0x811c9dc5;

    for (final unit in requestId.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }

    return hash == 0 ? 1 : hash;
  }
}
