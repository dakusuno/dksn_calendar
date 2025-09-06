// ignore_for_file: prefer_const_constructors

import 'package:dksn_calendar/src/dksn_calendar_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExtensionDateTime Tests', () {
    group('startOfMonth', () {
      test('returns first day of month at midnight', () {
        final date = DateTime(2025, 9, 15, 14, 30, 45);
        final startOfMonth = date.startOfMonth;
        
        expect(startOfMonth.year, 2025);
        expect(startOfMonth.month, 9);
        expect(startOfMonth.day, 1);
        expect(startOfMonth.hour, 0);
        expect(startOfMonth.minute, 0);
        expect(startOfMonth.second, 0);
        expect(startOfMonth.millisecond, 0);
      });

      test('works for different months', () {
        final january = DateTime(2025, 1, 15).startOfMonth;
        final december = DateTime(2025, 12, 31).startOfMonth;
        
        expect(january, DateTime(2025, 1, 1));
        expect(december, DateTime(2025, 12, 1));
      });

      test('works for leap year February', () {
        final leapYear = DateTime(2024, 2, 29).startOfMonth;
        expect(leapYear, DateTime(2024, 2, 1));
      });
    });

    group('nextDay', () {
      test('returns next day correctly', () {
        final date = DateTime(2025, 9, 15, 10, 30);
        final nextDay = date.nextDay;
        
        expect(nextDay.year, 2025);
        expect(nextDay.month, 9);
        expect(nextDay.day, 16);
        expect(nextDay.hour, 10);
        expect(nextDay.minute, 30);
      });

      test('handles month boundaries', () {
        final endOfMonth = DateTime(2025, 8, 31).nextDay;
        expect(endOfMonth.month, 9);
        expect(endOfMonth.day, 1);
      });

      test('handles year boundaries', () {
        final endOfYear = DateTime(2025, 12, 31).nextDay;
        expect(endOfYear.year, 2026);
        expect(endOfYear.month, 1);
        expect(endOfYear.day, 1);
      });

      test('handles leap year', () {
        final feb28LeapYear = DateTime(2024, 2, 28).nextDay;
        expect(feb28LeapYear.day, 29);
        
        final feb29LeapYear = DateTime(2024, 2, 29).nextDay;
        expect(feb29LeapYear.month, 3);
        expect(feb29LeapYear.day, 1);
      });
    });

    group('startOfWeek', () {
      test('returns Sunday for any day of the week', () {
        // Test each day of the week (September 2025)
        final monday = DateTime(2025, 9, 1);    // Monday
        final tuesday = DateTime(2025, 9, 2);   // Tuesday  
        final wednesday = DateTime(2025, 9, 3); // Wednesday
        final thursday = DateTime(2025, 9, 4);  // Thursday
        final friday = DateTime(2025, 9, 5);    // Friday
        final saturday = DateTime(2025, 9, 6);  // Saturday
        final sunday = DateTime(2025, 9, 7);    // Sunday
        
        final expectedSunday = DateTime(2025, 8, 31); // Previous Sunday
        
        expect(monday.startOfWeek, expectedSunday);
        expect(tuesday.startOfWeek, expectedSunday);
        expect(wednesday.startOfWeek, expectedSunday);
        expect(thursday.startOfWeek, expectedSunday);
        expect(friday.startOfWeek, expectedSunday);
        expect(saturday.startOfWeek, expectedSunday);
        expect(sunday.startOfWeek, sunday); // Sunday is start of its own week
      });

      test('preserves time components', () {
        final date = DateTime(2025, 9, 3, 15, 30, 45); // Wednesday
        final startOfWeek = date.startOfWeek;
        
        expect(startOfWeek.hour, 15);
        expect(startOfWeek.minute, 30);
        expect(startOfWeek.second, 45);
      });

      test('handles week boundaries across months', () {
        final date = DateTime(2025, 9, 1); // Monday, Sept 1
        final startOfWeek = date.startOfWeek;
        
        expect(startOfWeek.month, 8); // Should be in August
        expect(startOfWeek.day, 31);  // August 31, 2025 was a Sunday
      });
    });

    group('isNextMonth', () {
      test('returns true when date is in next month', () {
        final august = DateTime(2025, 8, 15);
        final september = DateTime(2025, 9, 10);
        
        expect(august.isNextMonth(september), isTrue);
      });

      test('returns false when date is in same month', () {
        final august15 = DateTime(2025, 8, 15);
        final august20 = DateTime(2025, 8, 20);
        
        expect(august15.isNextMonth(august20), isFalse);
      });

      test('returns false when date is in previous month', () {
        final august = DateTime(2025, 8, 15);
        final july = DateTime(2025, 7, 20);
        
        expect(august.isNextMonth(july), isFalse);
      });

      test('returns false when date is two months ahead', () {
        final august = DateTime(2025, 8, 15);
        final october = DateTime(2025, 10, 5);
        
        expect(august.isNextMonth(october), isFalse);
      });

      test('handles year transitions (December to January)', () {
        final december = DateTime(2025, 12, 15);
        final january = DateTime(2026, 1, 10);
        
        expect(december.isNextMonth(january), isTrue);
      });

      test('returns false for January to December (wrong direction)', () {
        final january = DateTime(2025, 1, 15);
        final december = DateTime(2024, 12, 10);
        
        expect(january.isNextMonth(december), isFalse);
      });

      test('handles different years correctly', () {
        final december2025 = DateTime(2025, 12, 15);
        final january2027 = DateTime(2027, 1, 10); // Skip a year
        
        expect(december2025.isNextMonth(january2027), isFalse);
      });
    });

    group('isPreviousMonth', () {
      test('returns true when date is in previous month', () {
        final september = DateTime(2025, 9, 15);
        final august = DateTime(2025, 8, 20);
        
        expect(september.isPreviousMonth(august), isTrue);
      });

      test('returns false when date is in same month', () {
        final september15 = DateTime(2025, 9, 15);
        final september20 = DateTime(2025, 9, 20);
        
        expect(september15.isPreviousMonth(september20), isFalse);
      });

      test('returns false when date is in next month', () {
        final august = DateTime(2025, 8, 15);
        final september = DateTime(2025, 9, 10);
        
        expect(august.isPreviousMonth(september), isFalse);
      });

      test('returns false when date is two months before', () {
        final september = DateTime(2025, 9, 15);
        final july = DateTime(2025, 7, 20);
        
        expect(september.isPreviousMonth(july), isFalse);
      });

      test('handles year transitions (January to December)', () {
        final january = DateTime(2025, 1, 15);
        final december = DateTime(2024, 12, 20);
        
        expect(january.isPreviousMonth(december), isTrue);
      });

      test('returns false for December to January (wrong direction)', () {
        final december = DateTime(2025, 12, 15);
        final january = DateTime(2026, 1, 10);
        
        expect(december.isPreviousMonth(january), isFalse);
      });

      test('handles different years correctly', () {
        final january2025 = DateTime(2025, 1, 15);
        final december2022 = DateTime(2022, 12, 10); // Skip years
        
        expect(january2025.isPreviousMonth(december2022), isFalse);
      });
    });

    group('Edge Cases', () {
      test('handles leap year edge cases', () {
        final leapYearFeb = DateTime(2024, 2, 29);
        
        expect(leapYearFeb.nextDay.month, 3);
        expect(leapYearFeb.nextDay.day, 1);
        expect(leapYearFeb.startOfMonth, DateTime(2024, 2, 1));
      });

      test('handles daylight saving time transitions', () {
        // Note: This test assumes UTC or a timezone without DST
        final beforeDST = DateTime(2025, 3, 8, 12, 0);
        final nextDay = beforeDST.nextDay;
        
        expect(nextDay.day, 9);
        expect(nextDay.hour, 12); // Should preserve hour
      });

      test('handles very early dates', () {
        final earlyDate = DateTime(1900, 1, 1);
        
        expect(earlyDate.startOfMonth, DateTime(1900, 1, 1));
        expect(earlyDate.nextDay, DateTime(1900, 1, 2));
      });

      test('handles very late dates', () {
        final lateDate = DateTime(2100, 12, 31);
        
        expect(lateDate.nextDay.year, 2101);
        expect(lateDate.nextDay.month, 1);
        expect(lateDate.nextDay.day, 1);
      });
    });
  });
}
