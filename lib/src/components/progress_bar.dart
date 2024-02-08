import 'package:consola/src/component.dart';
import 'package:consola/src/console_executor.dart';
import 'package:consola/src/coordinate.dart';

typedef ProgressBarTextBuilder = String Function(
  int current,
  int total,
  double percent,
);

/// A linear progress bar that can be drawn on the console.
class ProgressBar extends AbsoluteConsoleComponent {
  int current;
  final int total;
  final int width;
  final ProgressBarTextBuilder? headBuilder;
  final ProgressBarTextBuilder? tailBuilder;
  final String barHead;
  final String barTail;
  final String barFillCharacter;
  final ConsoleCoordinate position;

  ProgressBar._({
    int? current,
    required this.total,
    required this.width,
    required this.headBuilder,
    required this.tailBuilder,
    String? barHead,
    String? barTail,
    String? barFillCharacter,
    required this.position,
  })  : current = current ?? 0,
        barHead = barHead ?? '[',
        barTail = barTail ?? ']',
        barFillCharacter = barFillCharacter ?? '=';

  factory ProgressBar.atPosition({
    int? current,
    required int total,
    int? width,
    ConsoleExecutor? console,
    required ConsoleCoordinate position,
    String? head,
    ProgressBarTextBuilder? headBuilder,
    String? tail,
    ProgressBarTextBuilder? tailBuilder,
    String? barHead,
    String? barTail,
    String? barFillCharacter,
  }) {
    return ProgressBar._(
      current: current,
      total: total,
      width: width ??
          (console != null
              ? (console.getWindowWidth() - position.x + 1)
              : throw 'Specify width or provide a console.'),
      headBuilder: (head != null ? (_, __, ___) => head : headBuilder),
      tailBuilder: (tail != null ? (_, __, ___) => tail : tailBuilder),
      barHead: barHead,
      barTail: barTail,
      barFillCharacter: barFillCharacter,
      position: position,
    );
  }

  factory ProgressBar.atCursor({
    int? current,
    required int total,
    int? width,
    required ConsoleExecutor console,
    String? head,
    ProgressBarTextBuilder? headBuilder,
    String? tail,
    ProgressBarTextBuilder? tailBuilder,
    String? barHead,
    String? barTail,
    String? barFillCharacter,
  }) {
    final currentPosition = console.getCursorPosition();
    return ProgressBar._(
      current: current,
      total: total,
      width: width ?? (console.getWindowWidth() - currentPosition.x + 1),
      headBuilder: (head != null ? (_, __, ___) => head : headBuilder),
      tailBuilder: (tail != null ? (_, __, ___) => tail : tailBuilder),
      barHead: barHead,
      barTail: barTail,
      barFillCharacter: barFillCharacter,
      position: currentPosition,
    );
  }

  bool get isRunning => current < total;

  bool get isCompleted => current >= total;

  @override
  void draw(ConsoleExecutor console) {
    final percent = current / total;
    final percent100 = percent * 100;
    final head = headBuilder?.call(current, total, percent100) ?? '';
    final tail = tailBuilder?.call(current, total, percent100) ?? '';
    final barWidth =
        width - head.length - tail.length - barHead.length - barTail.length;
    final bar = barFillCharacter * (barWidth * percent).floor();
    final space = ' ' * (barWidth - bar.length);

    console.moveToCoordinate(position);
    console.write('$head$barHead$bar$space$barTail$tail');
  }
}
