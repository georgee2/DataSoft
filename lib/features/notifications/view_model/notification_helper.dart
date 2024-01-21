// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:data_soft/core/firebase_helper.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../app.dart';
import '../../registration/model/registration_model.dart';
import '../../requests/view/requests_screen.dart';
import '../model/notification_model.dart';

sendNotification({required NotificationModel data}) async {
  try {
    sendNotificationToFirebase(data);

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA5MBPWnY:APA91bHbZ0L3KILYTq-VB9hnsYf4YZL38IZZEUfVAUtxsSJc-C8O6q8JQJ6Uz5zNN4YoCUty_ki8km9sxkTid0_MrLxQVcYBWbDkOJXhKpxXy_nPuQLYPUFgVXP4B65YalvfeM6jT1-3'
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode(data.toJson(false)),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
  } catch (e) {
    return false;
  }
}

sendNotificationToFirebase(NotificationModel data) async {
  try {
    final response =
        await FirebaseHelper.notificationPath.add(data.toJson(true));
    await response.update({"NotificationId": response.id});
  } catch (e) {}
}

topicSubscribe() async {
  try {
    await FirebaseMessaging.instance
        .subscribeToTopic(hubData!.userData!.employeeId!);
  } catch (e) {}
}

topicUnSubscribe() async {
  try {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(hubData!.userData!.employeeId!);
  } catch (e) {}
}

getPermission() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await messaging.requestPermission();
  } catch (e) {}
}

Future<void> setupInteractedMessage() async {
  try {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  } catch (e) {}
}

void _handleMessage(RemoteMessage message) {
  notificationAction(
      navigatorKey.currentContext!, message.data['type'].toString());
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

notificationAction(BuildContext context, val, {bool? fromScreen}) {
  if (managerData?.isManager == true) {
    switch (val) {
      case "Plan":
        navigate(context, docType: "Opportunity", fromScreen: fromScreen);
        break;
      case "Permission":
        navigate(context, docType: "Permission", fromScreen: fromScreen);
        break;
      case "Activity":
        navigate(context,
            docType: "Employee Advance",
            expenseType: "Activity",
            fromScreen: fromScreen);
        break;
      case "Expense":
        navigate(context,
            docType: "Employee Advance",
            expenseType: "Expense",
            fromScreen: fromScreen);
        break;
      case "Vacation":
        navigate(context, docType: "Leave Application", fromScreen: fromScreen);
        break;
      case "Settlement":
        navigate(context, docType: "Expense Claim", fromScreen: fromScreen);
        break;
      case "Task":
        navigate(context, docType: "ToDo", fromScreen: fromScreen);
        break;
      default:
        navigate(context, docType: val, fromScreen: fromScreen);
    }
  } else {
    switch (val) {
      case "Employee AdvanceActivity":
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.Activities);
        break;
      case "Employee AdvanceExpense":
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.Expenses);
        break;
      case "Permission":
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.PERMISSIONS);
        break;
      case "Opportunity":
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.Plans);
        break;
      case "Expense Claim":
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.Settlement);
        break;
      case "ToDo":
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.Tasks);
        break;
      case "Leave Application":
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.Vacation);
        break;
      default:
        navigateAndKill(
            context: context, navigateAndKill: NavigateAndKill.Home);
    }
  }
}

navigate(context, {screen, docType, expenseType, required bool? fromScreen}) {
  if (fromScreen == true) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RequestsScreen(docType: docType, expenseType: expenseType),
        ));
  } else {
    viewNotificationScreen =
        RequestsScreen(docType: docType, expenseType: expenseType);
  }
}

updateNotification(notificationId) async {
  try {
    await FirebaseHelper.notificationPath
        .doc(notificationId)
        .update({"isRead": true});
  } catch (e) {}
}
