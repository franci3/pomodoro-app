import 'package:isar/isar.dart';
import 'package:pomodoro_app/models/database/session_model.dart';
import 'package:pomodoro_app/models/database/settings_model.dart';
import 'package:pomodoro_app/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseController with LoggerService {

  factory DatabaseController() {
    return _databaseController;
  }

  DatabaseController._internal();
  Isar? isarInstance;

  static final DatabaseController _databaseController = DatabaseController._internal();

  Future<void> instanciateDatabase() async {
    isarInstance = await Isar.open([SessionSchema]);
  }

  Future<Session?> persistSession(Session newSession) async {
    try {
      await isarInstance?.writeTxn(() async {
        await isarInstance?.sessions.put(newSession);
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

  Future<List<Session>?> getSessionsForLastAmountOfDays(int days) async {
    return await isarInstance?.sessions
        .filter()
        .dateTimeGreaterThan(DateTime.now().subtract(Duration(days: days)))
        .sortByDateTime()
        .findAll();
  }

  Future<int?> getNumberOfSessionsInDB() async {
    return await isarInstance?.sessions.count();
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

  Future<void> resetData() async {
    return await isarInstance?.writeTxn(() async {
      await isarInstance?.clear();
    });
  }

  Future<Settings> readSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? settingsFromPrefs = prefs.getString('settings');
    return Settings.fromString(settingsFromPrefs);
  }

  Future<void> writeSettings(String settingsAsString) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', settingsAsString);
  }
}
