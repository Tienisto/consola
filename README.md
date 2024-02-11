# Consola

[![pub package](https://img.shields.io/pub/v/consola.svg)](https://pub.dev/packages/consola)
![ci](https://github.com/Tienisto/consola/actions/workflows/ci.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A utility library to help developing command-line applications in Dart. Provides screen manipulation, ANSI escape codes, and more.

## Table of Contents

- [Getting Started](#getting-started)
- [Cursor Manipulation](#cursor-manipulation)
- [Screen Manipulation](#screen-manipulation)
- [Colors](#colors)
- [Dimensions](#dimensions)
- [User Input](#user-input)
- [Components](#components)
  - [Progress Bar](#-progress-bar)
- [ANSI Escape Codes](#ansi-escape-codes)
- [Mocking](#mocking)
- [Examples](#examples)
  - [Rerender a section of the screen](#-rerender-a-section-of-the-screen)

## Getting Started

```yaml
# pubspec.yaml
dependencies:
  consola: <version>
```

## Cursor Manipulation

You can move the cursor around.

```dart
void main() {
  Console.moveUp();
  Console.moveTo(22, 41);
  Console.moveToTopLeft();
}
```

## Screen Manipulation

You can clear a section of the screen.

```dart
void main() {
  Console.clearScreen();
  Console.clearLine();
  Console.clearCurrentToScreenEnd();
}
```

## Colors

You can colorize the text.

```dart
void main() {
  Console.write('Hello ', foregroundColor: SimpleColor.green);
  Console.write('World', backgroundColor: SimpleColor.red);
}
```

## Dimensions

You can get the dimensions of the terminal.

```dart
void main() {
  int width = Console.getWindowWidth();
  int height = Console.getWindowHeight();
}
```

## User Input

You can read the user input in a type-safe way.

```dart
void main() {
  int? age = Console.readInt(prompt: 'Enter your age: ');
  Console.writeLine('You are $age years old.');
}
```

## Components

There is a set of components that you can use to speed up the development of your command-line applications.

The state is stored in the component. You can draw the component by calling `Console.draw(component)`.

### ➤ Progress Bar

A horizontal progress bar.

```text
Progress A: [##################              ] 58%
Progress B: [=================>--------------] 58%
Progress C: |##################..............| 12 MB/s 58%
```

```dart
void main() {
  Console.clearScreen();

  final progressBar = ProgressBar.atPosition(
    total: 50,
    width: 100,
    position: ConsoleCoordinate(1, 2),
    head: 'Progress A: ',
    barFillCharacter: '#',
    tailBuilder: (_, __, percent) => ' ${percent.toStringAsFixed(0)}%',
  );

  for (var i = 0; i <= 50; i++) {
    progressBar.current = i;
    Console.draw(progressBar);
    sleep(Duration(milliseconds: 50));
  }
}
```

## ANSI Escape Codes

You can access the underlying ANSI escape codes by accessing the `ConsoleStrings` class.

```dart
void main() {
  String eraseScreen = ConsoleStrings.eraseScreen;
  String esc = ConsoleStrings.escape;
  String csi = ConsoleStrings.csi;
}
```

## Mocking

You can also mock the `Console` by setting `Console.instance` to a mocked object.

```dart
import 'package:your_package/gen/env.g.dart';

class MockConsoleExecutor extends ConsoleExecutor {
  @override
  void clearScreen({bool resetCursor = true}) {
    print('Screen cleared');
  }
}

void main() {
  Console.clearScreen(); // clears the screen
  Console.instance = MockConsoleExecutor();
  Console.clearScreen(); // prints "Screen cleared"
}
```

## Examples

### ➤ Rerender a section of the screen

To rerender a section of the screen, you need to save and restore the cursor position.

```dart
void main() {
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
```

## License

MIT License

Copyright (c) 2024 Tien Do Nam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
