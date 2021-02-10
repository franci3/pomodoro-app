import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';

class StatisticsController extends GetxController {
  final _statisticsBox = GetStorage();
  var totalFocusMinutes = 0.obs;

  @override
  void onInit() {
    _statisticsBox.writeIfNull('totalFocusMinutes', totalFocusMinutes);
    _getTotalFocusMinutes();
    super.onInit();
  }

  _getTotalFocusMinutes() {
    var tempMinutes = _statisticsBox.read('totalFocusMinutes');
    if (tempMinutes != null) {
      totalFocusMinutes.value = tempMinutes;
    }
  }

  writeTotalFocusMinutes(int minutes) {
    var tempMinutes = _statisticsBox.read('totalFocusMinutes');
    var newMinutes = tempMinutes + minutes;
    _statisticsBox.write('totalFocusMinutes', newMinutes);
    totalFocusMinutes.value = newMinutes;
  }

  resetTotalFocusTime() {
    writeTotalFocusMinutes(0);
    Get.snackbar('', 'Fokuszeit zurückgesetzt',
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(PomodoroTimerValues.appTitle,
            style: PomodoroValues.customTextTheme.headline1),
    duration: Duration(seconds: 3),
    snackStyle: SnackStyle.FLOATING);
  }
}
