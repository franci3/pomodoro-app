import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pomodoro_app/controller/timer_controller.dart';
import 'package:pomodoro_app/widgets/stats_circle.dart';
import 'package:provider/provider.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerController>(
      builder: (BuildContext context, TimerController timerController, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            children: [
              const Text(
                'STATS',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w200),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatsCircle(
                    innerCircleText:
                        timerController.timerModel.roundCount.toString(),
                    circleValue: timerController.timerModel.roundCount / 4,
                    circleDescription: AppLocalizations.of(context)!.round,
                  ),
                  StatsCircle(
                    innerCircleText:
                        timerController.timerModel.fullRoundCount.toString(),
                    circleValue: 1,
                    circleDescription: AppLocalizations.of(context)!.sessions,
                  ),
                  StatsCircle(
                    innerCircleText: 'To be done',
                    circleValue: 1,
                    circleDescription: AppLocalizations.of(context)!.focusTime,
                  )
                ],
              ),
              /*Row(
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
            )*/
            ],
          ),
        );
      },
    );
  }
}
