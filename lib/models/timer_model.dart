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