import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/controller/timer_controller.dart';
import 'package:pomodoro_app/models/timer_model.dart';
import 'package:pomodoro_app/widgets/circles_painter_widget.dart';
import 'package:provider/provider.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerController>(
      builder: (BuildContext context, TimerController timer, _) {
        return Card(
          margin: EdgeInsets.zero,
          color: PomodoroValues.cardColor,
          elevation: 15,
          shape: const RoundedRectangleBorder(
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
                      Text(
                        timer.timerModel.focusPauseRound
                            ? AppLocalizations.of(context)!.breakTitle
                            : AppLocalizations.of(context)!.sessionTitle,
                        style: PomodoroValues.customTextTheme.subtitle2,
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(200, 100),
                        painter: CirclesPainter(),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.lighten,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              PomodoroValues.gradientColorOne,
                              PomodoroValues.gradientColorTwo
                            ],
                          ),
                          borderRadius: BorderRadius.circular(125),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                              value: 1 -
                                  (timer.timerModel.totalSeconds /
                                      timer.timerModel.animationSeconds),
                              strokeWidth: 16,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  PomodoroValues.yellowColorTwo)),
                        ),
                      ),
                      const CountDownWidget()
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CountDownWidget extends StatelessWidget {
  const CountDownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimerController timerController =
        Provider.of<TimerController>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CountdownText(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (timerController.timerModel.timerIsActive)
              IconButton(
                iconSize: 40,
                color: PomodoroValues.yellowColorOne,
                onPressed: () => timerController.pauseTimer(),
                icon: Icon(timerController.timerModel.timerIsPaused
                    ? Icons.play_arrow
                    : Icons.pause),
              )
            else
              Container(),
            IconButton(
                iconSize: 40,
                color: PomodoroValues.yellowColorOne,
                onPressed: () => timerController.startTimer(),
                icon: Icon(timerController.timerModel.timerIsActive
                    ? Icons.stop
                    : Icons.play_arrow)),
          ],
        )
      ],
    );
  }
}

class CountdownText extends StatelessWidget {
  const CountdownText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimerModel timerModel =
    Provider.of<TimerController>(context).timerModel;
    if (timerModel.minutes < 10 && timerModel.seconds < 10) {
      return Text(
        '0${timerModel.minutes}:0${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else if (timerModel.minutes < 10) {
      return Text(
        '0${timerModel.minutes}:${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else if (timerModel.seconds < 10) {
      return Text(
        '${timerModel.minutes}:0${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else {
      return Text(
        '${timerModel.minutes}:${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    }
  }

}