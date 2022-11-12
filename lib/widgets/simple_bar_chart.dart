import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/assets/custom_theme.dart';
import 'package:pomodoro_app/controller/graph_controller.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({Key? key, required this.data}) : super(key: key);
  final List<FocusTimeGraphValue> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.lighten,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PomodoroValues.gradientColorOne,
            PomodoroValues.gradientColorTwo
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Deine tägliche Fokuszeit der letzen 30 Tage in Minuten',
              style: PomodoroValues.customTextTheme.bodyText2,
            ),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: barGroups,
                  gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceEvenly,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              PomodoroValues.customTextTheme.bodySmall!,
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final TextStyle style = PomodoroValues.customTextTheme.bodySmall!;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(DateFormat.Md().format(data[value.toInt()].dateTime!),
          style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          PomodoroValues.yellowColorTwo,
          PomodoroValues.yellowColorOne,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => data
      .map((FocusTimeGraphValue focusTimeGraphValue) => _barchartGroupData(
          data.indexOf(focusTimeGraphValue),
          focusTimeGraphValue.focusTime!.toDouble()))
      .toList();

  BarChartGroupData _barchartGroupData(int xA, double toYAx) {
    return BarChartGroupData(
      x: xA,
      barRods: [
        BarChartRodData(
          toY: toYAx,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    );
  }
}
