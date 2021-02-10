import 'package:flutter/cupertino.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';

class CirclesPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    var offsetCircle1 = Offset(-80, -60);
    var offsetCircle2 = Offset(-10, 0);
    var offsetCircle3 = Offset(-55, 70);

    var gradientCircle1 = PomodoroValues.yellowColorOne;
    var gradientCircle2 = PomodoroValues.yellowColorTwo;

    canvas.drawCircle(offsetCircle1,60,Paint()..color = gradientCircle1);
    canvas.drawCircle(offsetCircle2,25,Paint()..color = gradientCircle2);
    canvas.drawCircle(offsetCircle3,45,Paint()..color = gradientCircle2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
  
}