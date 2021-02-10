import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';

class LegalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PomodoroValues.cardColor,
          title: Text(
            PomodoroTimerValues.appTitle,
            style: PomodoroValues.customTextTheme.headline1,
          ),
          centerTitle: true,
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: PomodoroValues.mainColor,
              size: 26,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: PomodoroValues.cardColor,
        body: Container());
  }
}
