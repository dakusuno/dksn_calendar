
import 'package:dksn_calendar/src/dksn_calendar_theme.dart';
import 'package:flutter/material.dart';

/// Default header widget for [DksnCalendar].
/// 
/// Displays a navigation header with:
/// - Left arrow button for previous month/week navigation
/// - Center label showing the current date
/// - Right arrow button for next month/week navigation
/// 
/// The appearance can be customized using [DksnCalendarHeaderTheme].
class DksnCalendarHeader extends StatelessWidget {
  /// Creates a calendar header.
  /// 
  /// The [selectedDate] determines what date is displayed in the label.
  /// The [previous] and [next] functions handle navigation.
  /// The [theme] allows customization of the header appearance.
  const DksnCalendarHeader({
    super.key,
    this.theme = const DksnCalendarHeaderTheme(),
    required this.selectedDate,
    required this.previous,
    required this.next,
  });

  /// Theme configuration for customizing the header appearance.
  final DksnCalendarHeaderTheme theme;

  /// The currently selected date to display in the header.
  final DateTime selectedDate;

  /// Callback function for navigating to the previous month/week.
  final void Function() previous;

  /// Callback function for navigating to the next month/week.
  final void Function() next;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        theme.leftIcon ??
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: previous,
            ),
        Text(
          theme.label?.call(selectedDate) ??
              '''${selectedDate.year} - ${selectedDate.month.toString().padLeft(2, '0')}''',
          style: theme.labelStyle ?? Theme.of(context).textTheme.titleLarge,
        ),
        theme.rightIcon ??
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: next,
            ),
      ],
    );
  }
}
