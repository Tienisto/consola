import 'dart:io';

import 'package:consola/consola.dart';

void main() {
  Console.clearScreen();
  Console.writeLine('Progress bar example:');
  Console.writeLine('A (this will be overwritten)');
  Console.writeLine('B (this will be overwritten)');
  Console.write('C -> ');

  final progressBar = ProgressBar.atPosition(
    total: 50,
    width: 50,
    position: ConsoleCoordinate(1, 2),
    head: 'Progress A: ',
    barFillCharacter: '=',
    barTipCharacter: '>',
    barSpaceCharacter: '-',
    tailBuilder: (_, __, percent) => ' ${percent.toStringAsFixed(0)}%',
  );

  final fullWidthBar = ProgressBar.atPosition(
    total: 50,
    console: Console.instance,
    position: ConsoleCoordinate(1, 3),
    head: 'Progress B: ',
    tailBuilder: (_, __, percent) => ' ${percent.toStringAsFixed(0)}%',
  );

  final atCursorBar = ProgressBar.atCursor(
    total: 50,
    width: 50,
    console: Console.instance,
    head: 'Progress C: ',
    barHead: '|',
    barTail: '|',
    barFillCharacter: '#',
    barSpaceCharacter: '.',
    tailBuilder: (_, __, percent) => ' ${percent.toStringAsFixed(0)}%',
  );

  for (var i = 0; i <= 50; i++) {
    progressBar.current = i;
    Console.draw(progressBar);

    fullWidthBar.current = i;
    Console.draw(fullWidthBar);

    atCursorBar.current = i;
    Console.draw(atCursorBar);

    sleep(Duration(milliseconds: 50));
  }
}
