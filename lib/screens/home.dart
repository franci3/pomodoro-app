import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/screens/card_screen.dart';
import 'package:pomodoro_app/screens/statistics_screen.dart';
import 'package:pomodoro_app/states/home_controller.dart';

class PomodoroHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PomodoroValues.cardColor,
        title: Text(
          'Pomodoro',
          style: PomodoroValues.customTextTheme.headline1,
        ),
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          CardScreen(),
          StatisticsScreen()
        ],
      ),
    );
  }
}
