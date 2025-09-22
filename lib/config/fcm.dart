import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../core/helper/cache_helper/cache_helper.dart';
import '../firebase_options.dart';
import '../main.dart';
import 'local_notif.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("background!");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RemoteMessage? messageFromInitial =
      await FirebaseMessaging.instance.getInitialMessage();
  if (messageFromInitial != null) {
    _handleMessage(messageFromInitial);
  }
  // _showCustomNotif(message);
}

void _handleMessage(RemoteMessage message) {
  Map data = message.data;

  print("from handleMessage");

  print(data['navigate_to']);
  // navigatorKey.currentState?.pushNamed(data['navigate_to'].toString());
  if(CacheHelper.getdata(key: "userToken") != null){
    if (data.containsKey('navigate_to')) {
      if(navigatorKey.currentState !=null){
        navigatorKey.currentState?.pushNamed(
          data['navigate_to'],
          arguments: {
            "url":
            "https://schools.alkhwarizmi.xyz/${CacheHelper.getdata(key: "projectId")}/AgentChatMobile/${CacheHelper.getdata(key: "userId")}?clientRequestId=${data['clientRequestId']}",
            "notificationId": data['clientRequestId']
          },
        );
      }else{
        print("its null");
      }
    }
  }

}

Future<void> _initializeCache() async {
  try {
    await CacheHelper.init();
  } catch (error) {
    print("Error initializing cache: $error");
  }
}

Future<void> _showCustomNotif(RemoteMessage message) async {
  // if (message.notification != null) {
  //   LocalNotif.showNotif(
  //     id: message.hashCode,
  //     title: message.notification!.title,
  //     body: message.notification!.body,
  //     payload: jsonEncode(message.data),
  //   );
  // }
  await _initializeCache().then(
    (value) async {
      if (message.data.containsKey('notif_title')) {
        await CacheHelper.saveData(
            key: "notificationId", value: message.data['clientRequestId']);
        LocalNotif.showNotif(
          id: message.hashCode,
          title: message.data['notif_title'],
          body: message.data['notif_body'],
          payload: jsonEncode(message.data),
        );
      }
    },
  );
}

class FCM {
  static Future<void> init() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final settings = await FirebaseMessaging.instance.requestPermission();
    log('User granted permission: ${settings.authorizationStatus}');
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the token locally in shared preferences
    if (token != null) {
      // Store token in Firestore
      // String? userId = await getDeviceId();
      await CacheHelper.saveData(key: "fcmToken", value: token);
      // String? userId = "تليفون المكتب";
      // await FirebaseFirestore.instance.collection('users').doc(userId).set(
      //   {'fcmToken': token},
      //   SetOptions(
      //       merge:
      //       true), // Merge keeps existing data while updating/adding fcmToken
      // );
    }
    _foregroundHandler();
    _backgroundHandler();
    _listenOpenNotif();
  }

  static _foregroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('foreground!');
      _showCustomNotif(message);
    });
  }

  static _backgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static initialMessage() async {
    log("initialMessage");
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  static _listenOpenNotif() {
    log("listenOpenNotif");
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
}
