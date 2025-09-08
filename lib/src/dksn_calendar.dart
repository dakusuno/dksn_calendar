import 'package:dksn_calendar/src/dksn_calendar_controller.dart';
import 'package:dksn_calendar/src/dksn_calendar_header.dart';
import 'package:dksn_calendar/src/dksn_calendar_monthly_item.dart';
import 'package:dksn_calendar/src/dksn_calendar_theme.dart';
import 'package:dksn_calendar/src/dksn_calendar_type.dart';
import 'package:dksn_calendar/src/dksn_calendar_utils.dart';
import 'package:dksn_calendar/src/dksn_calendar_weekly_item.dart';
import 'package:flutter/material.dart';

/// A customizable calendar widget that supports both monthly and weekly views.
///
/// The [DksnCalendar] provides a flexible calendar interface with:
/// - Monthly view showing a full month grid
/// - Weekly view showing a single week
/// - Customizable themes for different calendar components
/// - Date selection and navigation controls
/// - Optional custom header and day builders
///
/// ## Example
/// 
/// ```dart
/// DksnCalendar(
///   initialType: DksnCalendarType.monthly,
///   controller: DksnCalendarController(
///     DksnCalendarType.monthly,
///     DateTime.now(),
///   ),
///   theme: DksnCalendarTheme(
///     monthly: DksnCalendarMonthlyTheme(
///       dayBuilder: (currentDate, selectedDate, date) {
///         return Container(
///           decoration: BoxDecoration(
///             color: date == currentDate ? Colors.blue : null,
///           ),
///           child: Center(child: Text('${date.day}')),
///         );
///       },
///     ),
///   ),
/// )
/// ```
class DksnCalendar extends StatefulWidget {
  /// Creates a customizable calendar widget.
  ///
  /// The [initialType] determines whether the calendar starts in monthly or weekly view.
  /// The [controller] manages the calendar state and can be shared between multiple calendars.
  /// The [theme] allows customization of the calendar appearance and behavior.
  const DksnCalendar({
    super.key,
    this.controller,
    this.theme = const DksnCalendarTheme(),
    this.initialType = DksnCalendarType.monthly,
  });

  /// The controller that manages the calendar state.
  /// 
  /// If not provided, a default controller will be created automatically.
  /// You can use this to programmatically control the calendar or listen to changes.
  final DksnCalendarController? controller;

  /// The initial view type of the calendar.
  /// 
  /// Defaults to [DksnCalendarType.monthly]. Can be changed later using the controller.
  final DksnCalendarType initialType;

  /// The theme configuration for customizing the calendar appearance.
  /// 
  /// Includes themes for monthly view, weekly view, and header components.
  final DksnCalendarTheme theme;

  @override
  State<DksnCalendar> createState() => _DksnCalendarState();
}

class _DksnCalendarState extends State<DksnCalendar> {
  late DksnCalendarType _type;
  late DksnCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _controller = widget.controller ??
        DksnCalendarController(_type, DateTime.now().copyWith(month: 8));
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      _type = _controller.type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.theme.header.labelBuilder?.call(
              _controller.selectedDate,
              _controller.previous,
              _controller.next,
            ) ??
            DksnCalendarHeader(
              selectedDate: _controller.selectedDate,
              previous: _controller.previous,
              next: _controller.next,
            ),
        switch (_controller.type) {
          DksnCalendarType.weekly =>
            DksnCalendarWeekly(_controller, widget.theme.weekly),
          DksnCalendarType.monthly =>
            DksnCalendarMonthly(_controller, widget.theme.monthly),
        }
      ],
    );
  }
}

/// A weekly calendar view widget that displays a single week.
/// 
/// This widget shows 7 days (Sunday to Saturday) for the week containing
/// the selected date. It automatically generates the correct dates even
/// if the selected date is in the middle of the week.
class DksnCalendarWeekly extends StatelessWidget {
  /// Creates a weekly calendar view.
  /// 
  /// The [_controller] manages the calendar state and the [_theme] provides
  /// customization options for the weekly view.
  const DksnCalendarWeekly(this._controller, this._theme, {super.key});

  /// The calendar controller that manages state and date selection.
  final DksnCalendarController _controller;

  /// The theme configuration for the weekly calendar view.
  /// The theme configuration for the weekly calendar view.
  final DksnCalendarWeeklyTheme _theme;

  /// Generate days for the current week starting from Sunday.
  /// 
  /// Returns a list of 7 [DateTime] objects representing the days of the week
  /// containing the selected date. If the selected date is Wednesday, this will
  /// return [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday].
  List<DateTime> get _generatedDate {
    final startOfWeek = _controller.selectedDate.startOfWeek;

    return List.generate(
      7,
      (i) => startOfWeek.add(Duration(days: i)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          children: [
            ..._generatedDate.map(
              (d) =>
                  (_theme.dayBuilder == null
                      ? null
                      : _theme.dayBuilder!(
                          _controller.currentDate,
                          _controller.selectedDate,
                          d,
                        )) ??
                  DksnCalendarWeeklyItem(
                    date: d,
                    currentDate: _controller.currentDate,
                    selectedDate: _controller.selectedDate,
                    onSelectedDate: () => _controller.currentDateSelected(d),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A monthly calendar view widget that displays a full month grid.
/// 
/// This widget shows a complete month with weeks arranged in a grid format.
/// It includes days from the previous and next month to fill complete weeks,
/// ensuring a consistent 6-week grid layout.
class DksnCalendarMonthly extends StatelessWidget {
  /// Creates a monthly calendar view.
  /// 
  /// The [_controller] manages the calendar state and the [_theme] provides
  /// customization options for the monthly view.
  const DksnCalendarMonthly(this._controller, this._theme, {super.key});

  /// The calendar controller that manages state and date selection.
  final DksnCalendarController _controller;

  /// The theme configuration for the monthly calendar view.
  final DksnCalendarMonthlyTheme _theme;

  /// Generate all dates for the monthly calendar view.
  /// 
  /// Returns a list of [DateTime] objects that includes:
  /// - Days from the previous month to fill the beginning of the first week
  /// - All days of the current month
  /// - Days from the next month to fill the end of the last week
  /// 
  /// The result is always a multiple of 7 days to create complete weeks.
  List<DateTime> get _generatedDate {
    final weekCount = _controller.selectedDate.startOfMonth.weekday == 7
        ? 0
        : _controller.selectedDate.startOfMonth.weekday;

    final generatedDaysBefore = List.generate(
      weekCount,
      (i) => _controller.selectedDate.startOfMonth.subtract(
        Duration(days: weekCount - i),
      ),
    );

    final totalDaysInMonth = DateTime(
      _controller.selectedDate.year,
      _controller.selectedDate.month + 1,
      0,
    ).day;

    final totalCells = generatedDaysBefore.length + totalDaysInMonth;

    /// totalCellsIsNotMultipleOf7 roundUpIt
    final totalRoundedUp = (totalCells % 7 == 0)
        ? totalCells
        : totalCells + (7 - (totalCells % 7));

    final currentMonth = List.generate(
      totalRoundedUp - generatedDaysBefore.length,
      (i) => _controller.selectedDate.startOfMonth.add(
        Duration(days: i),
      ),
    );

    return [...generatedDaysBefore, ...currentMonth];
  }

  @override
  Widget build(BuildContext context) {
    const days = DksnCalendarDateType.values;

    return Column(
      children: [
        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 7,
          shrinkWrap: true,
          children: [
            ...days.map(
              (d) => Card(
                color: Colors.grey[300],
                child: Center(child: Text(d.labelDate)),
              ),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 7,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            ..._generatedDate.map(
              (d) =>
                  (_theme.dayBuilder == null
                      ? null
                      : _theme.dayBuilder!(
                          _controller.currentDate,
                          _controller.selectedDate,
                          d,
                          _controller.currentDateSelected,
                        )) ??
                  DksnCalendarMonthlyItem(
                    date: d,
                    currentDate: _controller.currentDate,
                    selectedDate: _controller.selectedDate,
                    onSelectedDate: () => _controller.currentDateSelected(d),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
