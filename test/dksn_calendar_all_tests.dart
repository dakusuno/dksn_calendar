// ignore_for_file: prefer_const_constructors

/// Comprehensive test suite for the DKSN Calendar library.
/// 
/// This file imports and runs all test suites to ensure complete coverage
/// of the calendar functionality including:
/// - Widget tests for the main calendar components
/// - Unit tests for the controller logic
/// - Tests for utility functions and extensions
/// - Theme and customization tests
/// - Integration tests for complete workflows
/// 
/// Run all tests with: flutter test
/// Run specific test file with: flutter test test/src/specific_test.dart

import 'src/dksn_calendar_test.dart' as calendar_widget_tests;
import 'src/dksn_calendar_controller_test.dart' as controller_tests;
import 'src/dksn_calendar_utils_test.dart' as utils_tests;
import 'src/dksn_calendar_type_test.dart' as type_tests;
import 'src/dksn_calendar_theme_test.dart' as theme_tests;
import 'src/dksn_calendar_integration_test.dart' as integration_tests;

void main() {
  // Run all test suites
  calendar_widget_tests.main();
  controller_tests.main();
  utils_tests.main();
  type_tests.main();
  theme_tests.main();
  integration_tests.main();
}
