import 'dart:convert';
import 'dart:io' as io;

import 'package:consola/src/component.dart';
import 'package:consola/src/coordinate.dart';
import 'package:consola/src/strings.dart';

class ConsoleExecutor {
  ConsoleExecutor({
    io.Stdin? stdin,
    io.Stdout? stdout,
  })  : _stdin = stdin ?? io.stdin,
        _stdout = stdout ?? io.stdout;

  final io.Stdin _stdin;
  final io.Stdout _stdout;

  void write(
    String message, {
    SimpleColor? foregroundColor,
    SimpleColor? backgroundColor,
  }) {
    _write(
      write: _stdout.write,
      object: message,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  void writeLine(
    String? message, {
    SimpleColor? foregroundColor,
  }) {
    _write(
      write: _stdout.writeln,
      object: message,
      foregroundColor: foregroundColor,
      backgroundColor: null,
    );
  }

  void _write({
    required Function(String?) write,
    required String? object,
    required SimpleColor? foregroundColor,
    required SimpleColor? backgroundColor,
  }) {
    final hasColorChange = foregroundColor != null || backgroundColor != null;
    if (hasColorChange) {
      _stdout.write(ConsoleStrings.setColor(
        foreground: foregroundColor,
        background: backgroundColor,
      ));
    }
    write(object);
    if (hasColorChange) {
      _stdout.write(ConsoleStrings.resetColor);
    }
  }

  String readLine({
    String? prompt,
    Encoding encoding = io.systemEncoding,
    bool retainNewlines = false,
  }) {
    if (prompt != null) {
      _stdout.write(prompt);
    }
    return _stdin.readLineSync(
          encoding: encoding,
          retainNewlines: retainNewlines,
        ) ??
        '';
  }

  int? readInt({
    String? prompt,
    Encoding encoding = io.systemEncoding,
  }) {
    final input = readLine(prompt: prompt, encoding: encoding);
    return int.tryParse(input);
  }

  double? readDouble({
    String? prompt,
    Encoding encoding = io.systemEncoding,
  }) {
    final input = readLine(prompt: prompt, encoding: encoding);
    return double.tryParse(input);
  }

  int getWindowWidth() {
    return _stdout.terminalColumns;
  }

  int getWindowHeight() {
    return _stdout.terminalLines;
  }

  ConsoleCoordinate getCursorPosition([bool flush = false]) {
    final bool prevLineMode = _stdin.lineMode;
    try {
      _stdin.echoMode = false;
      _stdin.lineMode = false;

      _stdout.write(ConsoleStrings.deviceStatusReport);

      final yBytes = <int>[];
      final xBytes = <int>[];
      int counter = 0;
      bool readY = false;
      bool readX = false;

      // Parsing the response which is in "ESC[y;xR" format
      while (counter < 32) {
        final char = _stdin.readByteSync();

        if (char == -1) {
          break; // EOF
        }

        if (readX) {
          if (char == 82) {
            // found "R"
            break;
          }
          xBytes.add(char);
        } else if (readY) {
          if (char == 59) {
            // found ";"
            readX = true;
            continue;
          }
          yBytes.add(char);
        } else if (char == 91) {
          // found "["
          readY = true;
        }

        counter++;
      }

      final int? x = int.tryParse(String.fromCharCodes(xBytes));
      final int? y = int.tryParse(String.fromCharCodes(yBytes));

      if (x == null || y == null) {
        throw Exception(
          'Unexpected cursor position report: ${String.fromCharCodes(yBytes)};${String.fromCharCodes(xBytes)}',
        );
      }

      return ConsoleCoordinate(x, y);
    } catch (e) {
      rethrow;
    } finally {
      _stdin.echoMode = true;
      _stdin.lineMode = prevLineMode;
    }
  }

  void draw(
    ConsoleComponent component, {
    bool restoreCursor = false,
    ConsoleCoordinate? cursor,
  }) {
    if (restoreCursor) {
      cursor ??= getCursorPosition();
    }

    if (component is AbsoluteConsoleComponent) {
      component.draw(this);
    } else if (component is RelativeConsoleComponent) {
      cursor ??= getCursorPosition();
      component.draw(this, cursor);
    }

    if (restoreCursor) {
      moveToCoordinate(cursor!);
    }
  }

  void drawMultiple(
    Iterable<AbsoluteConsoleComponent> components, {
    bool restoreCursor = true,
    ConsoleCoordinate? cursor,
  }) {
    if (restoreCursor) {
      cursor ??= getCursorPosition();
    }

    for (final component in components) {
      component.draw(this);
    }

    if (restoreCursor) {
      moveToCoordinate(cursor!);
    }
  }

  void moveUp([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorUp(n));
  }

  void moveDown([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorDown(n));
  }

  void moveRight([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorForward(n));
  }

  void moveLeft([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorBackward(n));
  }

  void moveNextLine([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorNextLine(n));
  }

  void movePrevLine([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorPrevLine(n));
  }

  void moveToColumn(int n) {
    _stdout.write(ConsoleStrings.cursorToColumn(n));
  }

  void moveTo(int x, int y) {
    _stdout.write(ConsoleStrings.cursorTo(x, y));
  }

  void moveToCoordinate(ConsoleCoordinate coordinate) {
    moveTo(coordinate.x, coordinate.y);
  }

  void moveToTopLeft() {
    _stdout.write(ConsoleStrings.cursorToHome);
  }

  void moveToBottomLeft() {
    _stdout.write(ConsoleStrings.cursorTo(getWindowHeight(), 1));
  }

  void moveToTopRight() {
    _stdout.write(ConsoleStrings.cursorTo(1, getWindowWidth()));
  }

  void moveToBottomRight() {
    _stdout.write(ConsoleStrings.cursorTo(getWindowHeight(), getWindowWidth()));
  }

  void clearDisplayNative(int n) {
    _stdout.write(ConsoleStrings.eraseDisplayNative(n));
  }

  void clearCurrentToScreenEnd() {
    _stdout.write(ConsoleStrings.eraseCurrentToScreenEnd);
  }

  void clearCurrentToScreenStart() {
    _stdout.write(ConsoleStrings.eraseCurrentToScreenStart);
  }

  void clearScreen({bool resetCursor = true}) {
    if (resetCursor) {
      _stdout.write(
        '${ConsoleStrings.eraseScreen}${ConsoleStrings.cursorToHome}',
      );
    } else {
      _stdout.write(ConsoleStrings.eraseScreen);
    }
  }

  void clearScreenClearScrollback() {
    _stdout.write(ConsoleStrings.eraseScreenClearScrollback);
  }

  void clearLineNative(int n) {
    _stdout.write(ConsoleStrings.eraseLineNative(n));
  }

  void clearCurrentToLineEnd() {
    _stdout.write(ConsoleStrings.eraseCurrentToLineEnd);
  }

  void clearCurrentToLineStart() {
    _stdout.write(ConsoleStrings.eraseCurrentToLineStart);
  }

  void clearLine({bool resetCursor = true}) {
    if (resetCursor) {
      _stdout.write(
        '${ConsoleStrings.eraseLine}${ConsoleStrings.cursorToColumn(1)}',
      );
    } else {
      _stdout.write(ConsoleStrings.eraseLine);
    }
  }

  void scrollUp(int n) {
    _stdout.write(ConsoleStrings.scrollUp(n));
  }

  void scrollDown(int n) {
    _stdout.write(ConsoleStrings.scrollDown(n));
  }

  void saveCursorPosition() {
    _stdout.write(ConsoleStrings.saveCursorPosition);
  }

  void restoreCursorPosition() {
    _stdout.write(ConsoleStrings.restoreCursorPosition);
  }

  void addEmptyLinesToBottom(int n) {
    for (var i = 0; i < n; i++) {
      _stdout.writeln();
    }
    for (var i = 0; i < n; i++) {
      moveUp();
    }
  }
}
