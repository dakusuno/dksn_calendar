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

    group('Type Change Listeners', () {
      test('addTypeChangeListener and removeTypeChangeListener work correctly', () {
        DksnCalendarType? receivedType;
        int callCount = 0;

        void typeListener(DksnCalendarType type) {
          receivedType = type;
          callCount++;
        }

        // Add listener
        controller.addTypeChangeListener(typeListener);

        // Change type should trigger listener
        controller.setType(DksnCalendarType.weekly);
        expect(callCount, 1);
        expect(receivedType, DksnCalendarType.weekly);

        // Change to same type should not trigger listener
        controller.setType(DksnCalendarType.weekly);
        expect(callCount, 1); // Should not increment

        // Change to different type should trigger listener again
        controller.setType(DksnCalendarType.monthly);
        expect(callCount, 2);
        expect(receivedType, DksnCalendarType.monthly);

        // Remove listener
        controller.removeTypeChangeListener(typeListener);

        // Change type should not trigger listener anymore
        controller.setType(DksnCalendarType.weekly);
        expect(callCount, 2); // Should not increment
      });

      test('multiple type change listeners work correctly', () {
        final receivedTypes = <DksnCalendarType>[];
        int callCount1 = 0, callCount2 = 0;

        void listener1(DksnCalendarType type) {
          receivedTypes.add(type);
          callCount1++;
        }

        void listener2(DksnCalendarType type) {
          callCount2++;
        }

        // Add both listeners
        controller.addTypeChangeListener(listener1);
        controller.addTypeChangeListener(listener2);

        // Change type should trigger both listeners
        controller.setType(DksnCalendarType.weekly);
        expect(callCount1, 1);
        expect(callCount2, 1);
        expect(receivedTypes.last, DksnCalendarType.weekly);

        // Remove one listener
        controller.removeTypeChangeListener(listener1);

        // Change type should only trigger remaining listener
        controller.setType(DksnCalendarType.monthly);
        expect(callCount1, 1); // Should not increment
        expect(callCount2, 2);
      });

      test('dispose clears type change listeners', () {
        int callCount = 0;
        
        void typeListener(DksnCalendarType type) {
          callCount++;
        }

        controller.addTypeChangeListener(typeListener);
        controller.setType(DksnCalendarType.weekly);
        expect(callCount, 1);

        // Create new controller to test dispose behavior
        final newController = DksnCalendarController();
        newController.addTypeChangeListener(typeListener);
        
        // Change type before dispose to verify listener works
        newController.setType(DksnCalendarType.weekly);
        expect(callCount, 2);
        
        // Dispose should clear listeners and make controller unusable
        newController.dispose();
        
        // Trying to use disposed controller should throw
        expect(() => newController.setType(DksnCalendarType.monthly), throwsFlutterError);
      });
    });

    group('Selected Date Change Listeners', () {
      test('addSelectedDateChangeListener and removeSelectedDateChangeListener work correctly', () {
        DateTime? receivedDate;
        int callCount = 0;

        void dateListener(DateTime date) {
          receivedDate = date;
          callCount++;
        }

        // Add listener
        controller.addSelectedDateChangeListener(dateListener);

        // Change selected date should trigger listener
        final newDate = DateTime(2025, 10, 15);
        controller.setSelectedDate(newDate);
        expect(callCount, 1);
        expect(receivedDate, newDate);

        // Set to same date should not trigger listener
        controller.setSelectedDate(newDate);
        expect(callCount, 1); // Should not increment

        // Change to different date should trigger listener again
        final anotherDate = DateTime(2025, 11, 20);
        controller.setSelectedDate(anotherDate);
        expect(callCount, 2);
        expect(receivedDate, anotherDate);

        // Remove listener
        controller.removeSelectedDateChangeListener(dateListener);

        // Change date should not trigger listener anymore
        controller.setSelectedDate(DateTime(2025, 12, 25));
        expect(callCount, 2); // Should not increment
      });

      test('selected date change listener triggered by next() and previous()', () {
        final receivedDates = <DateTime>[];
        
        void dateListener(DateTime date) {
          receivedDates.add(date);
        }

        controller.addSelectedDateChangeListener(dateListener);

        // Test next() method
        controller.next();
        expect(receivedDates.length, 1);

        // Test previous() method
        controller.previous();
        expect(receivedDates.length, 2);

        // Verify the dates are different
        expect(receivedDates[0] != receivedDates[1], true);
      });

      test('multiple selected date change listeners work correctly', () {
        final receivedDates1 = <DateTime>[];
        final receivedDates2 = <DateTime>[];
        int callCount1 = 0, callCount2 = 0;

        void listener1(DateTime date) {
          receivedDates1.add(date);
          callCount1++;
        }

        void listener2(DateTime date) {
          receivedDates2.add(date);
          callCount2++;
        }

        // Add both listeners
        controller.addSelectedDateChangeListener(listener1);
        controller.addSelectedDateChangeListener(listener2);

        // Change selected date should trigger both listeners
        final testDate = DateTime(2025, 12, 1);
        controller.setSelectedDate(testDate);
        expect(callCount1, 1);
        expect(callCount2, 1);
        expect(receivedDates1.last, testDate);
        expect(receivedDates2.last, testDate);

        // Remove one listener
        controller.removeSelectedDateChangeListener(listener1);

        // Change date should only trigger remaining listener
        final anotherDate = DateTime(2025, 12, 15);
        controller.setSelectedDate(anotherDate);
        expect(callCount1, 1); // Should not increment
        expect(callCount2, 2);
        expect(receivedDates2.last, anotherDate);
      });

      test('dispose clears selected date change listeners', () {
        int callCount = 0;
        
        void dateListener(DateTime date) {
          callCount++;
        }

        controller.addSelectedDateChangeListener(dateListener);
        controller.setSelectedDate(DateTime(2025, 10, 1));
        expect(callCount, 1);

        // Create new controller to test dispose behavior
        final newController = DksnCalendarController();
        newController.addSelectedDateChangeListener(dateListener);
        
        // Change date before dispose to verify listener works
        newController.setSelectedDate(DateTime(2025, 11, 1));
        expect(callCount, 2);
        
        // Dispose should clear listeners and make controller unusable
        newController.dispose();
        
        // Trying to use disposed controller should throw
        expect(() => newController.setSelectedDate(DateTime(2025, 12, 1)), throwsFlutterError);
      });

      test('selected date listener works with navigation methods', () {
        final receivedDates = <DateTime>[];
        
        void dateListener(DateTime date) {
          receivedDates.add(date);
        }

        controller.addSelectedDateChangeListener(dateListener);

        // Test next navigation
        controller.next();
        expect(receivedDates.length, 1);

        // Test previous navigation  
        controller.previous();
        expect(receivedDates.length, 2);

        // Verify dates are different
        expect(receivedDates[0], isNot(equals(receivedDates[1])));
      });
    });
  });
}
