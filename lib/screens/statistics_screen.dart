import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_app/states/home_controller.dart';

class StatisticsScreen extends StatelessWidget {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Center(
        child: Container(
          child: Obx(() => Text(
                'Statistics coming soon ${homeController.totalSeconds}, Round: ${homeController.roundCount}, Full Round: ${homeController.fullRoundCount}',
                style: TextStyle(color: Colors.black),
              )),
        ),
      ),
    );
  }
}
