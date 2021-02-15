import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/screens/detail_statistics_screen.dart';
import 'package:pomodoro_app/states/home_controller.dart';
import 'package:pomodoro_app/states/statistics_controller.dart';
import 'package:pomodoro_app/widgets/stats_circle.dart';

class StatisticsScreen extends StatelessWidget {
  final HomeController homeController = Get.find();
  final StatisticsController statisticsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Column(
        children: [
          Text(
            'STATS',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w200),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatsCircle(
                  innerCircleText: homeController.roundCount.toString(),
                  circleValue: homeController.roundCount / 4,
                  circleDescription: 'Aktuelle Runde',
                ),
                StatsCircle(
                  innerCircleText: homeController.fullRoundCount.toString(),
                  circleValue: 1,
                  circleDescription: 'Pomodoro Runden',
                ),
                StatsCircle(
                  innerCircleText:
                      statisticsController.totalFocusMinutes.toString(),
                  circleValue: 1,
                  circleDescription: 'Fokuszeit insgesamt',
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 26.0, top: 20),
                child: FlatButton(
                  onPressed: () {
                    Get.to(DetailedStatisticsScreen(),
                        transition: Transition.cupertino
                    );
                  },
                  splashColor: Colors.transparent,
                  child: Text(
                    'MORE',
                    style: TextStyle(
                        fontSize: 20,
                        color: PomodoroValues.mainColor,
                        fontWeight: FontWeight.w400),
                  ),
                  color: PomodoroValues.yellowColorOne,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
