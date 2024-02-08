import 'dart:convert';
import 'dart:io' as io;

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

  void moveUp([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorUp(n));
  }

  void moveDown([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorDown(n));
  }

  void moveForward([int n = 1]) {
    _stdout.write(ConsoleStrings.cursorForward(n));
  }

  void moveBackward([int n = 1]) {
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

  void clearCurrentToEndScreen() {
    _stdout.write(ConsoleStrings.eraseCurrentToEndScreen);
  }

  void clearCurrentToStartScreen() {
    _stdout.write(ConsoleStrings.eraseCurrentToStartScreen);
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

  void clearCurrentToEndLine() {
    _stdout.write(ConsoleStrings.eraseCurrentToEndLine);
  }

  void clearCurrentToStartLine() {
    _stdout.write(ConsoleStrings.eraseCurrentToStartLine);
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
}
