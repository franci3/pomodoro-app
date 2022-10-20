import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/home/timer_screen/statistics.dart';
import 'package:pomodoro_app/screens/home/timer_screen/timer_card.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TimerCard(),
        Statistics(),
      ],
    );
  }
}
