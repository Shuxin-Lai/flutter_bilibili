import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class VtLogger {
  static Logger? _logger;

  static Logger initialize([PrettyPrinter? printer]) {
    // ignore: unnecessary_null_comparison
    if (_logger != null) {
      return _logger!;
    }

    printer ??= PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        );

    _logger = Logger(
        // level: kReleaseMode ? Level.error : Level.verbose,
        level: kReleaseMode ? Level.nothing : Level.verbose,
        printer: kReleaseMode ? null : printer);

    return _logger!;
  }

  static void dispose() {
    _logger?.close();
    _logger = null;
  }

  static void _print({
    required String level,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (level == 'd') {
      return _logger?.d(message, error, stackTrace);
    } else if (level == 'v') {
      return _logger?.v(message, error, stackTrace);
    } else if (level == 'w') {
      return _logger?.w(message, error, stackTrace);
    } else if (level == 'l') {
      return _logger?.log(message, error, stackTrace);
    } else if (level == 'e') {
      return _logger?.e(message, error, stackTrace);
    }
  }

  static void verbose(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return _print(
      level: 'v',
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void debug(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return _print(
      level: 'debug',
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void warning(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return _print(
      level: 'w',
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return _print(
      level: 'e',
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
