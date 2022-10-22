import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/controller/data_controller.dart';
import 'package:pomodoro_app/models/database/session_model.dart';
import 'package:pomodoro_app/models/timer_model.dart';
import 'package:pomodoro_app/services/logger_service.dart';

class TimerController extends ChangeNotifier with LoggerService {
  TimerController() {
    _sessionController.instanciateDatabase().then((_) {
      getTodaysSessions();
      getTotalFocusMinutes();
    });
  }

  TimerModel timerModel =
      TimerModel(seconds: 0, roundCount: 0, fullRoundCount: 0);

  final DatabaseController _sessionController = DatabaseController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AudioCache audioCache = AudioCache(prefix: 'lib/assets/sounds/');
  final AudioPlayer player = AudioPlayer();

  int totalFocusTime = 0;

  Future<void> getTodaysSessions() async {
    final List<Session>? todaySessions =
        await _sessionController.getTodaysSessions();

    if (todaySessions!.isNotEmpty) {
      timerModel = TimerModel(
          seconds: 0,
          roundCount: todaySessions.first.rounds!,
          fullRoundCount: todaySessions.first.sessions!);
      notifyListeners();
    }
  }

  void getTotalFocusMinutes() {
    _sessionController.getLatestSession().then((Session? session) {
      print(session?.dateTime);
      if (session != null) {
        totalFocusTime = session.totalFocusTime!;
      }
    }).then((_) => notifyListeners());
  }

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
    _sessionController
        .persistSession(Session(
            rounds: timerModel.roundCount,
            sessions: timerModel.fullRoundCount,
            totalFocusTime: totalFocusTime + PomodoroTimerValues.focusMinutes))
        .then((_) => getTotalFocusMinutes());
    notifyListeners();
  }

  void _incrementFullRoundCount() {
    timerModel.fullRoundCount++;
    notifyListeners();
  }

  void startTimer() {
    _startStopTimer();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timerModel.timerIsActive && !timerModel.timerIsPaused) {
        _handleTimerCountdown();
      } else if (!timerModel.timerIsActive) {
        timer.cancel();
        _resetTimer();
      }
    });
  }

  void _startStopTimer() {
    timerModel.timerIsActive = !timerModel.timerIsActive;
    logInfo('${timerModel.timerIsActive ? 'Sarting' : 'Stopping'} Timer');
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
          // TODO(Vela): Translate notification text
          _showNotification('Take a break',
              'Sehr gut. Du hast dir 25 Minuten Pause verdient!', null);
          _resetRoundCount();
          _incrementFullRoundCount();
          timerModel.minutes = PomodoroTimerValues.longPauseMinutes;
          timerModel.totalSeconds = PomodoroTimerValues.totalLongPauseSeconds;
        } else {
          _showNotification(
              'Take a break', '5 Minuten Pause. Los gehts!', null);
          timerModel.minutes = PomodoroTimerValues.pauseMinutes;
          timerModel.totalSeconds = PomodoroTimerValues.totalPauseSeconds;
        }
      } else {
        _showNotification('Lets focus!',
            'Weiter gehts, du bist bei ${timerModel.roundCount} Runden!', null);
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
    timerModel = TimerModel(
        seconds: 0,
        roundCount: timerModel.roundCount,
        fullRoundCount: timerModel.fullRoundCount);
    if (timerModel.timerIsPaused) {
      pauseTimer();
    }
    notifyListeners();
  }

  Future<void> _showNotification(
      String title, String body, String? payload) async {
    logInfo('Showing notification: $body');
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      interruptionLevel: InterruptionLevel.active,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(iOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(3, title, body, notificationDetails, payload: payload);
  }

  Future<void> _playSound() async {
    player.audioCache = audioCache;
    player.play(
        AssetSource('484344__inspectorj__bike-bell-ding-single-01-01.mp3'),
        mode: PlayerMode.lowLatency);
  }

  void pauseTimer() {
    timerModel.timerIsPaused = !timerModel.timerIsPaused;
    notifyListeners();
  }

  void resetData() {
    _sessionController.resetData();
    timerModel = TimerModel(seconds: 0, roundCount: 0, fullRoundCount: 0);
    totalFocusTime = 0;
    notifyListeners();
  }
}
