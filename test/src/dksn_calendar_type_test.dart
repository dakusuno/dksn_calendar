// ignore_for_file: prefer_const_constructors

import 'package:dksn_calendar/src/dksn_calendar_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DksnCalendarType Tests', () {
    test('has correct enum values', () {
      expect(DksnCalendarType.values.length, 2);
      expect(DksnCalendarType.values.contains(DksnCalendarType.weekly), isTrue);
      expect(DksnCalendarType.values.contains(DksnCalendarType.monthly), isTrue);
    });

    test('enum values have correct names', () {
      expect(DksnCalendarType.weekly.name, 'weekly');
      expect(DksnCalendarType.monthly.name, 'monthly');
    });

    test('enum values can be compared', () {
      expect(DksnCalendarType.weekly == DksnCalendarType.weekly, isTrue);
      expect(DksnCalendarType.monthly == DksnCalendarType.monthly, isTrue);
      expect(DksnCalendarType.weekly == DksnCalendarType.monthly, isFalse);
    });

    test('enum values can be used in switch statements', () {
      String getTypeDescription(DksnCalendarType type) {
        return switch (type) {
          DksnCalendarType.weekly => 'Shows 7 days',
          DksnCalendarType.monthly => 'Shows full month',
        };
      }

      expect(getTypeDescription(DksnCalendarType.weekly), 'Shows 7 days');
      expect(getTypeDescription(DksnCalendarType.monthly), 'Shows full month');
    });
  });

  group('DksnCalendarDateType Tests', () {
    test('has correct number of days', () {
      expect(DksnCalendarDateType.values.length, 7);
    });

    test('contains all days of the week', () {
      final days = DksnCalendarDateType.values;
      expect(days.contains(DksnCalendarDateType.sunday), isTrue);
      expect(days.contains(DksnCalendarDateType.monday), isTrue);
      expect(days.contains(DksnCalendarDateType.tuesday), isTrue);
      expect(days.contains(DksnCalendarDateType.wednesday), isTrue);
      expect(days.contains(DksnCalendarDateType.thursday), isTrue);
      expect(days.contains(DksnCalendarDateType.friday), isTrue);
      expect(days.contains(DksnCalendarDateType.saturday), isTrue);
    });

    test('days have correct labels', () {
      expect(DksnCalendarDateType.sunday.labelDate, 'Sun');
      expect(DksnCalendarDateType.monday.labelDate, 'Mon');
      expect(DksnCalendarDateType.tuesday.labelDate, 'Tue');
      expect(DksnCalendarDateType.wednesday.labelDate, 'Wed');
      expect(DksnCalendarDateType.thursday.labelDate, 'Thu');
      expect(DksnCalendarDateType.friday.labelDate, 'Fri');
      expect(DksnCalendarDateType.saturday.labelDate, 'Sat');
    });

    test('days are in correct order (Sunday first)', () {
      final days = DksnCalendarDateType.values;
      expect(days[0], DksnCalendarDateType.sunday);
      expect(days[1], DksnCalendarDateType.monday);
      expect(days[2], DksnCalendarDateType.tuesday);
      expect(days[3], DksnCalendarDateType.wednesday);
      expect(days[4], DksnCalendarDateType.thursday);
      expect(days[5], DksnCalendarDateType.friday);
      expect(days[6], DksnCalendarDateType.saturday);
    });

    test('enum values have correct names', () {
      expect(DksnCalendarDateType.sunday.name, 'sunday');
      expect(DksnCalendarDateType.monday.name, 'monday');
      expect(DksnCalendarDateType.tuesday.name, 'tuesday');
      expect(DksnCalendarDateType.wednesday.name, 'wednesday');
      expect(DksnCalendarDateType.thursday.name, 'thursday');
      expect(DksnCalendarDateType.friday.name, 'friday');
      expect(DksnCalendarDateType.saturday.name, 'saturday');
    });

    test('can be used to generate day headers', () {
      final headers = DksnCalendarDateType.values
          .map((day) => day.labelDate)
          .toList();
      
      expect(headers, ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']);
    });

    test('labelDate property is accessible', () {
      for (final day in DksnCalendarDateType.values) {
        expect(day.labelDate, isA<String>());
        expect(day.labelDate.isNotEmpty, isTrue);
        expect(day.labelDate.length, 3); // All labels are 3 characters
      }
    });

    test('can be used in switch statements', () {
      String getDayDescription(DksnCalendarDateType day) {
        return switch (day) {
          DksnCalendarDateType.sunday => 'Weekend start',
          DksnCalendarDateType.monday => 'Work week start',
          DksnCalendarDateType.tuesday => 'Tuesday',
          DksnCalendarDateType.wednesday => 'Hump day',
          DksnCalendarDateType.thursday => 'Thursday',
          DksnCalendarDateType.friday => 'TGIF',
          DksnCalendarDateType.saturday => 'Weekend',
        };
      }

      expect(getDayDescription(DksnCalendarDateType.sunday), 'Weekend start');
      expect(getDayDescription(DksnCalendarDateType.friday), 'TGIF');
    });

    test('equality works correctly', () {
      expect(DksnCalendarDateType.monday == DksnCalendarDateType.monday, isTrue);
      expect(DksnCalendarDateType.monday == DksnCalendarDateType.tuesday, isFalse);
    });

    test('can be used as map keys', () {
      final dayMap = <DksnCalendarDateType, String>{
        DksnCalendarDateType.monday: 'Start of work week',
        DksnCalendarDateType.friday: 'End of work week',
      };

      expect(dayMap[DksnCalendarDateType.monday], 'Start of work week');
      expect(dayMap[DksnCalendarDateType.friday], 'End of work week');
      expect(dayMap[DksnCalendarDateType.sunday], isNull);
    });
  });

  group('Integration Tests', () {
    test('DksnCalendarDateType can be used to create week structures', () {
      final weekDays = DksnCalendarDateType.values;
      final weekStructure = <String, bool>{};
      
      for (final day in weekDays) {
        final isWeekend = day == DksnCalendarDateType.saturday || 
                         day == DksnCalendarDateType.sunday;
        weekStructure[day.labelDate] = isWeekend;
      }

      expect(weekStructure['Sun'], isTrue);  // Weekend
      expect(weekStructure['Mon'], isFalse); // Weekday
      expect(weekStructure['Fri'], isFalse); // Weekday
      expect(weekStructure['Sat'], isTrue);  // Weekend
    });

    test('calendar types and date types work together', () {
      bool shouldShowAllDays(DksnCalendarType type) {
        return switch (type) {
          DksnCalendarType.weekly => true,  // Show all 7 days
          DksnCalendarType.monthly => true, // Show all 7 day headers
        };
      }

      for (final type in DksnCalendarType.values) {
        expect(shouldShowAllDays(type), isTrue);
      }

      // Both calendar types should show all 7 days
      expect(DksnCalendarDateType.values.length, 7);
    });
  });
}
