import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:meesho_dice/main.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/social/invite_notification_page.dart';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.notification!.title);
  print(message.notification!.body);
  print(message.data);
}

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: "This channel is used for important notifications",
      importance: Importance.defaultImportance);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // if (navigatorKey.currentState == null) {
    //   print("Null Navigator key");
    //   return;
    // }
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => InviteNotificationPage(
              message: message,
            )));
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/background')),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/background');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
      handleMessage(message);
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initNotifications() async {
    await messaging.requestPermission();
    final deviceToken = await messaging.getToken();
    print(deviceToken);
    if (deviceToken != null) {
      FirebaseServices().updateDeviceTokenForUser(deviceToken);
    }
    initPushNotification();
    initLocalNotifications();
    String accessToken = await getGoogleCloudAccessToken();
    print(accessToken);
  }

  void getNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    print(settings.authorizationStatus.name);
  }

  Future<String?> getDeviceToken() async {
    final deviceToken = await messaging.getToken();
    print(deviceToken);
    return deviceToken;
  }

  Future onTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      print(event);
    });
  }

  Future<String> getGoogleCloudAccessToken() async {
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "meesho-dice-9bfa9",
          "private_key_id": "250ba66ea2166e4a6c2610db06e476d4c260655d",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDB7SeJLm3p5LM0\nJ28ptGHUS8MDx/OQ0f/I0tT6d1tx9nD9nXPiVRmggRbHUuMKk8xarl9aj3lJ2U3A\nv4EpYENRwnzHR6BHehOKqXg3745RX1dSs3SkJwxuyVPGxCDpGasuf2R0sUlNoGwW\n7Svujee51cMiAfBC3F7y0NTUzepl4F0PBb+7yqonSzXFEL0fYl4n+UJeC1WjcFgv\nA+r+TGT4qMO6FYeYhC2qQWFmPsAy0jaIVJBM3X/Q5SDrXEcBjAt4VIfgqu+US11r\nBXgx/B68N1V+m9cCwuCY6Pydk6Lb6iGRj/hhIYw4eBY0kJjOCOd24vBLMul8nKz/\na072zyDZAgMBAAECggEAAWW8VnJ5c8lEWlCbbjVAzDcUi2suL+G3gmK0iq5///D6\n7PTswBmFYwDzIVIRVULt4sxlXwFwKg5RD13B6EKrkYQBgq0bNFCmoeXpOhv1jlQN\nzMiCw2kNn6G/QwwoQY3ADEh6OJYLdW39wWeJnME0hYQLESxq5wxv+bd0BSmLshq5\n0tsPHEsL25F/vjpJOCCNJY8x/dcLcs56j1QUjyCGo3DpBjroT7Aut3kWmf8BABPY\nXXTw86DeMHU9F88Kl76XPF4lglY6Qs6WUG6wjPNK7Lp0Zrl68u0ZjWeB2CL09TuQ\no4JaJyt4xsWV6CZho8LZjIKLZ2ZNggJFMOvqKvt0QQKBgQDgyhe1Ye/MVWWqrzXF\nu389cqOo5BdprOi26p9xJlS/qJiapujSCTPFaxQkMMRmHpzeICYxQevts1IXBU7C\n9OLo5oRYKa/pAZLtgf6PIzryEsPrY1Df41CoO5nzSXZXM3ipcu9HCKH6xinMX5I/\nBBl2HvlXqWsr62D3Wb44GJuV+QKBgQDc2hEopwRjydfShI+Ce3Tvlu19z5Ur3805\nj+/9DS5jVOpeZO5Yz7Ct0g1Z5MkXfmfKWjEhnSIvr5HtRyYZPTahTfsT8SBgZ7T7\nwf6nHkn7ui9yrs3rp3u3406hcPPpB/kyJn4usO0ZPhG/vlc7OB61C22BWj+Xc89R\nzKYhFoMZ4QKBgEoXMkNNmX1O9GiSwXV//Etjmr/TFkh1fmqz4IOp76sQReRLeVep\nQtAiIAxhqopCMtAf5pa7tKivPzJpRHGLx7KeMCbi7qEtLKFuBFpncUlSmBLgtEpn\nITGiG3cN0pyhUXcAdA+Er+b5I9PB+HEex8mgIe0b4UAjn91HTiQtMDL5AoGBAICP\nmIl3oACO0MnFTN0CDPIjg6BHJGjj4M1vUp6V+7jrB3tnea/NRuYIbqkzmzPH65dJ\npWwR0oK7y1C6qBztG04O3Oeg5932wM4FAb46zYpxuYki5NAXMNe8xFsKK5ItiAx/\nh9iaOYsGLMLXhGP+qTFus5Im/Pmm+rp9TP/Z4PtBAoGBANSKordosFlKFB26MGzs\nx0tVO7RURsm0rLKvKo9K7PSIynDE5Y3NfqOlOEjip5yZaHayIZYE9456FTwqSsND\nAJIwWG3KW1vyp3utaUp0C4sAViarDTOHLmTT65ci1BGqwz8BTtOfLHoadiYRZkMv\nXMMpAXQM96IlhP5/rpuKKGih\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-l1stb@meesho-dice-9bfa9.iam.gserviceaccount.com",
          "client_id": "116570170944985068463",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-l1stb%40meesho-dice-9bfa9.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [firebaseMessagingScope]);

    final accessToken = client.credentials.accessToken.data;
    return accessToken;
  }

  Future sendTokenNotification(String token, String title, String message,
      Map<String, String> data) async {
    try {
      final body = {
        'message': {
          'token': token,
          'notification': {'body': message, 'title': title},
          'data': data
        }
      };
      String url =
          'https://fcm.googleapis.com/v1/projects/meesho-dice-9bfa9/messages:send';
      String accessKey = await getGoogleCloudAccessToken();

      await http
          .post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessKey'
              },
              body: jsonEncode(body))
          .then((value) {
        print(value.statusCode);
      });
    } catch (e) {
      print(e);
    }
  }
}
