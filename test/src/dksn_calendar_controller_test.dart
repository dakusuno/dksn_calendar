// ignore_for_file: prefer_const_constructors

import 'package:dksn_calendar/dksn_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DksnCalendarController Tests', () {
    late DksnCalendarController controller;

    setUp(() {
      controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 6),
        DateTime(2025, 9, 6),
      );
    });

    test('initializes with correct default values', () {
      final defaultController = DksnCalendarController();
      
      expect(defaultController.type, DksnCalendarType.monthly);
      expect(defaultController.selectedDate, isA<DateTime>());
      expect(defaultController.currentDate, isA<DateTime>());
    });

    test('initializes with provided values', () {
      final testDate = DateTime(2025, 8, 15);
      final testCurrentDate = DateTime(2025, 8, 20);
      
      final customController = DksnCalendarController(
        DksnCalendarType.weekly,
        testDate,
        testCurrentDate,
      );

      expect(customController.type, DksnCalendarType.weekly);
      expect(customController.selectedDate, testDate);
      expect(customController.currentDate, testCurrentDate);
    });

    group('Type Management', () {
      test('setType changes calendar type and notifies listeners', () {
        bool listenerCalled = false;
        controller.addListener(() {
          listenerCalled = true;
        });

        expect(controller.type, DksnCalendarType.monthly);
        
        controller.setType(DksnCalendarType.weekly);
        
        expect(controller.type, DksnCalendarType.weekly);
        expect(listenerCalled, isTrue);
      });

      test('setType does not notify listeners when type is same', () {
        bool listenerCalled = false;
        controller.addListener(() {
          listenerCalled = true;
        });

        controller.setType(DksnCalendarType.monthly); // Same as initial
        
        expect(listenerCalled, isFalse);
      });
    });

    group('Date Selection', () {
      test('setSelectedDate updates date and notifies listeners', () {
        bool listenerCalled = false;
        final newDate = DateTime(2025, 10, 15);
        
        controller.addListener(() {
          listenerCalled = true;
        });

        controller.setSelectedDate(newDate);
        
        expect(controller.selectedDate, newDate);
        expect(listenerCalled, isTrue);
      });

      test('setSelectedDate does not notify when date is same', () {
        bool listenerCalled = false;
        controller.addListener(() {
          listenerCalled = true;
        });

        controller.setSelectedDate(controller.selectedDate); // Same date
        
        expect(listenerCalled, isFalse);
      });

      test('currentDateSelected updates current date and notifies listeners', () {
        bool listenerCalled = false;
        final newDate = DateTime(2025, 9, 15);
        
        controller.addListener(() {
          listenerCalled = true;
        });

        controller.currentDateSelected(newDate);
        
        expect(controller.currentDate, newDate);
        expect(listenerCalled, isTrue);
      });

      test('currentDateSelected navigates to next month when date is in next month', () {
        final septemberDate = DateTime(2025, 9, 15);
        final octoberDate = DateTime(2025, 10, 5);
        
        controller.setSelectedDate(septemberDate);
        controller.currentDateSelected(octoberDate);
        
        expect(controller.selectedDate.month, 10); // Should navigate to October
        expect(controller.currentDate, octoberDate);
      });

      test('currentDateSelected navigates to previous month when date is in previous month', () {
        final septemberDate = DateTime(2025, 9, 15);
        final augustDate = DateTime(2025, 8, 25);
        
        controller.setSelectedDate(septemberDate);
        controller.currentDateSelected(augustDate);
        
        expect(controller.selectedDate.month, 8); // Should navigate to August
        expect(controller.currentDate, augustDate);
      });

      test('currentDateSelected does not auto-navigate in weekly view', () {
        controller.setType(DksnCalendarType.weekly);
        final initialDate = DateTime(2025, 9, 15);
        final nextMonthDate = DateTime(2025, 10, 5);
        
        controller.setSelectedDate(initialDate);
        controller.currentDateSelected(nextMonthDate);
        
        expect(controller.selectedDate.month, 9); // Should stay in September
        expect(controller.currentDate, nextMonthDate);
      });
    });

    group('Navigation', () {
      test('next() moves to next month in monthly view', () {
        bool listenerCalled = false;
        controller.addListener(() {
          listenerCalled = true;
        });

        final initialMonth = controller.selectedDate.month;
        controller.next();
        
        expect(controller.selectedDate.month, initialMonth + 1);
        expect(listenerCalled, isTrue);
      });

      test('next() moves to next week in weekly view', () {
        controller.setType(DksnCalendarType.weekly);
        bool listenerCalled = false;
        controller.addListener(() {
          listenerCalled = true;
        });

        final initialDate = controller.selectedDate;
        controller.next();
        
        final expectedDate = initialDate.add(Duration(days: 7));
        expect(controller.selectedDate, expectedDate);
        expect(listenerCalled, isTrue);
      });

      test('previous() moves to previous month in monthly view', () {
        bool listenerCalled = false;
        controller.addListener(() {
          listenerCalled = true;
        });

        final initialMonth = controller.selectedDate.month;
        controller.previous();
        
        expect(controller.selectedDate.month, initialMonth - 1);
        expect(listenerCalled, isTrue);
      });

      test('previous() moves to previous week in weekly view', () {
        controller.setType(DksnCalendarType.weekly);
        bool listenerCalled = false;
        controller.addListener(() {
          listenerCalled = true;
        });

        final initialDate = controller.selectedDate;
        controller.previous();
        
        final expectedDate = initialDate.subtract(Duration(days: 7));
        expect(controller.selectedDate, expectedDate);
        expect(listenerCalled, isTrue);
      });

      test('navigation handles year boundaries correctly', () {
        // Test December to January
        controller.setSelectedDate(DateTime(2025, 12, 15));
        controller.next();
        
        expect(controller.selectedDate.year, 2026);
        expect(controller.selectedDate.month, 1);

        // Test January to December
        controller.setSelectedDate(DateTime(2025, 1, 15));
        controller.previous();
        
        expect(controller.selectedDate.year, 2024);
        expect(controller.selectedDate.month, 12);
      });
    });

    group('Listener Management', () {
      test('listeners are properly notified', () {
        int callCount = 0;
        controller.addListener(() {
          callCount++;
        });

        controller.next();
        controller.previous();
        controller.setType(DksnCalendarType.weekly);
        
        expect(callCount, 3);
      });

      test('removed listeners are not called', () {
        int callCount = 0;
        void listener() {
          callCount++;
        }
        
        controller.addListener(listener);
        controller.next();
        expect(callCount, 1);
        
        controller.removeListener(listener);
        controller.next();
        expect(callCount, 1); // Should not increment
      });
    });
  });
}
