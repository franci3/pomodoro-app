import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/states/home_controller.dart';
import 'package:pomodoro_app/widgets/circles_painter_widget.dart';

class CardScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: PomodoroValues.cardColor,
      elevation: 15,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(200, 100),
                painter: CirclesPainter(),
              ),
              Obx(
                () => Container(
                  width: 250,
                  height: 250,
                  decoration: new BoxDecoration(
                    backgroundBlendMode: BlendMode.lighten,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0x66ffffff),
                        const Color(0x1Affffff),
                      ],
                    ),
                    borderRadius: new BorderRadius.circular(125),
                  ),
                  child: CircularProgressIndicator(
                      value: _calculateCountdownLoader(homeController),
                      strokeWidth: 18,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          PomodoroValues.mainColor)),
                ),
              ),
              _countdownWidget(homeController)
            ],
          ),
        ),
      ),
    );
  }

  double _calculateCountdownLoader(HomeController homeController) {
    return 1 -
        (homeController.totalSeconds.value /
            homeController.animationSeconds.value);
  }
}

Widget _countdownWidget(HomeController homeController) {
  return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          homeController.countdownText(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              homeController.timerIsActive.isTrue
                  ? IconButton(
                      iconSize: 40,
                      color: PomodoroValues.mainColor,
                      onPressed: () => homeController.pauseTimer(),
                      icon: Icon(homeController.timerIsPaused.isTrue
                          ? Icons.play_arrow
                          : Icons.pause),
                    )
                  : Container(),
              IconButton(
                  iconSize: 40,
                  color: PomodoroValues.mainColor,
                  onPressed: () => homeController.startTimer(),
                  icon: Icon(homeController.timerIsActive.isTrue
                      ? Icons.stop
                      : Icons.play_arrow)),
            ],
          )
        ],
      ));
}
