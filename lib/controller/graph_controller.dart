import 'package:pomodoro_app/controller/data_controller.dart';
import 'package:pomodoro_app/models/database/session_model.dart';
import 'package:pomodoro_app/services/logger_service.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class GraphController with LoggerService{
  final DatabaseController _databaseController = DatabaseController();

  Future<int> getTotalSessionTimeInMinutes() async {
    return _databaseController
        .getLatestSession()
        .then((Session? session) => session?.totalFocusTime ?? 0);
  }

  Future<int> getTotalSessionCount() async {
    return _databaseController
        .getNumberOfSessionsInDB()
        .then((int? number) => number ?? 0);
  }

  Future<List<FocusTimeGraphValue>> getDataForLastAmountOfDays(int days) async {
    final List<Session>? sessions =
        await _databaseController.getSessionsForLastAmountOfDays(days);
    if (sessions != null && sessions.isNotEmpty) {
      return _mapSessionsToFocusTimeGraphValue(sessions);
    } else {
      return <FocusTimeGraphValue>[];
    }
  }

  List<FocusTimeGraphValue> _mapSessionsToFocusTimeGraphValue(
      List<Session> sessions) {
    final List<FocusTimeGraphValue> graphValues = <FocusTimeGraphValue>[];
    final List<List<Session>> sessionList = [];
    Session startingValue = sessions[0];
    final List<Session> tmpList = [];
    for (int x = 0; x < sessions.length; x++) {
      if (sessions[x].dateTime.isSameDate(startingValue.dateTime)) {
        tmpList.add(sessions[x]);
      } else {
        sessionList.add(List<Session>.from(tmpList));
        tmpList.clear();
        tmpList.add(sessions[x]);
        startingValue = sessions[x];
      }
      if (x == sessions.length - 1) {
        sessionList.add(List<Session>.from(tmpList));
      }
    }
    int? previousFocusTime;
    for (final List<Session> subSessionList in sessionList) {
      const int min = 0;
      if (subSessionList.length > 1) {
        final int max = subSessionList.length - 1;
        graphValues.add(FocusTimeGraphValue(
          dateTime: subSessionList[max].dateTime,
          focusTime: subSessionList[max].totalFocusTime! -
              subSessionList[min].totalFocusTime!,
        ));
        previousFocusTime = subSessionList[max].totalFocusTime;
      } else {
        graphValues.add(FocusTimeGraphValue(
          dateTime: subSessionList[min].dateTime,
          focusTime:
              subSessionList[min].totalFocusTime! - (previousFocusTime ?? 0),
        ));
        previousFocusTime = subSessionList[min].totalFocusTime;
      }
    }
    return graphValues;
  }
}

class FocusTimeGraphValue {
  FocusTimeGraphValue({this.focusTime, this.dateTime});

  int? focusTime;
  DateTime? dateTime;

  @override
  String toString() {
    return '{ focusTime: $focusTime, dateTime: $dateTime}';
  }
}
