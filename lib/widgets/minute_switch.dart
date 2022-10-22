import 'package:flutter/material.dart';

import 'package:pomodoro_app/assets/custom_theme.dart';

class MinuteSwitch extends StatelessWidget {
  const MinuteSwitch({Key? key, required this.startValue, required this.onChanged, required this.label}) : super(key: key);

  final double startValue;
  final Function(double number) onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: startValue,
      max: 60,
      min: 5,
      divisions: 11,
      activeColor: PomodoroValues.orangeColor,
      inactiveColor: PomodoroValues.gradientColorTwo,
      label: label,
      onChanged: (double number) => onChanged(number),
    );
  }

}