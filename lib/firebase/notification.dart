import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../view/homeScreen.dart';

void fireNotification() async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  var idToken = await firebaseMessaging.getToken();
  print("Token  := $idToken");

  FirebaseMessaging.onBackgroundMessage(messageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    var data = message.notification!.body;
    var title = message.notification!.title;

    notificationData("$title", "$data");

    print("============== Title : $title \n Body : $data");
  });
}

Future<void> messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void notificationData(String title,String body)async {
  AndroidNotificationDetails android =
  AndroidNotificationDetails(
    "1",
    "android",
    priority: Priority.high,
    importance: Importance.max,
  );

  NotificationDetails nd =
  NotificationDetails(android: android);

  await flnp!.show(1, "$title", "$body", nd);

}