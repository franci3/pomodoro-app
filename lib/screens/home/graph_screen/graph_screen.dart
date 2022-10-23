import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/widgets/circles_painter_widget.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Positioned(
                  top: 100,
                  left: 300,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: CustomPaint(
                      size: const Size(200, 100),
                      painter: CirclesPainter(),
                    ),
                  ),
                ),
                Positioned(
                  left: 120,
                  bottom: 50,
                  child: CustomPaint(
                    size: const Size(200, 100),
                    painter: CirclesPainter(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
