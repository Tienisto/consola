import 'package:consola/consola.dart';

void main() {
  Console.clearScreen();

  final table = Table(
    rows: [
      ['John Doe', '25', 'USA'],
      ['Jane Doe', '23', 'USA'],
      ['Foo Bar', '30', 'UK'],
    ],
    rowBuilder: (row) => row,
    headers: ['Name', 'Age', 'Country'],
    position: ConsoleCoordinate(1, 1),
  );

  Console.draw(table);
}
