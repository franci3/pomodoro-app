import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:audioplayers/audio_cache.dart';

class HomeController extends GetxController {

  var seconds = 0.obs;
  var minutes = PomodoroTimerValues.focusMinutes.obs;
  var totalSeconds = PomodoroTimerValues.totalFocusSeconds.obs;
  var animationSeconds = PomodoroTimerValues.totalFocusSeconds.obs;
  var roundCount = 0.obs;
  var fullRoundCount = 0.obs;
  var timerIsActive = false.obs;
  var timerIsPaused = false.obs;
  var focusPauseRound = false.obs;

  AudioCache audioPlayer = AudioCache(prefix: 'lib/assets/sounds/');

  _decrementSeconds() => seconds--;
  _decrementMinutes() => minutes--;
  _decrementTotalSeconds() => totalSeconds--;
  _incrementRound() => roundCount++;
  _incrementFullRoundCount() => fullRoundCount++;

  startTimer() {
    _startStopTimer();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerIsActive.isTrue && timerIsPaused.isfalse) {
        _handleTimerCountdown();
      } else if(timerIsActive.isfalse){
        timer.cancel();
        _resetTimer();
      }
    });
  }

  _startStopTimer() {
    timerIsActive.toggle();
    _playSound();
  }

  _handleTimerCountdown() {
    _decrementTotalSeconds();
    if (seconds.value != 0) {
      _decrementSeconds();
    } else if (seconds.value == 0 && minutes.value != 0) {
      seconds.value = 59;
      _decrementMinutes();
    } else if (seconds.value == 0 && minutes.value == 0) {
      _playSound();
      focusPauseRound.toggle();
      if(focusPauseRound.isTrue){
        _incrementRound();
        animationSeconds.value = PomodoroTimerValues.totalPauseSeconds;
        if(roundCount.value == 4){
          roundCount.value = 0;
          _incrementFullRoundCount();
          minutes.value = PomodoroTimerValues.longPauseMinutes;
          totalSeconds.value = PomodoroTimerValues.totalLongPauseSeconds;
        } else {
          minutes.value = PomodoroTimerValues.pauseMinutes;
          totalSeconds.value = PomodoroTimerValues.totalPauseSeconds;
        }
      } else {
        _resetTimer();
      }
    }
  }

  _resetTimer() {
    seconds.value = 0;
    minutes.value = PomodoroTimerValues.focusMinutes;
    totalSeconds.value = PomodoroTimerValues.totalFocusSeconds;
    roundCount.value = 0;
    animationSeconds.value = PomodoroTimerValues.totalFocusSeconds;
    if(focusPauseRound.isTrue) focusPauseRound.toggle();
    if(timerIsPaused.isTrue) timerIsPaused.toggle();
  }

  _playSound() async {
    audioPlayer.play('484344__inspectorj__bike-bell-ding-single-01-01.mp3');
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
