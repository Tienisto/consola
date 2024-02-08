import 'dart:io';

import 'package:consola/consola.dart';

void main() {
  Console.writeLine('Hello, world!');
  Console.writeLine('Whats up?', foregroundColor: SimpleColor.yellow);
  Console.write('Goodbye!', backgroundColor: SimpleColor.red);
  Console.writeLine('');
  Console.writeLine('Hello');

  sleep(Duration(seconds: 1));

  Console.clearScreen();

  Console.writeLine('Hello, world again!', foregroundColor: SimpleColor.green);

  final result = Console.readLine(prompt: 'What is your name? ');
  Console.writeLine('Hello, $result!');

  final int? age = Console.readInt(prompt: 'What is your age? ');
  Console.writeLine('You are $age years old.');
}
