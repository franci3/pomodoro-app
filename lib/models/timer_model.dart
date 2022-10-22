class TimerModel {
  TimerModel(
      {required this.seconds,
        required this.roundCount,
        required this.fullRoundCount,
        required this.minutes,
        required this.totalSeconds,
        required this.animationSeconds,
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