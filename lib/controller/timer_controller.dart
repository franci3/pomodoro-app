import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';

class TimerModel {
  TimerModel(
      {this.seconds,
      this.roundCount,
      this.fullRoundCount,
      this.minutes = PomodoroTimerValues.focusMinutes,
      this.totalSeconds = PomodoroTimerValues.totalFocusSeconds,
      this.animationSeconds = PomodoroTimerValues.totalFocusSeconds,
      this.timerIsActive = false,
      this.timerIsPaused = false,
      this.focusPauseRound = false});

  int seconds;
  int minutes;
  int totalSeconds;
  int animationSeconds;
  int roundCount;
  int fullRoundCount;
  bool timerIsActive;
  bool timerIsPaused;
  bool focusPauseRound;
}

class TimerController extends ChangeNotifier {
  TimerModel timerModel =
      TimerModel(seconds: 0, roundCount: 0, fullRoundCount: 0);

  AudioCache audioPlayer = AudioCache(prefix: 'lib/assets/sounds/');

  void _decrementSeconds() {
    timerModel.seconds--;
    notifyListeners();
  }

  void _decrementMinutes() {
    timerModel.minutes--;
    notifyListeners();
  }

  void _decrementTotalSeconds() {
    timerModel.totalSeconds--;
    notifyListeners();
  }

  void _incrementRound() {
    timerModel.roundCount++;
    notifyListeners();
  }

  void _incrementFullRoundCount() {
    timerModel.fullRoundCount++;
    notifyListeners();
  }

  void startTimer() {
    _startStopTimer();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      print('Timer started');
      if (timerModel.timerIsActive && !timerModel.timerIsPaused) {
        _handleTimerCountdown();
      } else if (!timerModel.timerIsActive) {
        timer.cancel();
        _resetTimer();
      }
    });
  }

  void _startStopTimer() {
    //timerIsActive = !timerIsActive;
    timerModel = TimerModel(
        seconds: timerModel.seconds,
        minutes: timerModel.minutes,
        totalSeconds: timerModel.totalSeconds,
        animationSeconds: timerModel.animationSeconds,
        roundCount: timerModel.roundCount,
        fullRoundCount: timerModel.fullRoundCount,
        timerIsActive: !timerModel.timerIsActive,
        timerIsPaused: timerModel.timerIsPaused,
        focusPauseRound: timerModel.focusPauseRound);
    _playSound();
  }

  void _handleTimerCountdown() {
    _decrementTotalSeconds();
    if (timerModel.seconds != 0) {
      _decrementSeconds();
    } else if (timerModel.seconds == 0 && timerModel.minutes != 0) {
      timerModel.seconds = 59;
      _decrementMinutes();
    } else if (timerModel.seconds == 0 && timerModel.minutes == 0) {
      _playSound();
      _focusPauseRound();
      if (timerModel.focusPauseRound) {
        _incrementRound();
        _resetAnimationSeconds();
        if (timerModel.roundCount == 4) {
          _resetRoundCount();
          _incrementFullRoundCount();
          timerModel.minutes = PomodoroTimerValues.longPauseMinutes;
          timerModel.totalSeconds = PomodoroTimerValues.totalLongPauseSeconds;
        } else {
          timerModel.minutes = PomodoroTimerValues.pauseMinutes;
          timerModel.totalSeconds = PomodoroTimerValues.totalPauseSeconds;
        }
      } else {
        _resetTimer();
      }
    }
  }

  void _resetRoundCount() {
    timerModel.roundCount = 0;
    notifyListeners();
  }

  void _resetAnimationSeconds() {
    timerModel.totalSeconds = PomodoroTimerValues.totalPauseSeconds;
    notifyListeners();
  }

  void _focusPauseRound() {
    timerModel.focusPauseRound = !timerModel.focusPauseRound;
    notifyListeners();
  }

  void _resetTimer() {
    timerModel = TimerModel(seconds: 0, roundCount: 0, fullRoundCount: 0);
    if (timerModel.timerIsPaused) {
      pauseTimer();
    }
    notifyListeners();
  }

  void _playSound() async {
    audioPlayer.play('484344__inspectorj__bike-bell-ding-single-01-01.mp3');
  }

  void pauseTimer() {
    timerModel.timerIsPaused = !timerModel.timerIsPaused;
    notifyListeners();
  }

  Widget countdownText() {
    if (timerModel.minutes < 10 && timerModel.seconds < 10) {
      return Text(
        '0${timerModel.minutes}:0${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else if (timerModel.minutes < 10) {
      return Text(
        '0${timerModel.minutes}:${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else if (timerModel.seconds < 10) {
      return Text(
        '${timerModel.minutes}:0${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    } else {
      return Text(
        '${timerModel.minutes}:${timerModel.seconds}',
        style: PomodoroValues.customTextTheme.headline2,
      );
    }
  }
}
