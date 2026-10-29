import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_action_service.dart';
import 'notification_navigation_handler.dart';

@pragma("vm:entry-point")
class NotificationController {
  /// Use this method to detect when the user taps on a notification or action button
  // @pragma('vm:entry-point')
  // static Future<void> onActionReceivedMethod(
  //     ReceivedAction receivedAction,
  //     ) async {
  //   final actionKey = receivedAction.buttonKeyPressed;
  //
  //   final payload = <String, String>{
  //     for (final entry
  //     in (receivedAction.payload ?? <String, String?>{}).entries)
  //       if (entry.value != null) entry.key: entry.value!,
  //   };
  //
  //   if (actionKey == 'ACCEPT' || actionKey == 'REJECT') {
  //     final handler = await NotificationActionService.create();
  //
  //     await handler.handle(
  //       action: actionKey,
  //       payload: payload,
  //     );
  //
  //     return;
  //   }
  //   // Normal notification tap: open the Keyring screen.
  //   NotificationNavigationHandler.handleMessage(
  //     data: payload,
  //   );
  // }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    NotificationNavigationHandler.handleMessage(
      data: receivedAction.payload ?? {},
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

}