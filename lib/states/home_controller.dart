import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  var seconds = 59.obs;
  var minutes = 24.obs;
  var timerIsActive = false.obs;
  decrementSeconds() => seconds--;
  decrementMinutes() => minutes--;

  startTimer() {
    startStopTimer();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerIsActive.isTrue) {
        handleTimerCountdown();
      }else{
        resetTimer();
        timer.cancel();
      }
    });
  }

  startStopTimer() {
    if (timerIsActive.isfalse) {
      timerIsActive.value = true;
    }else{
      timerIsActive.value = false;
    }
  }

  handleTimerCountdown() {
    if(seconds.value != 0){
      decrementSeconds();
    }else if(seconds.value == 0 && minutes.value != 0){
      seconds.value = 59;
      decrementMinutes();
    }else if(seconds.value == 0 && minutes.value == 0){
      startStopTimer();
    }
  }

  resetTimer() {
    seconds.value = 59;
    minutes.value = 24;
  }
}
