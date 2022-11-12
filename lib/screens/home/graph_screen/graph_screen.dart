import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/controller/graph_controller.dart';
import 'package:pomodoro_app/widgets/circles_painter_widget.dart';
import 'package:pomodoro_app/widgets/simple_bar_chart.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final GraphController graphController = GraphController();
  late Future<List<FocusTimeGraphValue>> getFocusTimeGraphValue;

  @override
  void initState() {
    getFocusTimeGraphValue = graphController.getDataForLastAmountOfDays(20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: PomodoroValues.cardColor,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(45),
              bottomLeft: Radius.circular(45))),
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
          Column(
            children: [
              Expanded(
                child: Center(
                  child: FutureBuilder(
                      future: getFocusTimeGraphValue,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FocusTimeGraphValue>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 30),
                            child: SimpleBarChart(
                                data: snapshot.data!),
                          );
                        }
                      }),
                ),
              ),
              const Expanded(child: Text('other widget'))
            ],
          )
        ],
      ),
    );
  }
}
