import 'package:isar/isar.dart';
import 'package:pomodoro_app/models/session_model.dart';

class SessionController {

  Isar? sessionSchema;

  Future<void> instanciateSessionSchema() async {
    sessionSchema = await Isar.open([SessionSchema]);
  }

}
