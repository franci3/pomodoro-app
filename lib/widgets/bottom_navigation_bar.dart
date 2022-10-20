import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key, required this.onTap}) : super(key: key);

  final Function(int index) onTap;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: PomodoroValues.mainLight,
        selectedItemColor: PomodoroValues.yellowColorOne,
        selectedIconTheme: const IconThemeData(
          size: 32
        ),
        unselectedIconTheme: const IconThemeData(
        size: 24
        ),
        onTap: (int index) {
          widget.onTap(index);
          setState(() {
            currentIndex = index;
          });
        },
        elevation: 0,
        currentIndex: currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]);
  }
}
