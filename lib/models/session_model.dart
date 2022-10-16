import 'package:isar/isar.dart';

part 'session_model.g.dart';

@collection
class Session {
  Session({this.totalFocusTime, this.sessions, this.rounds})
      : sessionId = Isar.autoIncrement,
        dateTime = DateTime.now();

  @Index(
    unique: true,
    replace: true,
    composite: [
      CompositeIndex('dateTime'),
    ],
  )

  Id sessionId;
  DateTime dateTime;
  int? totalFocusTime;
  int? rounds;
  int? sessions;
}
