import 'package:flutter/cupertino.dart';

/// The main theme configuration for [DksnCalendar].
///
/// This class contains theme configurations for all calendar components:
/// - [monthly]: Theme for the monthly calendar view
/// - [weekly]: Theme for the weekly calendar view
/// - [header]: Theme for the calendar header
///
/// ## Example
///
/// ```dart
/// DksnCalendarTheme(
///   monthly: DksnCalendarMonthlyTheme(
///     dayBuilder: (currentDate, selectedDate, date) {
///       return YourCustomDayWidget(date);
///     },
///   ),
///   header: DksnCalendarHeaderTheme(
///     labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
///   ),
/// )
/// ```
class DksnCalendarTheme {
  /// Creates a calendar theme configuration.
  const DksnCalendarTheme({
    this.monthly = const DksnCalendarMonthlyTheme(),
    this.weekly = const DksnCalendarWeeklyTheme(),
    this.header = const DksnCalendarHeaderTheme(),
  });

  /// Theme configuration for the monthly calendar view.
  final DksnCalendarMonthlyTheme monthly;

  /// Theme configuration for the weekly calendar view.
  final DksnCalendarWeeklyTheme weekly;

  /// Theme configuration for the calendar header.
  final DksnCalendarHeaderTheme header;
}

/// Theme configuration for the monthly calendar view.
///
/// Allows customization of how days are displayed and how date selection is handled
/// in the monthly view.
class DksnCalendarMonthlyTheme {
  /// Creates a monthly calendar theme.
  const DksnCalendarMonthlyTheme({
    this.dayBuilder,
    this.onDateSelected,
  });

  /// Custom builder for rendering individual day widgets.
  ///
  /// If provided, this function will be called for each day in the calendar
  /// to create a custom widget. The function receives:
  /// - [currentDate]: The currently highlighted/selected date
  /// - [selectedDate]: The date used for navigation (current month/week)
  /// - [date]: The date being rendered
  /// - [onDateSelected]: Function to call when a date is selected
  ///
  /// Return `null` to use the default day widget.
  final Widget? Function(
    DateTime currentDate,
    DateTime selectedDate,
    DateTime date,
    void Function(DateTime date) onDateSelected,
  )? dayBuilder;

  /// Callback function called when a date is selected.
  ///
  /// This is called in addition to the controller's date selection handling.
  /// Use this for custom logic when dates are selected.
  final void Function(
    DateTime date,
  )? onDateSelected;
}

/// Theme configuration for the weekly calendar view.
///
/// Allows customization of how days are displayed and how date selection is handled
/// in the weekly view.
class DksnCalendarWeeklyTheme {
  /// Creates a weekly calendar theme.
  const DksnCalendarWeeklyTheme({
    this.dayBuilder,
    this.onDateSelected,
  });

  /// Custom builder for rendering individual day widgets.
  ///
  /// If provided, this function will be called for each day in the week
  /// to create a custom widget. The function receives:
  /// - [currentDate]: The currently highlighted/selected date
  /// - [selectedDate]: The date used for navigation (current month/week)
  /// - [date]: The date being rendered
  ///
  /// Return `null` to use the default day widget.
  final Widget? Function(
    DateTime currentDate,
    DateTime selectedDate,
    DateTime date,
  )? dayBuilder;

  /// Callback function called when a date is selected.
  ///
  /// This is called in addition to the controller's date selection handling.
  /// Use this for custom logic when dates are selected.
  final void Function(
    DateTime date,
  )? onDateSelected;
}

/// Theme configuration for the calendar header.
///
/// Allows customization of the header appearance including navigation icons,
/// date label, and completely custom header builders.
class DksnCalendarHeaderTheme {
  /// Creates a calendar header theme.
  const DksnCalendarHeaderTheme({
    this.leftIcon,
    this.rightIcon,
    this.label,
    this.labelStyle,
    this.labelBuilder,
  });

  /// Custom widget for the left navigation icon (previous month/week).
  ///
  /// If not provided, a default arrow icon will be used.
  final Widget? leftIcon;

  /// Custom widget for the right navigation icon (next month/week).
  ///
  /// If not provided, a default arrow icon will be used.
  final Widget? rightIcon;

  /// Custom function to generate the header label text.
  ///
  /// Receives the current selected date and should return a string
  /// to display in the header. If not provided, a default date
  /// formatter will be used.
  final String? Function(DateTime date)? label;

  /// Text style for the header label.
  ///
  /// Applied to the header text. If not provided, the default
  /// theme text style will be used.
  final TextStyle? labelStyle;

  /// Custom builder for the entire header widget.
  ///
  /// If provided, this completely replaces the default header.
  /// The function receives:
  /// - [date]: The current selected date
  /// - [previous]: Function to navigate to previous month/week
  /// - [next]: Function to navigate to next month/week
  ///
  /// Use this for complete header customization.
  final Widget? Function(
          DateTime date, void Function() previous, void Function() next)?
      labelBuilder;
}
