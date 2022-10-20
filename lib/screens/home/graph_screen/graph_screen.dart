import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';

class GraphScreen extends StatelessWidget{
  const GraphScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: PomodoroValues.cardColor,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(45),
              bottomLeft: Radius.circular(45)
          )
      ),
    );
  }

}
