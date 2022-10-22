import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/controller/data_controller.dart';
import 'package:pomodoro_app/models/database/settings_model.dart';
import 'package:pomodoro_app/screens/home/pomodoro_home_screen.dart';
import 'package:pomodoro_app/widgets/column_padding.dart';
import 'package:video_player/video_player.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class EnableNotificationsScreen extends StatelessWidget {
  const EnableNotificationsScreen({Key? key}) : super(key: key);

  Future<bool?> _requestPermissions() async {
    if (Platform.isIOS) {
      return await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestPermission();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    DatabaseController databaseController = DatabaseController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PomodoroValues.cardColor,
          title: Text(
            PomodoroTimerValues.appTitle,
            style: PomodoroValues.customTextTheme.headline1,
          ),
          centerTitle: true,
          shadowColor: Colors.transparent,
        ),
        backgroundColor: PomodoroValues.cardColor,
        body: ColumnPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.enableNotificationsTitle,
                style: PomodoroValues.customTextTheme.subtitle1,
              ),
              const Spacer(),
              const EnableNotificationsAnimation(
                width: 125,
              ),
              const Spacer(),
              Text(AppLocalizations.of(context)!.enableNotificationsDescription,
                  style: PomodoroValues.customTextTheme.subtitle2),
              const Spacer(),
              MaterialButton(
                height: 50,
                onPressed: () async {
                  await _requestPermissions()
                      .then((bool? notificationsEnabled) async {
                    final Settings settings = Settings(
                        lastUpdatedAt: DateTime.now(),
                        enableNotifications: notificationsEnabled ?? false);
                    await databaseController
                        .writeSettings(settings.toString())
                        .then((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PomodoroHome()),
                          (Route route) => false);
                    });
                  });
                },
                color: PomodoroValues.orangeColor,
                elevation: 15,
                child: Text(
                  AppLocalizations.of(context)!.enableNotifications,
                  style: PomodoroValues.customTextTheme.subtitle2,
                ),
              ),
              const Spacer(
                flex: 2,
              )
            ],
          ),
        ));
  }
}

class EnableNotificationsAnimation extends StatefulWidget {
  const EnableNotificationsAnimation({Key? key, required this.width})
      : super(key: key);
  final double width;

  @override
  State<EnableNotificationsAnimation> createState() =>
      _EnableNotificationsAnimationState();
}

class _EnableNotificationsAnimationState
    extends State<EnableNotificationsAnimation> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('lib/assets/videos/notification_video.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    _controller.setLooping(true);
    _controller.setVolume(0);
    _controller.play();
    final double height = widget.width * (2532 / 1170);
    return Column(
      children: [
        Center(
          child: _controller.value.isInitialized
              ? SizedBox(
                  width: widget.width,
                  height: height,
                  child: VideoPlayer(_controller))
              : Container(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
