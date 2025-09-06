// ignore_for_file: prefer_const_constructors

import 'package:dksn_calendar/src/dksn_calendar_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DksnCalendarTheme Tests', () {
    test('can be instantiated with default values', () {
      final theme = DksnCalendarTheme();
      
      expect(theme.monthly, isA<DksnCalendarMonthlyTheme>());
      expect(theme.weekly, isA<DksnCalendarWeeklyTheme>());
      expect(theme.header, isA<DksnCalendarHeaderTheme>());
    });

    test('can be instantiated with custom values', () {
      final monthlyTheme = DksnCalendarMonthlyTheme(
        dayBuilder: (currentDate, selectedDate, date) => Container(),
      );
      final weeklyTheme = DksnCalendarWeeklyTheme(
        dayBuilder: (currentDate, selectedDate, date) => Container(),
      );
      final headerTheme = DksnCalendarHeaderTheme(
        labelStyle: TextStyle(fontSize: 18),
      );

      final theme = DksnCalendarTheme(
        monthly: monthlyTheme,
        weekly: weeklyTheme,
        header: headerTheme,
      );

      expect(theme.monthly, monthlyTheme);
      expect(theme.weekly, weeklyTheme);
      expect(theme.header, headerTheme);
    });

    test('provides access to all sub-themes', () {
      final theme = DksnCalendarTheme();
      
      expect(theme.monthly, isNotNull);
      expect(theme.weekly, isNotNull);
      expect(theme.header, isNotNull);
    });
  });

  group('DksnCalendarMonthlyTheme Tests', () {
    test('can be instantiated with default values', () {
      final theme = DksnCalendarMonthlyTheme();
      
      expect(theme.dayBuilder, isNull);
      expect(theme.onDateSelected, isNull);
    });

    test('can be instantiated with custom dayBuilder', () {
      Widget customDayBuilder(DateTime currentDate, DateTime selectedDate, DateTime date) {
        return Container(
          key: Key('custom_day_${date.day}'),
          child: Text('${date.day}'),
        );
      }

      final theme = DksnCalendarMonthlyTheme(
        dayBuilder: customDayBuilder,
      );

      expect(theme.dayBuilder, isNotNull);
      expect(theme.onDateSelected, isNull);

      // Test the dayBuilder function
      final testDate = DateTime(2025, 9, 15);
      final widget = theme.dayBuilder!(
        DateTime.now(),
        DateTime.now(),
        testDate,
      );
      
      expect(widget, isA<Container>());
    });

    test('can be instantiated with custom onDateSelected callback', () {
      DateTime? selectedDate;
      void onDateSelected(DateTime date) {
        selectedDate = date;
      }

      final theme = DksnCalendarMonthlyTheme(
        onDateSelected: onDateSelected,
      );

      expect(theme.dayBuilder, isNull);
      expect(theme.onDateSelected, isNotNull);

      // Test the callback
      final testDate = DateTime(2025, 9, 15);
      theme.onDateSelected!(testDate);
      expect(selectedDate, testDate);
    });

    test('can be instantiated with both dayBuilder and onDateSelected', () {
      bool dayBuilderCalled = false;
      bool callbackCalled = false;

      final theme = DksnCalendarMonthlyTheme(
        dayBuilder: (currentDate, selectedDate, date) {
          dayBuilderCalled = true;
          return Container();
        },
        onDateSelected: (date) {
          callbackCalled = true;
        },
      );

      expect(theme.dayBuilder, isNotNull);
      expect(theme.onDateSelected, isNotNull);

      // Test both
      theme.dayBuilder!(DateTime.now(), DateTime.now(), DateTime.now());
      theme.onDateSelected!(DateTime.now());

      expect(dayBuilderCalled, isTrue);
      expect(callbackCalled, isTrue);
    });
  });

  group('DksnCalendarWeeklyTheme Tests', () {
    test('can be instantiated with default values', () {
      final theme = DksnCalendarWeeklyTheme();
      
      expect(theme.dayBuilder, isNull);
      expect(theme.onDateSelected, isNull);
    });

    test('can be instantiated with custom dayBuilder', () {
      Widget customDayBuilder(DateTime currentDate, DateTime selectedDate, DateTime date) {
        return Container(
          key: Key('weekly_custom_day_${date.day}'),
          child: Text('${date.day}'),
        );
      }

      final theme = DksnCalendarWeeklyTheme(
        dayBuilder: customDayBuilder,
      );

      expect(theme.dayBuilder, isNotNull);
      expect(theme.onDateSelected, isNull);

      // Test the dayBuilder function
      final testDate = DateTime(2025, 9, 15);
      final widget = theme.dayBuilder!(
        DateTime.now(),
        DateTime.now(),
        testDate,
      );
      
      expect(widget, isA<Container>());
    });

    test('can be instantiated with custom onDateSelected callback', () {
      DateTime? selectedDate;
      void onDateSelected(DateTime date) {
        selectedDate = date;
      }

      final theme = DksnCalendarWeeklyTheme(
        onDateSelected: onDateSelected,
      );

      expect(theme.dayBuilder, isNull);
      expect(theme.onDateSelected, isNotNull);

      // Test the callback
      final testDate = DateTime(2025, 9, 15);
      theme.onDateSelected!(testDate);
      expect(selectedDate, testDate);
    });

    test('has same interface as monthly theme', () {
      final monthlyTheme = DksnCalendarMonthlyTheme();
      final weeklyTheme = DksnCalendarWeeklyTheme();

      // Both should have the same interface
      expect(monthlyTheme.dayBuilder.runtimeType, weeklyTheme.dayBuilder.runtimeType);
      expect(monthlyTheme.onDateSelected.runtimeType, weeklyTheme.onDateSelected.runtimeType);
    });
  });

  group('DksnCalendarHeaderTheme Tests', () {
    test('can be instantiated with default values', () {
      final theme = DksnCalendarHeaderTheme();
      
      expect(theme.leftIcon, isNull);
      expect(theme.rightIcon, isNull);
      expect(theme.label, isNull);
      expect(theme.labelStyle, isNull);
      expect(theme.labelBuilder, isNull);
    });

    test('can be instantiated with custom icons', () {
      final leftIcon = Icon(Icons.arrow_left);
      final rightIcon = Icon(Icons.arrow_right);

      final theme = DksnCalendarHeaderTheme(
        leftIcon: leftIcon,
        rightIcon: rightIcon,
      );

      expect(theme.leftIcon, leftIcon);
      expect(theme.rightIcon, rightIcon);
    });

    test('can be instantiated with custom label function', () {
      String customLabel(DateTime date) {
        return '${date.year}-${date.month.toString().padLeft(2, '0')}';
      }

      final theme = DksnCalendarHeaderTheme(
        label: customLabel,
      );

      expect(theme.label, isNotNull);

      // Test the label function
      final testDate = DateTime(2025, 9, 15);
      final label = theme.label!(testDate);
      expect(label, '2025-09');
    });

    test('can be instantiated with custom label style', () {
      final labelStyle = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      );

      final theme = DksnCalendarHeaderTheme(
        labelStyle: labelStyle,
      );

      expect(theme.labelStyle, labelStyle);
      expect(theme.labelStyle!.fontSize, 20);
      expect(theme.labelStyle!.fontWeight, FontWeight.bold);
      expect(theme.labelStyle!.color, Colors.blue);
    });

    test('can be instantiated with custom label builder', () {
      bool labelBuilderCalled = false;

      Widget customLabelBuilder(DateTime date, void Function() previous, void Function() next) {
        labelBuilderCalled = true;
        return Row(
          children: [
            GestureDetector(
              onTap: previous,
              child: Icon(Icons.chevron_left),
            ),
            Text('Custom: ${date.month}/${date.year}'),
            GestureDetector(
              onTap: next,
              child: Icon(Icons.chevron_right),
            ),
          ],
        );
      }

      final theme = DksnCalendarHeaderTheme(
        labelBuilder: customLabelBuilder,
      );

      expect(theme.labelBuilder, isNotNull);

      // Test the labelBuilder function
      final testDate = DateTime(2025, 9, 15);
      final widget = theme.labelBuilder!(
        testDate,
        () {}, // Empty callback for testing
        () {}, // Empty callback for testing
      );

      expect(labelBuilderCalled, isTrue);
      expect(widget, isA<Row>());
    });

    test('can be instantiated with all custom properties', () {
      final theme = DksnCalendarHeaderTheme(
        leftIcon: Icon(Icons.arrow_back),
        rightIcon: Icon(Icons.arrow_forward),
        label: (date) => 'Custom ${date.month}',
        labelStyle: TextStyle(fontSize: 16),
        labelBuilder: (date, prev, next) => Container(),
      );

      expect(theme.leftIcon, isA<Icon>());
      expect(theme.rightIcon, isA<Icon>());
      expect(theme.label, isNotNull);
      expect(theme.labelStyle, isNotNull);
      expect(theme.labelBuilder, isNotNull);
    });
  });

  group('Theme Integration Tests', () {
    test('themes can be used together in main theme', () {
      final monthlyTheme = DksnCalendarMonthlyTheme(
        dayBuilder: (current, selected, date) => Text('M${date.day}'),
      );

      final weeklyTheme = DksnCalendarWeeklyTheme(
        dayBuilder: (current, selected, date) => Text('W${date.day}'),
      );

      final headerTheme = DksnCalendarHeaderTheme(
        labelStyle: TextStyle(fontSize: 18),
        leftIcon: Icon(Icons.chevron_left),
        rightIcon: Icon(Icons.chevron_right),
      );

      final mainTheme = DksnCalendarTheme(
        monthly: monthlyTheme,
        weekly: weeklyTheme,
        header: headerTheme,
      );

      expect(mainTheme.monthly, monthlyTheme);
      expect(mainTheme.weekly, weeklyTheme);
      expect(mainTheme.header, headerTheme);

      // Test that sub-themes work correctly
      final testDate = DateTime(2025, 9, 15);
      final monthlyWidget = mainTheme.monthly.dayBuilder!(DateTime.now(), DateTime.now(), testDate);
      final weeklyWidget = mainTheme.weekly.dayBuilder!(DateTime.now(), DateTime.now(), testDate);

      expect(monthlyWidget, isA<Text>());
      expect(weeklyWidget, isA<Text>());
    });

    test('themes support null callbacks gracefully', () {
      final theme = DksnCalendarTheme(
        monthly: DksnCalendarMonthlyTheme(
          dayBuilder: null,
          onDateSelected: null,
        ),
        weekly: DksnCalendarWeeklyTheme(
          dayBuilder: null,
          onDateSelected: null,
        ),
        header: DksnCalendarHeaderTheme(
          label: null,
          labelBuilder: null,
        ),
      );

      expect(theme.monthly.dayBuilder, isNull);
      expect(theme.monthly.onDateSelected, isNull);
      expect(theme.weekly.dayBuilder, isNull);
      expect(theme.weekly.onDateSelected, isNull);
      expect(theme.header.label, isNull);
      expect(theme.header.labelBuilder, isNull);
    });

    test('theme builders can return null to use defaults', () {
      final theme = DksnCalendarMonthlyTheme(
        dayBuilder: (current, selected, date) {
          // Return null for certain dates to use default
          if (date.day % 2 == 0) {
            return null;
          }
          return Container(child: Text('${date.day}'));
        },
      );

      expect(theme.dayBuilder, isNotNull);

      final oddDate = DateTime(2025, 9, 15); // 15 is odd
      final evenDate = DateTime(2025, 9, 16); // 16 is even

      final oddWidget = theme.dayBuilder!(DateTime.now(), DateTime.now(), oddDate);
      final evenWidget = theme.dayBuilder!(DateTime.now(), DateTime.now(), evenDate);

      expect(oddWidget, isA<Container>());
      expect(evenWidget, isNull); // Should return null for even dates
    });
  });
}
