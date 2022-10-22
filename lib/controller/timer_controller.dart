import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/assets/values/values.dart';
import 'package:pomodoro_app/controller/data_controller.dart';
import 'package:pomodoro_app/models/database/session_model.dart';
import 'package:pomodoro_app/models/database/settings_model.dart';
import 'package:pomodoro_app/models/timer_model.dart';
import 'package:pomodoro_app/services/logger_service.dart';

class TimerController extends ChangeNotifier with LoggerService {
  TimerController() {
    _sessionController.instanciateDatabase().then((_) async {
      _databaseController = DatabaseController();
      await instanciatePomodoroTimerValues();
      getTodaysSessions();
      getTotalFocusMinutes();
    });
  }

  late DatabaseController _databaseController;
  late PomodoroTimerValues pomodoroTimerValues;

  TimerModel timerModel = TimerModel(
      seconds: 0,
      roundCount: 0,
      fullRoundCount: 0,
      minutes: 25,
      totalSeconds: 25 * 60,
      animationSeconds: 25 * 60);

  final DatabaseController _sessionController = DatabaseController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AudioCache audioCache = AudioCache(prefix: 'lib/assets/sounds/');
  final AudioPlayer player = AudioPlayer();

  int totalFocusTime = 0;

  Future<void> instanciatePomodoroTimerValues() async {
    await _databaseController.readSettings().then((Settings settings) {
      pomodoroTimerValues = PomodoroTimerValues(
          focusMinutes: settings.focusMinutes,
          pauseMinutes: settings.shortPauseMinutes,
          longPauseMinutes: settings.longPauseMinutes);
    });
  }

  Future<void> getTodaysSessions() async {
    final List<Session>? todaySessions =
        await _sessionController.getTodaysSessions();

    if (todaySessions!.isNotEmpty) {
      timerModel = TimerModel(
        seconds: 0,
        roundCount: todaySessions.first.rounds!,
        fullRoundCount: todaySessions.first.sessions!,
        minutes: pomodoroTimerValues.focusMinutes,
        totalSeconds: pomodoroTimerValues.totalFocusSeconds(),
        animationSeconds: pomodoroTimerValues.totalFocusSeconds(),
      );
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
            totalFocusTime: totalFocusTime + pomodoroTimerValues.focusMinutes))
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
          _showNotification(
              'Take a break',
              'Sehr gut. Du hast dir ${pomodoroTimerValues.longPauseMinutes} Minuten Pause verdient!',
              null);
          _resetRoundCount();
          _incrementFullRoundCount();
          timerModel.minutes = pomodoroTimerValues.longPauseMinutes;
          timerModel.totalSeconds = pomodoroTimerValues.totalLongPauseSeconds();
        } else {
          _showNotification(
              'Take a break',
              '${pomodoroTimerValues.pauseMinutes} Minuten Pause. Los gehts!',
              null);
          timerModel.minutes = pomodoroTimerValues.pauseMinutes;
          timerModel.totalSeconds = pomodoroTimerValues.totalPauseSeconds();
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
    timerModel.totalSeconds = pomodoroTimerValues.totalPauseSeconds();
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
        fullRoundCount: timerModel.fullRoundCount,
        minutes: pomodoroTimerValues.focusMinutes,
        totalSeconds: pomodoroTimerValues.totalFocusSeconds(),
        animationSeconds: pomodoroTimerValues.totalFocusSeconds());
    if (timerModel.timerIsPaused) {
      pauseTimer();
    }
    notifyListeners();
  }

  Future<void> _showNotification(
      String title, String body, String? payload) async {
    _databaseController.readSettings().then((Settings? settings) async {
      if (settings != null && settings.enableNotifications) {
        const DarwinNotificationDetails darwinNotificationDetails =
            DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.active,
        );
        const NotificationDetails notificationDetails =
            NotificationDetails(iOS: darwinNotificationDetails);
        await flutterLocalNotificationsPlugin
            .show(3, title, body, notificationDetails, payload: payload);
      }
    });
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
    timerModel = TimerModel(
        seconds: 0,
        roundCount: 0,
        fullRoundCount: 0,
        minutes: 25,
        totalSeconds: 25 * 60,
        animationSeconds: 25 * 60);
    totalFocusTime = 0;
    notifyListeners();
  }

  void updatePomodoroValues(int focusMinutes, int shortPause, int longPause) {
    pomodoroTimerValues.focusMinutes = focusMinutes;
    pomodoroTimerValues.pauseMinutes = shortPause;
    pomodoroTimerValues.longPauseMinutes = longPause;
    timerModel.minutes = pomodoroTimerValues.focusMinutes;
    timerModel.totalSeconds = pomodoroTimerValues.totalFocusSeconds();
    timerModel.animationSeconds = pomodoroTimerValues.totalFocusSeconds();
    notifyListeners();
  }
}
