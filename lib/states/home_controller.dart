import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';

class HomeController extends GetxController {

  var seconds = focusSeconds.obs;
  var minutes = focusMinutes.obs;
  var totalSeconds = totalFocusSeconds.obs;
  var timerIsActive = false.obs;
  var timerIsPaused = false.obs;
  decrementSeconds() => seconds--;
  decrementMinutes() => minutes--;

  startTimer() {
    startStopTimer();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerIsActive.isTrue && timerIsPaused.isfalse) {
        handleTimerCountdown();
      } else if(timerIsActive.isfalse){
        timer.cancel();
        resetTimer();
      }
    });
  }

  startStopTimer() {
    timerIsActive.toggle();
  }

  handleTimerCountdown() {
    totalSeconds--;
    if (seconds.value != 0) {
      decrementSeconds();
    } else if (seconds.value == 0 && minutes.value != 0) {
      seconds.value = 59;
      decrementMinutes();
    } else if (seconds.value == 0 && minutes.value == 0) {
      startStopTimer();
    }
  }

  resetTimer() {
    seconds.value = focusSeconds;
    minutes.value = focusMinutes;
    totalSeconds.value = totalFocusSeconds;
  }

  pauseTimer() {
    timerIsPaused.toggle();
  }

  Widget countdownText() {
    if (minutes < 10 && seconds < 10) {
      return Text(
        '0$minutes:0$seconds',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else if (minutes < 10) {
      return Text(
        '0$minutes:$seconds',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else if (seconds < 10) {
      return Text(
        '$minutes:0$seconds',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else {
      return Text(
        '$minutes:$seconds',
        style: PomodoroValues.customTextTheme.headline2,
      );
    }
  }
}
