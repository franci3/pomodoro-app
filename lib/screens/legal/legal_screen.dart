import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/widgets/license_widget.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({Key? key}) : super(key: key);

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
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: PomodoroValues.cardColor,
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                PomodoroTimerValues.legalGreetingsParagraph,
                style: PomodoroValues.customTextTheme.bodyText2,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('MADE WITH'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 24,
                  color: Colors.redAccent,
                ),
              ),
              Text('BY FRANCO')
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Divider(
              color: PomodoroValues.mainColor,
            ),
          ),
          const LicensesWidget()
        ],
      ),
    );
  }
}
