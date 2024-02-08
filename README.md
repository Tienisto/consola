# consola

[![pub package](https://img.shields.io/pub/v/consola.svg)](https://pub.dev/packages/consola)
![ci](https://github.com/Tienisto/consola/actions/workflows/ci.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Consola provides utilities for command-line applications.

## Table of Contents

- [Getting Started](#getting-started)
- [Cursor Manipulation](#cursor-manipulation)
- [Screen Manipulation](#screen-manipulation)
- [Colors](#colors)
- [Dimensions](#dimensions)
- [Mocking](#mocking)

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

You can clear the desired part screen.

```dart
void main() {
  Console.clearScreen();
  Console.clearLine();
  Console.clearCurrentToStartScreen();
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
