/// Provides a set of strings for controlling the console.
/// Function names follow the naming convention of the ANSI escape codes.
///
/// Outside of this class,
/// - "move" is used instead of "cursor"
/// - "clear" is used instead of "erase"
class ConsoleStrings {
  // C0 control codes
  // https://en.wikipedia.org/wiki/ANSI_escape_code#C0_control_codes

  static const String bell = '\u0007';
  static const String backSpace = '\u0008';
  static const String tab = '\u0009';
  static const String lineFeed = '\u000A';
  static const String formFeed = '\u000C';
  static const String carriageReturn = '\u000D';
  static const String escape = '\u001B';

  static const String csi = '$escape[';
  static const String osc = '$escape]';

  // CSI sequences
  // https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_(Control_Sequence_Introducer)_sequences

  /// Moves the cursor up by [n] rows; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static String cursorUp([int n = 1]) => '$csi${n}A';

  /// Moves the cursor down by [n] rows; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static String cursorDown([int n = 1]) => '$csi${n}B';

  /// Moves the cursor forward (right) by [n] columns; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static String cursorForward([int n = 1]) => '$csi${n}C';

  /// Moves the cursor backward (left) by [n] columns; the default is 1.
  /// If the cursor is already at the edge of the screen, this has no effect.
  static String cursorBackward([int n = 1]) => '$csi${n}D';

  /// Moves the cursor to the beginning of the line [n] lines down (default 1).
  static String cursorNextLine([int n = 1]) => '$csi${n}E';

  /// Moves the cursor to the beginning of the line [n] lines up (default 1).
  static String cursorPrevLine([int n = 1]) => '$csi${n}F';

  /// Moves the cursor to column n.
  static String cursorToColumn(int n) => '$csi${n}G';

  /// Moves the cursor to the specific position (x, y).
  /// Indices start at 1, not 0.
  static String cursorTo(int x, int y) => '$csi$y;${x}H';

  /// Moves the cursor to the top left.
  static String cursorToHome = '${csi}H';

  /// Native erase display sequence.
  /// Use [eraseCurrentToEndScreen], [eraseCurrentToStartScreen],
  /// [eraseScreen], [eraseScreenClearScrollback] for convenience.
  static String eraseDisplayNative(int n) => '$csi${n}J';

  /// Erases from the current cursor position to the end of the screen.
  static String eraseCurrentToEndScreen = eraseDisplayNative(0);

  /// Erases from the current cursor position to the start of the screen.
  static String eraseCurrentToStartScreen = eraseDisplayNative(1);

  /// Erases the entire screen.
  /// Moves the cursor to the top left (only on DOS with ANSI.SYS).
  static String eraseScreen = eraseDisplayNative(2);

  /// Erases the entire screen and clears the scrollback buffer.
  static String eraseScreenClearScrollback = eraseDisplayNative(3);

  /// Native erase line sequence.
  static String eraseLineNative(int n) => '$csi${n}K';

  /// Erases from the current cursor position to the end of the line.
  static String eraseCurrentToEndLine = eraseLineNative(0);

  /// Erases from the current cursor position to the start of the line.
  static String eraseCurrentToStartLine = eraseLineNative(1);

  /// Erases the entire current line. Cursor position does not change.
  static String eraseLine = eraseLineNative(2);

  /// Scroll up by n lines. New lines are added at the bottom.
  static String scrollUp(int n) => '$csi${n}S';

  /// Scroll down by n lines. New lines are added at the top.
  static String scrollDown(int n) => '$csi${n}T';

  /// Returns the cursor position in `ESC[n;mR` format
  /// where n is the row and m is the column.
  static String deviceStatusReport = '${csi}6n';

  /// Native color sequence.
  static String setColorNative({
    int? foreground,
    int? background,
  }) {
    if (foreground != null && background != null) {
      return '$csi$foreground;${background}m';
    } else if (foreground != null) {
      return '$csi${foreground}m';
    } else if (background != null) {
      return '$csi${background}m';
    } else {
      return '';
    }
  }

  /// Set the foreground and background color (type-safe).
  static String setColor({
    SimpleColor? foreground,
    SimpleColor? background,
  }) {
    return setColorNative(
      foreground: foreground?.foreground,
      background: background?.background,
    );
  }

  /// Native 256 color sequence to set the foreground color.
  static String setForegroundColorNative256(int colorCode) {
    return '${csi}38;5;${colorCode}m';
  }

  /// Native 256 color sequence to set the background color.
  static String setBackgroundColorNative256(int colorCode) {
    return '${csi}48;5;${colorCode}m';
  }

  /// Resets the current color setting.
  static String resetColor = '${csi}0m';
}

/// 3/4-bit color.
/// https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
enum SimpleColor {
  black(30, 40),
  red(31, 41),
  green(32, 42),
  yellow(33, 43),
  blue(34, 44),
  magenta(35, 45),
  cyan(36, 46),
  white(37, 47);

  final int foreground;
  final int background;

  const SimpleColor(this.foreground, this.background);
}
