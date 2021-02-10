import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/screens/home.dart';
import 'package:pomodoro_app/states/statistics_controller.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Paint.enableDithering = true;
  await GetStorage.init();
  Get.put(StatisticsController());
  runApp(GetMaterialApp(
      title: 'Pomodoro App',
      debugShowCheckedModeBanner: false,
      theme: PomodoroValues.customTheme,
      home: PomodoroHome()));
}