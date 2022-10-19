import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/controller/timer_controller.dart';
import 'package:pomodoro_app/widgets/license_widget.dart';
import 'package:provider/provider.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: MaterialButton(
              onPressed: () {
                Provider.of<TimerController>(context, listen: false)
                    .resetData();
                Navigator.pop(context);
              },
              color: PomodoroValues.redColor,
              elevation: 15,
              child: Text(
                AppLocalizations.of(context)!.resetData,
                style: PomodoroValues.customTextTheme.subtitle2,
              ),
            ),
          ),
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
