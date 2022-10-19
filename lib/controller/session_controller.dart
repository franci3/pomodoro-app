import 'package:isar/isar.dart';
import 'package:pomodoro_app/models/session_model.dart';
import 'package:pomodoro_app/services/logger_service.dart';

class SessionController with LoggerService {
  Isar? isarInstance;

  Future<void> instanciateSessionSchema() async {
    isarInstance = await Isar.open([SessionSchema]);
  }

  Future<Session?> persistSession(Session newSession) async {
    logInfo('Persisting Session');
    try {
      await isarInstance?.writeTxn(() async {
        await isarInstance?.sessions
            .put(newSession)
            .then((Id value) => logInfo('Persisting Session with id $value'));
      });
      return newSession;
    } on Exception catch (e) {
      logError(e.toString());
      return null;
    }
  }

  Future<Session?> getLatestSession() async {
    return await isarInstance?.sessions
        .where()
        .sortByDateTimeDesc()
        .findFirst();
  }

  Future<Session?> getSessionById(int id) async {
    return await isarInstance?.sessions.get(id);
  }

  Future<List<Session>?> getTodaysSessions() async {
    return await isarInstance?.sessions
        .filter()
        .dateTimeGreaterThan(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ))
        .sortByDateTimeDesc()
        .findAll();
  }
}
