import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/controller/data_controller.dart';
import 'package:pomodoro_app/controller/timer_controller.dart';
import 'package:pomodoro_app/models/database/settings_model.dart';
import 'package:pomodoro_app/screens/enable_notifications_screen.dart';
import 'package:pomodoro_app/screens/home/pomodoro_home_screen.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  final Logger logger = Logger();
  // ignore: avoid_print
  logger.i('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    logger.i(
        'notification action tapped with input: ${notificationResponse.input}');
  }
  logger.close();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Paint.enableDithering = true;

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
  );

  final InitializationSettings initializationSettings =
      InitializationSettings(iOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground);

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => TimerController(),
      child: const Pomodoro(),
    ),
  );
}

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  final DatabaseController databaseController = DatabaseController();
  late Future<Settings> getSettings;

  @override
  void initState() {
    getSettings = databaseController.readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pomodoro App',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: PomodoroValues.customTheme,
        home: FutureBuilder(
          future: getSettings,
          builder: (BuildContext context, AsyncSnapshot<Settings> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return Container();
            } else {
              if (!snapshot.data!.enableNotifications && snapshot.data!.lastUpdatedAt == null) {
                return const EnableNotificationsScreen();
              } else {
                return PomodoroHome();
              }
            }
          },
        ));
  }
}
