import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/screens/home.dart';

void main() {
  runApp(GetMaterialApp(
    title: 'Pomodoro App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: PomodoroHome()
  ));
}