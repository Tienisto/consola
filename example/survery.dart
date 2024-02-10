import 'package:consola/consola.dart';

void main() {
  usingSaveAndRestoreCursor();
}

void usingMoveUp() {
  Console.writeLine('Survey (1/2)');
  final name = Console.readLine(prompt: 'Enter name: ');

  Console.moveUp(2);
  Console.moveToColumn(1);
  Console.clearCurrentToScreenEnd();

  Console.writeLine('Survey (2/2)');
  final age = Console.readInt(prompt: 'Enter age: ');
  Console.writeLine('Hello, $name! You are $age years old.');
}

void usingSaveAndRestoreCursor() {
  // Saving and restoring cursor position is relative.
  // It doesn't work if the cursor is already at the bottom so
  // we need to add some empty lines to make sure it works.
  Console.addEmptyLinesToBottom(2);
  Console.saveCursorPosition();

  Console.writeLine('Survey (1/2)');
  final name = Console.readLine(prompt: 'Enter name: ');

  Console.restoreCursorPosition();
  Console.clearCurrentToScreenEnd();

  Console.writeLine('Survey (2/2)');
  final age = Console.readInt(prompt: 'Enter age: ');
  Console.writeLine('Hello, $name! You are $age years old.');
}
