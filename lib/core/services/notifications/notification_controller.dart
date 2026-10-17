import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_service.dart';
// @pragma('vm:entry-point')
class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    NotificationService.handleMessage(data: action.payload ?? {});
  }
}