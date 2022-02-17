import "package:ansicolor/ansicolor.dart";
import "package:flutter/foundation.dart";

/// Classe écrite par moi :)
/// Custom console logger
class DebugLogger {
  /// Use to print colorized message in console, String can be printed only if
  /// the application is in debug mode
  /// 1 = errors
  /// 2 = value
  /// 3 = green
  /// 4 = yellow
  static void debugLog(String fileName, String functionName, String valueToPrint, int logType){
    ansiColorDisabled = false;
    final String message = "DEBUG => File: $fileName | Function: $functionName || $valueToPrint";
    late AnsiPen pen;

    switch(logType){
      case 1:
      /// Use to print errors
        pen = AnsiPen()..red(bold: true);
        break;
      case 2:
      /// Use to print value
        pen = AnsiPen()..blue(bold: true);
        break;
      case 3:
      /// Use it to print step in if true
        pen = AnsiPen()..green(bold: true);
        break;
      case 4:
      /// Use it to print value in else
        pen = AnsiPen()..yellow(bold: true);
        break;
    }
    if (kDebugMode) print(pen(message));
  }
}
