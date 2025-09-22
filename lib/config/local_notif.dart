import 'dart:convert';
import 'dart:developer';
import '../core/helper/cache_helper/cache_helper.dart';
import '../main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void _onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  log('background: ${notificationResponse.id}');
  _handleNotificationResponse(notificationResponse);
}

void _handleNotificationResponse(NotificationResponse notificationResponse) {
  log('payload: ${notificationResponse.payload}');
  final payloadJson = notificationResponse.payload;
  if (payloadJson == null) return;

  final payload = jsonDecode(payloadJson) as Map;
  print("from local notification");
  print(payload['navigate_to']);
  if (payload.containsKey('navigate_to')) {
    navigatorKey.currentState?.pushNamed(
      payload['navigate_to'],
      arguments: {
        "url":
            "https://schools.alkhwarizmi.xyz/${CacheHelper.getdata(key: "projectId")}/AgentChatMobile/${CacheHelper.getdata(key: "userId")}?clientRequestId=${payload['clientRequestId']}",
      },
    );
  }
}

class LocalNotif {
  static final _notifPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    _notifPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: (notificationResponse) {
        log('foreground: ${notificationResponse.id}');
        _handleNotificationResponse(notificationResponse);
      },
    );
  }

  // handle notif from terminate state
  static initialMessage() async {
    final notifAppLaunchDetails =
        await _notifPlugin.getNotificationAppLaunchDetails();
    if (notifAppLaunchDetails == null) return;

    final appOpenViaNotif = notifAppLaunchDetails.didNotificationLaunchApp;
    if (appOpenViaNotif) {
      final notifResponse = notifAppLaunchDetails.notificationResponse;
      if (notifResponse == null) return;
      _handleNotificationResponse(notifResponse);
    }
  }

  static NotificationDetails _defaultNotifDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName'),
      iOS: DarwinNotificationDetails(),
    );
  }

  static void showNotif({
    int id = 0,
    String? title,
    String? body,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    await _notifPlugin.show(
      id,
      title,
      body,
      notificationDetails ?? _defaultNotifDetails(),
      payload: payload,
    );
  }

  static cancelNotif() async {
    await _notifPlugin.cancelAll();
  }
}
