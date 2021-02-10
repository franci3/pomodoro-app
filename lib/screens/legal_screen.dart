import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/widgets/license_screen.dart';

class LegalScreen extends StatelessWidget {
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: PomodoroValues.mainColor,
            size: 26,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: PomodoroValues.cardColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0)
                .add(EdgeInsets.only(top: 100)),
            child: MaterialButton(
              onPressed: () {},
              color: PomodoroValues.redColor,
              elevation: 15,
              child: Text(
                'Statistiken zurücksetzen',
                style: PomodoroValues.customTextTheme.subtitle2,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Text(
                PomodoroTimerValues.legalGreetingsParagraph,
                style: PomodoroValues.customTextTheme.bodyText2,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('MADE WITH'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
          LicenseScreen()
        ],
      ),
    );
  }
}
