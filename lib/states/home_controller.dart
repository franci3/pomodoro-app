import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:audioplayers/audio_cache.dart';

class HomeController extends GetxController {

  var seconds = focusSeconds.obs;
  var minutes = focusMinutes.obs;
  var totalSeconds = totalFocusSeconds.obs;
  var animationSeconds = totalFocusSeconds.obs;
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
      focusPauseRound.toggle();
      //TODO: Remove fixed values with const
      if(focusPauseRound.isTrue){
        _incrementRound();
        animationSeconds.value = totalPauseSeconds;
        //minutes.value = pauseMinutes;
        if(roundCount.value == 4){
          roundCount.value = 0;
          _incrementFullRoundCount();
          seconds.value = 15;
          totalSeconds.value = 15;
        } else {
          seconds.value = 5;
          totalSeconds.value = totalPauseSeconds;
        }
      } else {
        _resetTimer();
      }
    }
  }

  _resetTimer() {
    seconds.value = focusSeconds;
    minutes.value = focusMinutes;
    totalSeconds.value = totalFocusSeconds;
    roundCount.value = 0;
    animationSeconds.value = totalFocusSeconds;
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
