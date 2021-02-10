import 'package:flutter/cupertino.dart';

class CirclesPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    var offsetCircle1 = Offset(-80, -60);
    var offsetCircle2 = Offset(-10, 0);
    var offsetCircle3 = Offset(-55, 70);

    var gradientCircle1 = const Color.fromRGBO(242, 186, 0, 0.71);
    var gradientCircle2 = const Color.fromRGBO(149, 118, 14, 1);
    var gradientCircle3 = const Color.fromRGBO(149, 118, 14, 1);

    canvas.drawCircle(offsetCircle1,60,Paint()..color = gradientCircle1);
    canvas.drawCircle(offsetCircle2,25,Paint()..color = gradientCircle2);
    canvas.drawCircle(offsetCircle3,45,Paint()..color = gradientCircle3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
  
}