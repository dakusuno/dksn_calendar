/// Extension methods on [DateTime] to provide calendar-specific utilities.
/// 
/// These extensions add useful methods for calendar operations like
/// finding week starts, month boundaries, and date comparisons.
extension ExtensionDateTime on DateTime {
  /// Returns a new DateTime instance representing the first day of the month at midnight.
  /// 
  /// Example:
  /// ```dart
  /// final date = DateTime(2023, 8, 15, 14, 30); // August 15, 2023 2:30 PM
  /// final monthStart = date.startOfMonth; // August 1, 2023 12:00 AM
  /// ```
  DateTime get startOfMonth => DateTime(
        year,
        month,
      );

  /// Returns a new DateTime instance representing the next day.
  /// 
  /// Example:
  /// ```dart
  /// final today = DateTime(2023, 8, 15);
  /// final tomorrow = today.nextDay; // August 16, 2023
  /// ```
  DateTime get nextDay => add(const Duration(days: 1));

  /// Returns a new DateTime instance representing the start of the week (Sunday).
  /// 
  /// The week is considered to start on Sunday (weekday 7) and end on Saturday (weekday 6).
  /// 
  /// Example:
  /// ```dart
  /// final wednesday = DateTime(2023, 8, 16); // Wednesday
  /// final weekStart = wednesday.startOfWeek; // Sunday, August 13, 2023
  /// ```
  DateTime get startOfWeek => subtract(Duration(days: weekday % 7));

  /// Checks if the given [date] is in the next month relative to this date.
  /// 
  /// Returns `true` if [date] is in the month following this date's month.
  /// Handles year transitions correctly (December -> January).
  /// 
  /// Example:
  /// ```dart
  /// final august = DateTime(2023, 8, 15);
  /// final september = DateTime(2023, 9, 10);
  /// august.isNextMonth(september); // true
  /// ```
  bool isNextMonth(DateTime date) {
    final nextMonth = month == 12 ? 1 : month + 1;
    final yearOfNextMonth = month == 12 ? year + 1 : year;
    return date.month == nextMonth && date.year == yearOfNextMonth;
  }

  /// Checks if the given [date] is in the previous month relative to this date.
  /// 
  /// Returns `true` if [date] is in the month preceding this date's month.
  /// Handles year transitions correctly (January -> December).
  /// 
  /// Example:
  /// ```dart
  /// final august = DateTime(2023, 8, 15);
  /// final july = DateTime(2023, 7, 20);
  /// august.isPreviousMonth(july); // true
  /// ```
  bool isPreviousMonth(DateTime date) {
    final previousMonth = month == 1 ? 12 : month - 1;
    final yearOfPreviousMonth = month == 1 ? year - 1 : year;
    return date.month == previousMonth && date.year == yearOfPreviousMonth;
  }
}
