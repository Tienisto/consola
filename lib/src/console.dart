import 'dart:convert';
import 'dart:io' as io;

import 'package:consola/src/console_executor.dart';
import 'package:consola/src/strings.dart';

/// Provides static methods to manipulate the console.
class Console {
  /// The static reference to the console executor.
  /// Update this to mock the console executor.
  static ConsoleExecutor instance = ConsoleExecutor();

  /// Writes a string to the console without a newline.
  static void write(
    String message, {
    SimpleColor? foregroundColor,
    SimpleColor? backgroundColor,
  }) {
    instance.write(
      message,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  /// Writes a string to the console with a newline.
  static void writeLine(
    String? message, {
    SimpleColor? foregroundColor,
  }) {
    instance.writeLine(
      message,
      foregroundColor: foregroundColor,
    );
  }

  /// Reads a line from the console.
  static String readLine({
    String? prompt,
    Encoding encoding = io.systemEncoding,
    bool retainNewlines = false,
  }) {
    return instance.readLine(
      prompt: prompt,
      encoding: encoding,
      retainNewlines: retainNewlines,
    );
  }

  /// Reads the next integer from the console.
  static int? readInt({
    String? prompt,
    Encoding encoding = io.systemEncoding,
  }) {
    return instance.readInt(
      prompt: prompt,
      encoding: encoding,
    );
  }

  /// Reads the next double from the console.
  static double? readDouble({
    String? prompt,
    Encoding encoding = io.systemEncoding,
  }) {
    return instance.readDouble(
      prompt: prompt,
      encoding: encoding,
    );
  }

  /// Returns the width of the terminal.
  /// It is the number of columns in the terminal.
  static int getWindowWidth() {
    return instance.getWindowWidth();
  }

  /// Returns the height of the terminal.
  /// It is the number of rows in the terminal.
  static int getWindowHeight() {
    return instance.getWindowHeight();
  }

  /// Moves the cursor up by [n] rows; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static void moveUp([int n = 1]) {
    instance.moveUp(n);
  }

  /// Moves the cursor down by [n] rows; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static void moveDown([int n = 1]) {
    instance.moveDown(n);
  }

  /// Moves the cursor forward (right) by [n] columns; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static void moveForward([int n = 1]) {
    instance.moveForward(n);
  }

  /// Moves the cursor backward (left) by [n] columns; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static void moveBackward([int n = 1]) {
    instance.moveBackward(n);
  }

  /// Moves the cursor to the beginning of the line [n] lines down (default 1).
  static void moveNextLine([int n = 1]) {
    instance.moveNextLine(n);
  }

  /// Moves the cursor to the beginning of the line [n] lines up (default 1).
  static void movePrevLine([int n = 1]) {
    instance.movePrevLine(n);
  }

  /// Moves the cursor to column n.
  static void moveToColumn(int n) {
    instance.moveToColumn(n);
  }

  /// Moves the cursor to the specific position (x, y).
  /// Indices start at 1, not 0.
  static void moveTo(int x, int y) {
    instance.moveTo(x, y);
  }

  /// Moves the cursor to the top left.
  static void moveToTopLeft() {
    instance.moveToTopLeft();
  }

  /// Moves the cursor to the bottom left.
  static void moveToBottomLeft() {
    instance.moveToBottomLeft();
  }

  /// Moves the cursor to the top right.
  static void moveToTopRight() {
    instance.moveToTopRight();
  }

  /// Moves the cursor to the bottom right.
  static void moveToBottomRight() {
    instance.moveToBottomRight();
  }

  /// Native erase display sequence.
  /// Use [eraseCurrentToEndScreen], [eraseCurrentToStartScreen],
  /// [eraseScreen], [eraseScreenClearScrollback] for convenience.
  static void clearDisplayNative(int n) {
    instance.clearDisplayNative(n);
  }

  /// Erases from the current cursor position to the end of the screen.
  static void clearCurrentToEndScreen() {
    instance.clearCurrentToEndScreen();
  }

  /// Erases from the current cursor position to the start of the screen.
  static void clearCurrentToStartScreen() {
    instance.clearCurrentToStartScreen();
  }

  /// Erases the entire screen.
  /// By default, it also moves the cursor to top left.
  static void clearScreen({bool resetCursor = true}) {
    instance.clearScreen(resetCursor: resetCursor);
  }

  /// Erases the entire screen and clears the scrollback buffer.
  static void clearScreenClearScrollback() {
    instance.clearScreenClearScrollback();
  }

  /// Native erase line sequence.
  static void clearLineNative(int n) {
    instance.clearLineNative(n);
  }

  /// Erases from the current cursor position to the end of the line.
  static void clearCurrentToEndLine() {
    instance.clearCurrentToEndLine();
  }

  /// Erases from the current cursor position to the start of the line.
  static void clearCurrentToStartLine() {
    instance.clearCurrentToStartLine();
  }

  /// Erases the entire current line.
  /// By default, it also moves the cursor to the start of the line.
  static void clearLine({bool resetCursor = true}) {
    instance.clearLine(resetCursor: resetCursor);
  }

  /// Scroll up by n lines. New lines are added at the bottom.
  static void scrollUp(int n) {
    instance.scrollUp(n);
  }

  /// Scroll down by n lines. New lines are added at the top.
  static void scrollDown(int n) {
    instance.scrollDown(n);
  }
}
