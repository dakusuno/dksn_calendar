// ignore_for_file: prefer_const_constructors

import 'package:dksn_calendar/dksn_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DksnCalendar Widget Tests', () {
    testWidgets('can be instantiated with default parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(),
          ),
        ),
      );
      
      expect(find.byType(DksnCalendar), findsOneWidget);
    });

    testWidgets('displays with custom controller', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 6),
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

      expect(find.byType(DksnCalendar), findsOneWidget);
      expect(controller.type, DksnCalendarType.monthly);
      expect(controller.selectedDate.year, 2025);
      expect(controller.selectedDate.month, 9);
    });

    testWidgets('displays with weekly initial type', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.weekly,
        DateTime(2025, 9, 6),
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

      expect(find.byType(DksnCalendar), findsOneWidget);
      expect(controller.type, DksnCalendarType.weekly);
    });

    testWidgets('displays with custom theme', (tester) async {
      bool dayBuilderCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(
              theme: DksnCalendarTheme(
                monthly: DksnCalendarMonthlyTheme(
                  dayBuilder: (currentDate, selectedDate, date) {
                    dayBuilderCalled = true;
                    return Container(
                      key: Key('custom_day_${date.day}'),
                      child: Text('${date.day}'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(dayBuilderCalled, isTrue);
    });

    testWidgets('switches between monthly and weekly views', (tester) async {
      final controller = DksnCalendarController(
        DksnCalendarType.monthly,
        DateTime(2025, 9, 6),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(controller: controller),
          ),
        ),
      );

      expect(controller.type, DksnCalendarType.monthly);

      // Switch to weekly view
      controller.setType(DksnCalendarType.weekly);
      await tester.pumpAndSettle();

      expect(controller.type, DksnCalendarType.weekly);
    });

    testWidgets('displays header with navigation controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Look for navigation elements in the header
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('uses custom header builder when provided', (tester) async {
      bool headerBuilderCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DksnCalendar(
              theme: DksnCalendarTheme(
                header: DksnCalendarHeaderTheme(
                  labelBuilder: (date, previous, next) {
                    headerBuilderCalled = true;
                    return Container(
                      key: Key('custom_header'),
                      child: Text('Custom Header'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(headerBuilderCalled, isTrue);
      expect(find.byKey(Key('custom_header')), findsOneWidget);
    });
  });
}
