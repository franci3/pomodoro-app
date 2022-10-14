import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/screens/home/statistics.dart';
import 'package:pomodoro_app/screens/home/timer_card.dart';
import 'package:pomodoro_app/screens/legal/legal_screen.dart';

class PomodoroHome extends StatelessWidget {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 10),
            child: IconButton(
              icon: Icon(Icons.info, color: PomodoroValues.mainColor, size: 26),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LegalScreen()));
              },
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: const [TimerCard(), Statistics()],
      ),
    );
  }
}
