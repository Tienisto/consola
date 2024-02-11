import 'package:consola/src/component.dart';
import 'package:consola/src/console_executor.dart';
import 'package:consola/src/coordinate.dart';

typedef TableRowBuilder<T> = List<String> Function(T row);

class Table<T> extends AbsoluteConsoleComponent {
  final List<T> rows;
  final TableRowBuilder<T> rowBuilder;
  final List<String>? headers;

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
    required this.headerSeparator,
    required this.rowSeparator,
    required String? columnSeparator,
    required this.position,
  }) : columnSeparator = columnSeparator ?? ' | ';

  Table({
    required List<T> rows,
    required TableRowBuilder<T> rowBuilder,
    List<String>? headers,
    String? headerSeparator,
    String? rowSeparator,
    String? columnSeparator,
    required ConsoleCoordinate position,
  }) : this._(
          rows: rows,
          rowBuilder: rowBuilder,
          headers: headers,
          headerSeparator: headerSeparator,
          rowSeparator: rowSeparator,
          columnSeparator: columnSeparator,
          position: position,
        );

  @override
  void draw(ConsoleExecutor console) {
    console.moveToCoordinate(position);

    final List<List<String>> rowStrings = rows.map(rowBuilder).toList();
    int maxWidth = 0;
    if (headers != null) {
      maxWidth = headers!
              .fold<int>(0, (int acc, String header) => acc + header.length) +
          (headers!.length - 1) * columnSeparator.length;
    }
    for (final List<String> row in rowStrings) {
      final rowWidth =
          row.fold<int>(0, (int acc, String cell) => acc + cell.length) +
              (row.length - 1) * columnSeparator.length;

      if (rowWidth > maxWidth) {
        maxWidth = rowWidth;
      }
    }

    final int tableWidth = maxWidth;

    if (headers != null) {
      console.write(headers!.join(columnSeparator));
      console.write('\n');

      final separator = headerSeparator ?? rowSeparator;
      if (separator != null) {
        console.write(separator);
        console.write('\n');
      }
    }

    for (final List<String> row in rowStrings) {
      console.write(row.join(columnSeparator));
      console.write('\n');

      if (rowSeparator != null) {
        console.write(rowSeparator!);
        console.write('\n');
      }
    }
  }
}
