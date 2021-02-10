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
          padding: const EdgeInsets.only(top: 30.0, bottom: 100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      homeController.focusPauseRound.isTrue
                          ? 'BREAK'
                          : 'SESSION',
                      style: PomodoroValues.customTextTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Stack(
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
                            PomodoroValues.gradientColorOne,
                            PomodoroValues.gradientColorTwo
                          ],
                        ),
                        borderRadius: new BorderRadius.circular(125),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                            value: _calculateCountdownLoader(homeController),
                            strokeWidth: 16,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                PomodoroValues.yellowColorTwo)),
                      ),
                    ),
                  ),
                  _countdownWidget(homeController)
                ],
              ),
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
                      color: PomodoroValues.yellowColorOne,
                      onPressed: () => homeController.pauseTimer(),
                      icon: Icon(homeController.timerIsPaused.isTrue
                          ? Icons.play_arrow
                          : Icons.pause),
                    )
                  : Container(),
              IconButton(
                  iconSize: 40,
                  color: PomodoroValues.yellowColorOne,
                  onPressed: () => homeController.startTimer(),
                  icon: Icon(homeController.timerIsActive.isTrue
                      ? Icons.stop
                      : Icons.play_arrow)),
            ],
          )
        ],
      ));
}
