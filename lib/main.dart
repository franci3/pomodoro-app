import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/controller/timer_controller.dart';
import 'package:pomodoro_app/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Paint.enableDithering = true;
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => TimerController(),
      child: Pomodoro(),
    ),
  );
}

class Pomodoro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pomodoro App',
        debugShowCheckedModeBanner: false,
        theme: PomodoroValues.customTheme,
        home: PomodoroHome());
  }
}
