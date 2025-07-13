import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:myride901/core/services/app_component_base.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/models/login_data/login_data.dart';
import 'package:myride901/models/reminder/reminder.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/routes.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

class FirebaseMessagingManager {
  String? _token;
  BuildContext? context;
  String screen = "";
  String? apnsToken;

  Future<void> init({BuildContext? context}) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    this.context = AppComponentBase.getInstance().currentContext;
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new DarwinInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (payload != null) {
        debugPrint('notification payload: $payload');

        // Handle the notification click here
        redirect(jsonDecode(payload));
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging.onMessage " + message.data['notification_type']);

      if (message.notification != null) {
        _showNotificationWithDefaultSound(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message opened: " + message.data['notification_type']);

      if (this.context != null) {
        print('background app');
        redirect(message.data);
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (this.context != null) {
        print('terminate app');
        redirect(message!.data);
      }
    });
  }

  void getVehicleList({String? vehicle_id, String? service_id}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getShareVehicle(isProgressBar: true)
        .then((value) {
      if (value.length > 0) {
        AppComponentBase.getInstance().setArrVehicleProfile(value);
        getServiceList(
            vehicle_id: vehicle_id, service_id: service_id, arrVP: value);
      } else {
        AppComponentBase.getInstance().setArrVehicleProfile([]);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void getServiceList(
      {String? vehicle_id, String? service_id, List<VehicleProfile>? arrVP}) {
    AppComponentBase.getInstance()
        .getApiInterface()
        .getVehicleRepository()
        .getVehicleService(
            vehicleId: vehicle_id, isProgressBar: true, id: vehicle_id)
        .then((value) {
      AppComponentBase.getInstance().setArrVehicleService(value);
      AppComponentBase.getInstance()
          .load({'vehicle_id': vehicle_id, 'service_id': service_id});
      VehicleProfile? selectedProfile;
      for (int i = 0; i < (arrVP ?? []).length; i++) {
        if ((arrVP ?? [])[i].id.toString() == vehicle_id) {
          selectedProfile = (arrVP ?? [])[i];
        }
      }
      VehicleService? selectedService;
      for (int i = 0; i < value.length; i++) {
        if (value[i].id.toString() == service_id) {
          selectedService = value[i];
        }
      }
      if (screen == "service_event") {
        Navigator.of(AppComponentBase.getInstance().currentContext,
                rootNavigator: false)
            .pushNamed(RouteName.serviceDetail,
                arguments: ItemArgument(data: {
                  'vehicleProfile': selectedProfile!,
                  'vehicleService': selectedService!
                }));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void redirect(Map<String, dynamic> dat) async {
    print(dat);
    Map<String, dynamic> a = dat;
    try {
      String? notificationType = a['notification_type'];
      if (notificationType != null) {
        if (notificationType == 'blog') {
          Navigator.pushNamed(AppComponentBase.getInstance().currentContext,
              RouteName.blogTabView);
        }

        if (notificationType == "reminder") {
          handleReminderNotification(a);
        }
      }
    } catch (e) {}
    screen = a["screen"] ?? '';
    if (screen == "new_post") {
      Future.delayed(Duration(milliseconds: 700), () {
        Navigator.pushNamed(AppComponentBase.getInstance().currentContext,
            RouteName.webViewDisplayPage,
            arguments: ItemArgument(data: {
              'url': a['service_id'] ?? '',
              'title': 'Blog',
              'id': 1
            }));
      });
    } else {
      print(a);
      LoginData? loginData = await AppComponentBase.getInstance()
          .getSharedPreference()
          .getUserDetail();
      if (loginData != null &&
          a['vehicle_id'] != null &&
          a['service_id'] != null) {
        AppComponentBase.getInstance()
            .getSharedPreference()
            .setSelectedVehicle(a['vehicle_id'].toString());
        getVehicleList(
            vehicle_id: a['vehicle_id'].toString(),
            service_id: a['service_id'].toString());
      }
    }
  }

  void handleReminderNotification(Map<String, dynamic> notificationData) async {
    String? reminderId = notificationData['reminder_id'];
    Reminder? reminder;
    if (reminderId != null) {
      AppComponentBase.getInstance()
          .getApiInterface()
          .getVehicleRepository()
          .getReminderById(
            reminderId: reminderId,
            id: reminderId,
          )
          .then((value) {
        reminder = value[0];
        Navigator.pushNamed(
          AppComponentBase.getInstance().currentContext,
          RouteName.editReminder,
          arguments: ItemArgument(data: {'reminder': reminder}),
        );
      });
    }
  }

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        try {
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null) {
            _token = await FirebaseMessaging.instance.getToken();
            print("Token: $_token");
          }
        } catch (exception) {
          print("exception = $exception");
        }
      } else {
        _token = await FirebaseMessaging.instance.getToken();
        print("Token: $_token");
      }

      return _token;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  _notificationMessageHandler(message);
}

Future<void> _notificationMessageHandler(RemoteMessage remoteMessage) async {
  RemoteNotification data = remoteMessage.notification ?? RemoteNotification();
  print('data');
  print(remoteMessage.data);

  if (data.title != null && data.body != null) {
    _showNotificationWithDefaultSound(remoteMessage);

    // Check if the notification data contains a reminder ID
  }
}

Future _showNotificationWithDefaultSound(RemoteMessage remoteMessage) async {
  RemoteNotification data = remoteMessage.notification ?? RemoteNotification();
  int id = int.parse(DateFormat('ddHHmmss').format(DateTime.now()));
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'title',
    'channel',
    importance: Importance.max,
    playSound: true,
    styleInformation: BigTextStyleInformation(data.body ?? ''),
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin?.show(
    id,
    data.title,
    data.body,
    platformChannelSpecifics,
    payload: jsonEncode(remoteMessage.data),
  );
}
