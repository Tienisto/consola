import 'dart:io';

import 'package:consola/consola.dart';

void main() {
  Console.clearScreen();
  Console.writeLine('Hello, world!');
  Console.writeLine('Pos: ${Console.getCursorPosition()}');
  Console.writeLine('Whats up?', foregroundColor: SimpleColor.yellow);
  Console.write('Goodbye!', backgroundColor: SimpleColor.red);
  Console.writeLine('');
  Console.writeLine('Hello');

  final progressBar1 = ProgressBar.atPosition(
    total: 50,
    console: Console.instance,
    position: ConsoleCoordinate(1, 8),
    head: 'Progress A: ',
    tailBuilder: (_, __, percent) => ' ${percent.toStringAsFixed(0)}%',
  );

  final progressBar2 = ProgressBar.atPosition(
    total: 50,
    console: Console.instance,
    position: ConsoleCoordinate(1, 9),
    head: 'Progress B: ',
    tailBuilder: (_, __, percent) => ' ${percent.toStringAsFixed(0)}%',
  );

  print('Position: ${progressBar1.position}');

  for (var i = 0; i <= 50; i++) {
    progressBar1.current = i;
    Console.draw(progressBar1);
    progressBar2.current = i;
    Console.draw(progressBar2);
    sleep(Duration(milliseconds: 50));
  }

  sleep(Duration(seconds: 1));

  Console.clearScreen();

  Console.writeLine('Hello, world again!', foregroundColor: SimpleColor.green);

  final result = Console.readLine(prompt: 'What is your name? ');
  Console.writeLine('Hello, $result!');

  final int? age = Console.readInt(prompt: 'What is your age? ');
  Console.writeLine('You are $age years old.');
}
