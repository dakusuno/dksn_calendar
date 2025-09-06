import 'package:flutter/material.dart';

/// Default day item widget for the monthly calendar view.
/// 
/// This widget represents a single day in the monthly calendar grid.
/// It handles different visual states:
/// - Current date highlighting
/// - Different month day styling (grayed out)
/// - Touch interactions for date selection
class DksnCalendarMonthlyItem extends StatelessWidget {
  /// Creates a monthly calendar day item.
  /// 
  /// The [date] is the specific date this item represents.
  /// The [selectedDate] is used to determine if this day is in a different month.
  /// The [currentDate] is used to highlight the current date.
  /// The [onSelectedDate] callback is called when this day is tapped.
  const DksnCalendarMonthlyItem({
    super.key,
    required this.date,
    required this.selectedDate,
    required this.currentDate,
    required this.onSelectedDate,
  });

  /// The date this item represents.
  final DateTime date;

  /// The currently selected date (used for month comparison).
  final DateTime selectedDate;

  /// The current date (highlighted differently).
  final DateTime currentDate;

  /// Callback function called when this day is selected.
  final void Function() onSelectedDate;

  /// Returns true if this item represents the current date.
  bool get isCurrentDate =>
      date.year == currentDate.year &&
      date.month == currentDate.month &&
      date.day == currentDate.day;

  /// Returns true if this day is from a different month than the selected date.
  /// 
  /// Days from adjacent months are typically shown in a grayed out style.
  bool get isDifferentMonthThanSelected => date.month != selectedDate.month;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrentDate
          ? Theme.of(context).primaryColor
          : isDifferentMonthThanSelected
              ? Colors.grey[200]
              : Colors.white,
      child: InkWell(
        onTap: onSelectedDate,
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: isCurrentDate ? Colors.white : Colors.black,
              fontWeight: isCurrentDate ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
