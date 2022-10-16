import 'package:logger/logger.dart';

class LoggerService {
  final Logger logger = Logger();

  void logInfo(String message) {
    logger.i(message);
  }

  void logDebug(String message) {
    logger.d(message);
  }

  void logError(String message) {
    logger.e(message);
  }

  void logRandom(String message) {
    logger.wtf(message);
  }
}
