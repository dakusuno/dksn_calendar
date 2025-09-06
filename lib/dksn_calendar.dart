/// A customizable Flutter calendar library that supports both monthly and weekly views.
/// 
/// The DKSN Calendar library provides a flexible calendar widget with:
/// - Monthly and weekly calendar views
/// - Customizable themes and day builders
/// - Date selection and navigation
/// - Header customization
/// 
/// ## Usage
/// 
/// ```dart
/// import 'package:dksn_calendar/dksn_calendar.dart';
/// 
/// // Basic usage
/// DksnCalendar()
/// 
/// // With controller and custom theme
/// DksnCalendar(
///   controller: DksnCalendarController(DksnCalendarType.monthly),
///   theme: DksnCalendarTheme(
///     monthly: DksnCalendarMonthlyTheme(
///       dayBuilder: (currentDate, selectedDate, date) {
///         // Custom day widget
///         return YourCustomDayWidget(date);
///       },
///     ),
///   ),
/// )
/// ```
library dksn_calendar;

export 'src/dksn_calendar.dart';
export 'src/dksn_calendar_controller.dart';
export 'src/dksn_calendar_theme.dart';
export 'src/dksn_calendar_type.dart';