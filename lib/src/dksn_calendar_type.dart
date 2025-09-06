/// Defines the view types supported by [DksnCalendar].
/// 
/// The calendar can display in two different modes:
/// - [weekly]: Shows a single week (7 days)
/// - [monthly]: Shows a full month with complete weeks
enum DksnCalendarType {
  /// Weekly view showing 7 days starting from Sunday.
  weekly,
  
  /// Monthly view showing a complete month with full weeks.
  monthly,
}

/// Represents the days of the week with their display labels.
/// 
/// Used for displaying day headers in the monthly calendar view.
/// The week starts with Sunday and ends with Saturday.
enum DksnCalendarDateType {
  /// Sunday
  sunday(labelDate: 'Sun'),
  
  /// Monday
  monday(labelDate: 'Mon'),
  
  /// Tuesday
  tuesday(labelDate: 'Tue'),
  
  /// Wednesday
  wednesday(labelDate: 'Wed'),
  
  /// Thursday
  thursday(labelDate: 'Thu'),
  
  /// Friday
  friday(labelDate: 'Fri'),
  
  /// Saturday
  saturday(labelDate: 'Sat');

  /// Creates a day type with its display label.
  const DksnCalendarDateType({
    required this.labelDate,
  });

  /// The abbreviated label for the day (e.g., 'Mon', 'Tue').
  final String labelDate;
}
