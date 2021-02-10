import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';

class StatsCircle extends StatelessWidget {
  final double circleValue;
  final String innerCircleText;
  final String circleDescription;

  StatsCircle({@required this.innerCircleText,@required this.circleValue,@required this.circleDescription});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  value: circleValue,
                  backgroundColor: PomodoroValues.mainLight.withOpacity(.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      PomodoroValues.yellowColorOne),
                ),
              ),
              Text(
                '$innerCircleText',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text(circleDescription, style: TextStyle(
            fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w200),
          textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
