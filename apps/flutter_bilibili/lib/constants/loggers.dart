import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  // level: kReleaseMode ? Level.error : Level.verbose,
  level: kReleaseMode ? Level.nothing : Level.verbose,
  printer: kReleaseMode
      ? null
      : PrettyPrinter(
          methodCount: 2, // number of method calls to be displayed
          errorMethodCount:
              8, // number of method calls if stacktrace is provided
          lineLength: 120, // width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
);
