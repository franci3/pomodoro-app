import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/states/home_controller.dart';

class PomodoroHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text('${homeController.minutes}:${homeController.seconds}')),
            MaterialButton(
              onPressed: () => homeController.startTimer(),
              child: Obx(() => Text(homeController.timerIsActive.isTrue ? 'Stop Timer' : 'Start Timer')),
            )
          ],
        ),
      ),
    );
  }
}
