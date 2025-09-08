import 'package:dksn_calendar/src/dksn_calendar_utils.dart';
import 'package:flutter/foundation.dart';
import 'dksn_calendar_type.dart';

/// A controller that manages the state of a [DksnCalendar] widget.
/// 
/// The controller handles:
/// - Calendar view type (monthly or weekly)
/// - Selected date for navigation
/// - Current date for highlighting
/// - Date selection events
/// - Navigation between months/weeks
/// - Type change notifications
/// - Selected date change notifications
/// 
/// ## Example
/// 
/// ```dart
/// final controller = DksnCalendarController(
///   DksnCalendarType.monthly,
///   DateTime.now(),
/// );
/// 
/// // Listen to general changes
/// controller.addListener(() {
///   print('Selected date: ${controller.selectedDate}');
/// });
/// 
/// // Listen specifically to type changes
/// controller.addTypeChangeListener((newType) {
///   print('Calendar type changed to: $newType');
/// });
/// 
/// // Listen specifically to selected date changes
/// controller.addSelectedDateChangeListener((newDate) {
///   print('Selected date changed to: $newDate');
/// });
/// 
/// // Navigate to next month/week
/// controller.next();
/// 
/// // Select a specific date
/// controller.currentDateSelected(DateTime.now());
/// 
/// // Change calendar type
/// controller.setType(DksnCalendarType.weekly);
/// 
/// // Change selected date
/// controller.setSelectedDate(DateTime(2025, 10, 15));
/// ```
class DksnCalendarController extends ChangeNotifier {
  /// Creates a new calendar controller.
  /// 
  /// The [_type] determines the initial view type (monthly or weekly).
  /// The [selectedDate] is the date used for navigation (defaults to current date).
  /// The [currentDate] is the currently selected/highlighted date (defaults to current date).
  DksnCalendarController([
    this._type = DksnCalendarType.monthly,
    DateTime? selectedDate,
    DateTime? currentDate,
  ])  : _selectedDate = selectedDate ?? DateTime.now(),
        _currentDate = currentDate ?? DateTime.now();

  /// The current view type of the calendar.
  DksnCalendarType _type;

  /// List of listeners that will be called when the calendar type changes.
  final List<ValueChanged<DksnCalendarType>> _typeChangeListeners = [];

  /// List of listeners that will be called when the selected date changes.
  final List<ValueChanged<DateTime>> _selectedDateChangeListeners = [];

  /// Gets the current calendar view type.
  DksnCalendarType get type => _type;

  /// The date used for calendar navigation and month/week display.
  DateTime _selectedDate;

  /// The currently selected/highlighted date.
  DateTime _currentDate;

  /// Gets the selected date used for navigation.
  DateTime get selectedDate => _selectedDate;

  /// Gets the currently selected/highlighted date.
  /// Gets the currently selected/highlighted date.
  DateTime get currentDate => _currentDate;

  /// Adds a listener for calendar type changes.
  /// 
  /// The [listener] will be called whenever the calendar type changes.
  /// The listener receives the new [DksnCalendarType] as a parameter.
  void addTypeChangeListener(ValueChanged<DksnCalendarType> listener) {
    _typeChangeListeners.add(listener);
  }

  /// Removes a previously added type change listener.
  /// 
  /// The [listener] must be the same instance that was added via [addTypeChangeListener].
  void removeTypeChangeListener(ValueChanged<DksnCalendarType> listener) {
    _typeChangeListeners.remove(listener);
  }

  /// Notifies all type change listeners about the new type.
  void _notifyTypeChangeListeners() {
    for (final listener in _typeChangeListeners) {
      listener(_type);
    }
  }

  /// Adds a listener for selected date changes.
  /// 
  /// The [listener] will be called whenever the selected date changes.
  /// The listener receives the new [DateTime] as a parameter.
  void addSelectedDateChangeListener(ValueChanged<DateTime> listener) {
    _selectedDateChangeListeners.add(listener);
  }

  /// Removes a previously added selected date change listener.
  /// 
  /// The [listener] must be the same instance that was added via [addSelectedDateChangeListener].
  void removeSelectedDateChangeListener(ValueChanged<DateTime> listener) {
    _selectedDateChangeListeners.remove(listener);
  }

  /// Notifies all selected date change listeners about the new selected date.
  void _notifySelectedDateChangeListeners() {
    for (final listener in _selectedDateChangeListeners) {
      listener(_selectedDate);
    }
  }

  /// Handles date selection and automatic navigation.
  /// 
  /// When a date is selected:
  /// - Updates the current date
  /// - Automatically navigates to next/previous month if the selected date
  ///   is from a different month (only in monthly view)
  /// - Notifies all listeners
  /// 
  /// The [date] parameter is the newly selected date.
  void currentDateSelected(DateTime date) {
    _currentDate = date;

    if (_selectedDate.isNextMonth(date) && _type == DksnCalendarType.monthly) {
      next();
    }

    if (_selectedDate.isPreviousMonth(date) &&
        _type == DksnCalendarType.monthly) {
      previous();
    }

    /// if the selectedDate month is higher then next

    notifyListeners();
  }

  /// Changes the calendar view type.
  /// 
  /// Switches between [DksnCalendarType.monthly] and [DksnCalendarType.weekly].
  /// Only notifies listeners if the type actually changes.
  /// 
  /// The [type] parameter specifies the new calendar view type.
  void setType(DksnCalendarType type) {
    if (_type != type) {
      _type = type;
      _notifyTypeChangeListeners();
      notifyListeners();
    }
  }

  /// Sets the selected date used for navigation.
  /// 
  /// This date determines which month or week is displayed in the calendar.
  /// Only notifies listeners if the date actually changes.
  /// 
  /// The [date] parameter is the new selected date.
  void setSelectedDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      _notifySelectedDateChangeListeners();
      notifyListeners();
    }
  }

  /// Navigates to the next month or week.
  /// 
  /// In monthly view: moves to the next month.
  /// In weekly view: moves to the next week (7 days forward).
  /// 
  /// Automatically notifies all listeners of the change.
  void next() {
    if (_type == DksnCalendarType.monthly) {
      _selectedDate = DateTime(
          _selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
    } else {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
    }
    _notifySelectedDateChangeListeners();
    notifyListeners();
  }

  /// Navigates to the previous month or week.
  /// 
  /// In monthly view: moves to the previous month.
  /// In weekly view: moves to the previous week (7 days backward).
  /// 
  /// Automatically notifies all listeners of the change.
  void previous() {
    if (_type == DksnCalendarType.monthly) {
      _selectedDate = DateTime(
          _selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
    } else {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    }
    _notifySelectedDateChangeListeners();
    notifyListeners();
  }

  @override
  void dispose() {
    _typeChangeListeners.clear();
    _selectedDateChangeListeners.clear();
    super.dispose();
  }
}
