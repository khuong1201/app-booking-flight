import 'package:logger/logger.dart';

class LoggerUtils {
  static final Logger logger = Logger();

  static void logInfo(String message) {
    logger.i(message);
  }

  static void logError(String message, [dynamic error]) {
    logger.e(message, error: error);
  }

  static void logDebug(String message) {
    logger.d(message);
  }
}