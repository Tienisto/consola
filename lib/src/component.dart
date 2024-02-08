import 'package:consola/src/console_executor.dart';
import 'package:consola/src/coordinate.dart';

sealed class ConsoleComponent {}

/// A component that can be drawn on the console using precise coordinates.
abstract class AbsoluteConsoleComponent implements ConsoleComponent {
  /// Draws the component on the console.
  ///
  /// It should **not** restore the cursor position.
  /// The caller is responsible for restoring the cursor position to
  /// improve performance.
  void draw(ConsoleExecutor console);
}

/// A component that can be drawn on the console relative to a cursor position.
abstract class RelativeConsoleComponent implements ConsoleComponent {
  /// Draws the component on the console.
  ///
  /// It should **not** restore the cursor position.
  /// The caller is responsible for restoring the cursor position to
  /// improve performance.
  void draw(ConsoleExecutor console, ConsoleCoordinate cursor);
}
