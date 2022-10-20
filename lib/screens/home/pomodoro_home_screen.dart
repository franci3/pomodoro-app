import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/screens/home/graph_screen/graph_screen.dart';
import 'package:pomodoro_app/screens/home/settings_screen/settings_screen.dart';
import 'package:pomodoro_app/screens/home/timer_screen/timer_screen.dart';
import 'package:pomodoro_app/screens/legal/legal_screen.dart';
import 'package:pomodoro_app/services/logger_service.dart';
import 'package:pomodoro_app/widgets/bottom_navigation_bar.dart';

class PomodoroHome extends StatefulWidget with LoggerService {
  PomodoroHome({Key? key}) : super(key: key);

  @override
  State<PomodoroHome> createState() => _PomodoroHomeState();
}

class _PomodoroHomeState extends State<PomodoroHome> {
  int currentIndex = 1;

  final List<Widget> pagesArray = [
    const GraphScreen(),
    const TimerScreen(),
    const SettingsScreen()
  ];

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
                icon:
                    Icon(Icons.info, color: PomodoroValues.mainColor, size: 26),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LegalScreen()));
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        }),
        body: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {

              final Animation<Offset> offsetAnimation = Tween(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            duration: const Duration(seconds: 1),
            switchOutCurve: Curves.easeInExpo,
            switchInCurve: Curves.easeOutCubic,
            child: pagesArray[currentIndex]));
  }
}
