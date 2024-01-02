import 'package:logger/logger.dart';

class LogPrint {
  static final LogPrint _instance = LogPrint._internal();

  factory LogPrint() {
    return _instance;
  }

  LogPrint._internal();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  Logger get l => _logger;
}
