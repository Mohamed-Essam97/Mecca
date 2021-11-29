import 'dart:async';
import 'dart:io';

import 'package:Mecca/core/models/user.dart';
import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/pages/user/Home_Page/home_page.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:Mecca/ui/widgets/notification_widget.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../auth/authentication_service.dart';
import '../navigaation_service.dart';

/*
* 🦄initiated at the app start to listen to notifications..
*/
class NotificationService {
  final AuthenticationService auth;
  BuildContext context;
  List<dynamic> userNotifications;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  NotificationService({this.auth});

  Future<void> init(context) async {
    String token = await _firebaseMessaging.getToken();
    print("Firebase token : $token");
    Preference.setString(PrefKeys.fcmToken, token);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage : $message");
        operateMessage(message, context);
      },
      onResume: (Map<String, dynamic> message) async {
        operateMessage(message, context);
        print("onResume : $message");
        print(message);
        if (message['data'] != null) {
          Map<String, dynamic> js = message['data'];
          try {
            if (js['profileActivation'] == 'true' ? true : false ?? false) {
              navService.pushNamed('/ProviderHome');
            } else {
              navService.pushNamed('/ProviderHome');
            }
            print("onLunch : $message");
          } catch (e) {
            print(e);
          }
        } else {
          navService.pushNamed('/ProviderHome');
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        operateMessage(message, context);

        print("onLunch : $message");
        if (message['data'] != null) {
          Map<String, dynamic> js = message['data'];
          try {
            if (js['profileActivation'] == 'true' ? true : false ?? false) {
              navService.pushNamed('/ProviderHome');
            } else {
              navService.pushNamed('/ProviderHome');
            }
            print("onLunch : $message");
          } catch (e) {
            print(e);
          }
        } else {
          navService.pushNamed('/ProviderHome');
        }
      },
    );

    if (Platform.isIOS) await getIOSPermission();

    await _firebaseMessaging.getToken().then(updateFCMToken);
  }

  Future<void> updateFCMToken(token) async {
    if (token != null) {
      try {
        //TODO update fcm implementation
        Preference.setString(PrefKeys.fcmToken, token);

        print('new fcm:$token');
      } catch (e) {
        print('error updating fcm');
      }
    }
  }

  operateMessage(Map<String, dynamic> message, BuildContext context,
      {bool showOverlay = true}) async {
    String body;
    String title;
    Map<dynamic, dynamic> data;
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS &&
        int.parse((await deviceInfo.iosInfo).systemVersion.split('.')[0]) <
            13) {
      final messageData = message['aps']['alert'];
      title = messageData['title'];
      body = messageData['body'];
      data = message['data'];
    } else {
      final messageData = message['notification'];
      title = messageData['title'];
      body = messageData['body'];
      data = message['data'];
    }

    bool active = data['profileActivation'] == 'true' ? true : false ?? false;
    // Provider.of<AuthenticationService>(context, listen: false)
    //     .user
    //     .user
    //     .isActive = active;
    Consumer<AuthenticationService>(
        builder: (BuildContext ctx, AuthenticationService auth, _) {
      auth.user.user.isActive = active;
      return Container();
    });
    if (active) {
      // print("====> " + auth.user.user.isActive.toString());
      // UI.push(context, ProviderHomePage());

      navService.pushNamed('/ProviderHome');
    }

    print(active);

    //TODO implement behavior
    showOverlayNotification(
        (context) => Notify(title: title, body: body, data: data),
        duration: Duration(seconds: 8));
  }

  getIOSPermission() async {
    await _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    // final iosSubscription = _firebaseMessaging.onIosSettingsRegistered.listen((data) {
    //       _saveDeviceToken();
    //     });
  }
}
