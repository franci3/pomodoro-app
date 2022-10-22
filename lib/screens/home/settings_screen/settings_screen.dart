import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/controller/data_controller.dart';
import 'package:pomodoro_app/controller/timer_controller.dart';
import 'package:pomodoro_app/models/database/settings_model.dart';
import 'package:pomodoro_app/widgets/minute_switch.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late Future<Settings> getSettings;

  Future<Settings> readDatabaseValues() async {
    final DatabaseController databaseController = DatabaseController();
    return databaseController.readSettings();
  }

  @override
  void initState() {
    getSettings = readDatabaseValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: PomodoroValues.cardColor,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(45),
              bottomLeft: Radius.circular(45))),
      child: Padding(
          padding: const EdgeInsets.only(top: 30.0)
              .add(const EdgeInsets.symmetric(horizontal: 32)),
          child: FutureBuilder(
            future: getSettings,
            builder: (BuildContext context, AsyncSnapshot<Settings> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                return CircularProgressIndicator(
                  color: PomodoroValues.mainColor,
                );
              } else {
                print(snapshot.data);
                return SettingsValues(settings: snapshot.data!);
              }
            },
          )),
    );
  }
}

class SettingsValues extends StatefulWidget {
  const SettingsValues({Key? key, required this.settings}) : super(key: key);
  final Settings settings;

  @override
  State<SettingsValues> createState() => _SettingsValuesState();
}

class _SettingsValuesState extends State<SettingsValues> {

  late Settings currentSettings;
  final DatabaseController databaseController = DatabaseController();

  @override
  void initState() {
    currentSettings = Settings(
      lastUpdatedAt: widget.settings.lastUpdatedAt,
      shortPauseMinutes:  widget.settings.shortPauseMinutes,
      preventDisplayFromGoingToSleep: widget.settings.preventDisplayFromGoingToSleep,
      longPauseMinutes: widget.settings.longPauseMinutes,
      focusMinutes: widget.settings.focusMinutes,
      enableNotifications: widget.settings.enableNotifications
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context)!.settings,
          style: PomodoroValues.customTextTheme.subtitle2,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.enableNotifications,
              style: PomodoroValues.customTextTheme.subtitle2,
            ),
            Switch(
              value: currentSettings.enableNotifications,
              activeColor: PomodoroValues.orangeColor,
              inactiveThumbColor: PomodoroValues.mainColor,
              onChanged: (bool value) {
                setState(() {
                  currentSettings.enableNotifications = value;
                  saveSettings();
                });
              },
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.preventSleep,
              style: PomodoroValues.customTextTheme.subtitle2,
            ),
            Switch(
              value: currentSettings.preventDisplayFromGoingToSleep,
              activeColor: PomodoroValues.orangeColor,
              inactiveThumbColor: PomodoroValues.mainColor,
              onChanged: (bool value) {
                setState(() {
                  currentSettings.preventDisplayFromGoingToSleep = value;
                  saveSettings();
                });
              },
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.focusTime,
              style: PomodoroValues.customTextTheme.subtitle2,
            ),
            MinuteSwitch(
                startValue: currentSettings.focusMinutes.toDouble(),
                onChanged: (double number) {
                  setState(() {
                    currentSettings.focusMinutes = number.toInt();
                    saveSettings();
                  });
                },
                label: '${currentSettings.focusMinutes.toString()} min')
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.shortPauseTime,
              style: PomodoroValues.customTextTheme.subtitle2,
            ),
            MinuteSwitch(
                startValue: currentSettings.shortPauseMinutes.toDouble(),
                onChanged: (double number) {
                  setState(() {
                    currentSettings.shortPauseMinutes = number.toInt();
                    saveSettings();
                  });
                },
                label: '${currentSettings.shortPauseMinutes.toString()} min')
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.longPauseTime,
              style: PomodoroValues.customTextTheme.subtitle2,
            ),
            MinuteSwitch(
                startValue: currentSettings.longPauseMinutes.toDouble(),
                onChanged: (double number) {
                  setState(() {
                    currentSettings.longPauseMinutes = number.toInt();
                    saveSettings();
                  });
                },
                label: '${currentSettings.longPauseMinutes.toString()} min')
          ],
        ),
        const Spacer(
          flex: 5,
        ),
        MaterialButton(
          height: 50,
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
        const Spacer(
          flex: 5,
        )
      ],
    );
  }

  void saveSettings() {
    currentSettings.lastUpdatedAt = DateTime.now();
    databaseController.writeSettings(currentSettings.toString());
  }
}
