import 'package:consola/src/component.dart';
import 'package:consola/src/console_executor.dart';
import 'package:consola/src/coordinate.dart';

typedef TableRowBuilder<T> = List<String> Function(T row);

sealed class TableColumnWidth {}

class FlexColumnWidth extends TableColumnWidth {
  final double flex;

  FlexColumnWidth(this.flex);
}

class FixedColumnWidth extends TableColumnWidth {
  final double width;

  FixedColumnWidth(this.width);
}

class IntrinsicColumnWidth extends TableColumnWidth {}

enum TextAlignment { left, right, center }

class Table<T> extends AbsoluteConsoleComponent {
  final List<T> rows;
  final TableRowBuilder<T> rowBuilder;
  final List<String>? headers;

  /// Total width of the table.
  final int? tableWidth;

  /// The width of each column.
  /// If null, [IntrinsicColumnWidth] will be used for all columns.
  /// The index is 0-based.
  final Map<int, TableColumnWidth>? columnWidths;

  /// The alignment of each column.
  /// If null, [TextAlignment.left] will be used for all columns.
  /// The index is 0-based.
  final Map<int, TextAlignment>? columnHorizontalAlignments;

  /// The default horizontal alignment.
  final TextAlignment? defaultHorizontalAlignment;

  /// The separator to be used between the headers and the rows.
  /// If null, the row separator will be used.
  /// If the row separator is also null, there will be no separator.
  final String? headerSeparator;

  /// The separator to be used between the rows.
  /// If null, there will be no separator.
  final String? rowSeparator;

  /// The separator to be used between the columns.
  final String columnSeparator;

  /// The position where the table will be drawn.
  /// Equivalent to the top-left corner of the table.
  final ConsoleCoordinate position;

  Table._({
    required this.rows,
    required this.rowBuilder,
    required this.headers,
    required this.tableWidth,
    required this.columnWidths,
    required this.columnHorizontalAlignments,
    required this.defaultHorizontalAlignment,
    required this.headerSeparator,
    required this.rowSeparator,
    required String? columnSeparator,
    required this.position,
  }) : columnSeparator = columnSeparator ?? ' | ';

  Table({
    required List<T> rows,
    required TableRowBuilder<T> rowBuilder,
    List<String>? headers,
    int? tableWidth,
    Map<int, TableColumnWidth>? columnWidths,
    Map<int, TextAlignment>? columnAlignments,
    TextAlignment? defaultHorizontalAlignment,
    String? headerSeparator,
    String? rowSeparator,
    String? columnSeparator,
    required ConsoleCoordinate position,
  }) : this._(
          rows: rows,
          rowBuilder: rowBuilder,
          headers: headers,
          tableWidth: tableWidth,
          columnWidths: columnWidths,
          columnHorizontalAlignments: columnAlignments,
          defaultHorizontalAlignment: defaultHorizontalAlignment,
          headerSeparator: headerSeparator,
          rowSeparator: rowSeparator,
          columnSeparator: columnSeparator,
          position: position,
        );

  @override
  void draw(ConsoleExecutor console) {
    console.moveToCoordinate(position);

    final List<List<String>> rowStrings = [
      if (headers != null) headers!,
      ...rows.map(rowBuilder),
    ].toList();

    final Map<int, int> intrinsicColumnWidths = {};
    for (int i = 0; i < rowStrings[0].length; i++) {
      intrinsicColumnWidths[i] = rowStrings.fold<int>(
          0,
          (int acc, List<String> row) =>
              acc > row[i].length ? acc : row[i].length);
    }

    final tableWidth = this.tableWidth ??
        intrinsicColumnWidths.values
                .fold<int>(0, (int acc, int width) => acc + width) +
            (columnSeparator.length * (rowStrings[0].length - 1));

    for (int i = 0; i < rowStrings.length; i++) {
      final List<String> row = rowStrings[i];

      _writeRow(
        console: console,
        row: row,
        columnWidths: intrinsicColumnWidths,
        columnAlignments: columnHorizontalAlignments ?? {},
        defaultHorizontalAlignment:
            defaultHorizontalAlignment ?? TextAlignment.left,
        separator: columnSeparator,
      );

      if (i == 0 && headerSeparator != null) {
        console.write(headerSeparator! * tableWidth);
        console.write('\n');
      } else if (rowSeparator != null) {
        console.write(rowSeparator! * tableWidth);
        console.write('\n');
      }
    }
  }
}

void _writeRow({
  required ConsoleExecutor console,
  required List<String> row,
  required Map<int, int> columnWidths,
  required Map<int, TextAlignment> columnAlignments,
  required TextAlignment defaultHorizontalAlignment,
  required String separator,
}) {
  // Each column may have multiple lines.
  final List<List<String>> lines = [];

  for (int i = 0; i < row.length; i++) {
    final rowString = row[i];
    final rowWidthConstraint = columnWidths[i]!;
    final int lineCount = (rowString.length / rowWidthConstraint).ceil();
    final List<String> rowLines = List.generate(lineCount, (index) {
      final int start = index * rowWidthConstraint;
      final int end = (index + 1) * rowWidthConstraint;
      if (end >= rowString.length) {
        return rowString.substring(start);
      }
      return rowString.substring(start, end);
    });
    lines.add(rowLines);
  }

  final int maxLineCount = lines.fold<int>(0,
      (int acc, List<String> lines) => acc > lines.length ? acc : lines.length);

  for (int i = 0; i < maxLineCount; i++) {
    final List<String> line = [
      for (int j = 0; j < row.length; j++)
        if (i < lines[j].length)
          lines[j][i].applyAlignment(
              columnAlignments[j] ?? defaultHorizontalAlignment,
              columnWidths[j]!)
        else
          ' ' * columnWidths[j]!
    ];
    console.write(line.join(separator));
    console.write('\n');
  }
}

extension on String {
  String applyAlignment(TextAlignment alignment, int width) {
    switch (alignment) {
      case TextAlignment.left:
        return padRight(width);
      case TextAlignment.right:
        return padLeft(width);
      case TextAlignment.center:
        final int pad = (width - length) ~/ 2;
        return padRight(pad + length).padLeft(width);
    }
  }
}
