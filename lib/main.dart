import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/screens/home.dart';

void main() {
  Paint.enableDithering = true;
  runApp(GetMaterialApp(
      title: 'Pomodoro App',
      debugShowCheckedModeBanner: false,
      theme: PomodoroValues.customTheme,
      home: PomodoroHome()));
}
