class PomodoroTimerValues {
  PomodoroTimerValues(
      {required this.focusMinutes,
      required this.pauseMinutes,
      required this.longPauseMinutes});

  static String appTitle = 'Pomodoro Timer';

  int focusMinutes;
  int pauseMinutes;
  int longPauseMinutes;

  int totalFocusSeconds() => focusMinutes * 60;
  int totalPauseSeconds() => pauseMinutes * 60;
  int totalLongPauseSeconds() => longPauseMinutes * 60;
}
