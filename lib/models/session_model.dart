import 'package:isar/isar.dart';

part 'session_model.g.dart';

@collection
class Session {
  Id sessionId = Isar.autoIncrement;
  DateTime? dateTime;
  int? totalFocusTime;
  int? rounds;
  int? sessions;
}
