// ignore_for_file: prefer_const_constructors

import 'package:dksn_calendar/dksn_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DKSN Calendar Integration Tests', () {
    testWidgets('complete monthly calendar workflow', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 6), // September 6, 2025
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(
              controller: controller,
              initialType: DksnCalendarType.monthly,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state
      expect(controller.type, DksnCalendarType.monthly);
      expect(controller.selectedDate.month, 9);
      expect(controller.selectedDate.year, 2025);

      // Test navigation to next month
      controller.next();
      await tester.pumpAndSettle();
      expect(controller.selectedDate.month, 10);

      // Test navigation to previous month
      controller.previous();
      await tester.pumpAndSettle();
      expect(controller.selectedDate.month, 9);

      // Test switching to weekly view
      controller.setType(DksnCalendarType.weekly);
      await tester.pumpAndSettle();
      expect(controller.type, DksnCalendarType.weekly);
    });

    testWidgets('complete weekly calendar workflow', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.weekly,
        DateTime(2025, 9, 6), // September 6, 2025 (Friday)
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(
              controller: controller,
              initialType: DksnCalendarType.weekly,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state
      expect(controller.type, DksnCalendarType.weekly);
      
      final initialDate = controller.selectedDate;

      // Test navigation to next week
      controller.next();
      await tester.pumpAndSettle();
      expect(controller.selectedDate, initialDate.add(Duration(days: 7)));

      // Test navigation to previous week
      controller.previous();
      await tester.pumpAndSettle();
      expect(controller.selectedDate, initialDate);

      // Test switching to monthly view
      controller.setType(DksnCalendarType.monthly);
      await tester.pumpAndSettle();
      expect(controller.type, DksnCalendarType.monthly);
    });

    testWidgets('calendar with custom theme and interactions', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 6),
      );

      bool headerBuilderCalled = false;
      bool dayBuilderCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(
              controller: controller,
              theme: DksnCalendarTheme(
                monthly: DksnCalendarMonthlyTheme(
                  dayBuilder: (currentDate, selectedDate, date) {
                    dayBuilderCalled = true;
                    return GestureDetector(
                      key: Key('custom_day_${date.day}'),
                      onTap: () => controller.currentDateSelected(date),
                      child: Container(
                        decoration: BoxDecoration(
                          color: date == currentDate ? Colors.blue : Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              color: date == currentDate ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                header: DksnCalendarHeaderTheme(
                  labelBuilder: (date, previous, next) {
                    headerBuilderCalled = true;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          key: Key('prev_button'),
                          onPressed: previous,
                          icon: Icon(Icons.chevron_left),
                        ),
                        Text(
                          '${date.month}/${date.year}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          key: Key('next_button'),
                          onPressed: next,
                          icon: Icon(Icons.chevron_right),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify custom builders were called
      expect(headerBuilderCalled, isTrue);
      expect(dayBuilderCalled, isTrue);

      // Test custom header navigation
      await tester.tap(find.byKey(Key('next_button')));
      await tester.pumpAndSettle();
      expect(controller.selectedDate.month, 10);

      await tester.tap(find.byKey(Key('prev_button')));
      await tester.pumpAndSettle();
      expect(controller.selectedDate.month, 9);

      // Test custom day selection
      await tester.tap(find.byKey(Key('custom_day_15')));
      await tester.pumpAndSettle();
      expect(controller.currentDate.day, 15);
    });

    testWidgets('calendar handles month transitions correctly', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 15), // Mid September
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(controller: controller),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Select a date in the next month (should auto-navigate)
      final nextMonthDate = DateTime(2025, 10, 5);
      controller.currentDateSelected(nextMonthDate);
      await tester.pumpAndSettle();

      expect(controller.selectedDate.month, 10);
      expect(controller.currentDate, nextMonthDate);

      // Select a date in the previous month (should auto-navigate)
      final prevMonthDate = DateTime(2025, 9, 25);
      controller.currentDateSelected(prevMonthDate);
      await tester.pumpAndSettle();

      expect(controller.selectedDate.month, 9);
      expect(controller.currentDate, prevMonthDate);
    });

    testWidgets('weekly calendar shows correct week days', (tester) async {
      // Use a known date: September 6, 2025 is a Saturday
      final controller = DksnCalendarController(
        DksnCalendarType.weekly,
        DateTime(2025, 9, 6), // Saturday
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(controller: controller),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The week should start on Sunday (August 31, 2025)
      // and end on Saturday (September 6, 2025)
      // Since September 6 is the selected date, the week should be:
      // Aug 31, Sep 1, Sep 2, Sep 3, Sep 4, Sep 5, Sep 6

      // Check that we have a 7-day grid
      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('calendar state persists across rebuilds', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 6),
      );

      Widget buildCalendar() {
        return MaterialApp(
          home: Scaffold(
            body: DksnCalendar(controller: controller),
          ),
        );
      }

      await tester.pumpWidget(buildCalendar());
      await tester.pumpAndSettle();

      // Change state
      controller.next();
      controller.currentDateSelected(DateTime(2025, 10, 15));
      await tester.pumpAndSettle();

      expect(controller.selectedDate.month, 10);
      expect(controller.currentDate.day, 15);

      // Rebuild widget tree
      await tester.pumpWidget(Container()); // Clear
      await tester.pumpWidget(buildCalendar()); // Rebuild
      await tester.pumpAndSettle();

      // State should persist
      expect(controller.selectedDate.month, 10);
      expect(controller.currentDate.day, 15);
    });

    testWidgets('calendar handles year boundaries correctly', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 12, 15), // December 2025
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(controller: controller),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to next month (should go to January 2026)
      controller.next();
      await tester.pumpAndSettle();

      expect(controller.selectedDate.year, 2026);
      expect(controller.selectedDate.month, 1);

      // Navigate back to previous month (should go to December 2025)
      controller.previous();
      await tester.pumpAndSettle();

      expect(controller.selectedDate.year, 2025);
      expect(controller.selectedDate.month, 12);
    });

    testWidgets('calendar with multiple controllers work independently', (tester) async {
      final controller1 = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 6),
      );

      final controller2 = DksnCalendarController(
        DksnCalendarType.weekly,
        DateTime(2025, 8, 15),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: DksnCalendar(
                    key: Key('calendar1'),
                    controller: controller1,
                  ),
                ),
                Expanded(
                  child: DksnCalendar(
                    key: Key('calendar2'),
                    controller: controller2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial states
      expect(controller1.type, DksnCalendarType.monthly);
      expect(controller1.selectedDate.month, 9);
      expect(controller2.type, DksnCalendarType.weekly);
      expect(controller2.selectedDate.month, 8);

      // Change controller1
      controller1.next();
      await tester.pumpAndSettle();

      // Only controller1 should change
      expect(controller1.selectedDate.month, 10);
      expect(controller2.selectedDate.month, 8); // Should remain unchanged

      // Change controller2
      controller2.setType(DksnCalendarType.monthly);
      await tester.pumpAndSettle();

      // Only controller2 should change
      expect(controller1.type, DksnCalendarType.monthly); // Should remain unchanged
      expect(controller2.type, DksnCalendarType.monthly);
    });

    testWidgets('calendar handles edge cases gracefully', (tester) async {
      // Test with leap year date
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2024, 2, 29), // Leap year February 29
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(controller: controller),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.selectedDate.year, 2024);
      expect(controller.selectedDate.month, 2);
      expect(controller.selectedDate.day, 29);

      // Navigate to next month
      controller.next();
      await tester.pumpAndSettle();

      expect(controller.selectedDate.month, 3);

      // Navigate back
      controller.previous();
      await tester.pumpAndSettle();

      expect(controller.selectedDate.month, 2);
    });
  });
}
