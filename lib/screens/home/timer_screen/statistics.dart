import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/controller/timer_controller.dart';
import 'package:pomodoro_app/widgets/stats_circle.dart';
import 'package:provider/provider.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  String getDayAndDateFormatted(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate =
        DateFormat.yMMMMEEEEd(AppLocalizations.of(context)?.localeName).format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerController>(
      builder: (BuildContext context, TimerController timerController, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    getDayAndDateFormatted(context),
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w200),
                  ),
                ],
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
                    innerCircleText: timerController.totalFocusTime.toString(),
                    circleValue: 1,
                    circleDescription: AppLocalizations.of(context)!.focusTime,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
