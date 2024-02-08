import 'dart:math';

class ConsoleCoordinate extends Point<int> {
  const ConsoleCoordinate(super.x, super.y);

  /// Alias for [x].
  int get row => y;

  /// Alias for [y].
  int get col => x;

  @override
  String toString() => '($x, $y)';
}
