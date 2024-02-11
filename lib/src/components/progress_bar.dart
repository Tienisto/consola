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
  final String barTipCharacter;
  final String barSpaceCharacter;
  final ConsoleCoordinate position;

  ProgressBar._({
    required int? current,
    required this.total,
    required this.width,
    required String? head,
    required ProgressBarTextBuilder? headBuilder,
    required String? tail,
    required ProgressBarTextBuilder? tailBuilder,
    required String? barHead,
    required String? barTail,
    required String? barFillCharacter,
    required String? barTipCharacter,
    required String? barSpaceCharacter,
    required this.position,
  })  : current = current ?? 0,
        headBuilder = (head != null ? (_, __, ___) => head : headBuilder),
        tailBuilder = (tail != null ? (_, __, ___) => tail : tailBuilder),
        barHead = barHead ?? '[',
        barTail = barTail ?? ']',
        barFillCharacter = barFillCharacter ?? '#',
        barTipCharacter = barTipCharacter ?? '',
        barSpaceCharacter = barSpaceCharacter ?? ' ';

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
    String? barTipCharacter,
    String? barSpaceCharacter,
  }) {
    return ProgressBar._(
      current: current,
      total: total,
      width: width ??
          (console != null
              ? (console.getWindowWidth() - position.x + 1)
              : throw 'Specify width or provide a console.'),
      head: head,
      headBuilder: headBuilder,
      tail: tail,
      tailBuilder: tailBuilder,
      barHead: barHead,
      barTail: barTail,
      barFillCharacter: barFillCharacter,
      barTipCharacter: barTipCharacter,
      barSpaceCharacter: barSpaceCharacter,
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
    String? barTipCharacter,
    String? barSpaceCharacter,
  }) {
    final currentPosition = console.getCursorPosition();
    return ProgressBar._(
      current: current,
      total: total,
      width: width ?? (console.getWindowWidth() - currentPosition.x + 1),
      head: head,
      headBuilder: headBuilder,
      tail: tail,
      tailBuilder: tailBuilder,
      barHead: barHead,
      barTail: barTail,
      barFillCharacter: barFillCharacter,
      barTipCharacter: barTipCharacter,
      barSpaceCharacter: barSpaceCharacter,
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

    final tipCharacter = percent == 1 ? '' : barTipCharacter;

    final String bar =
        barFillCharacter * ((barWidth * percent).floor() - tipCharacter.length);
    final String space =
        barSpaceCharacter * (barWidth - bar.length - tipCharacter.length);

    console.moveToCoordinate(position);
    console.write('$head$barHead$bar$tipCharacter$space$barTail$tail');
  }
}
