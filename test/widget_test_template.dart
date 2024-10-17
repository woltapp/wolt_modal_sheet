import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This is a template for widget tests.
/// It is meant to be copied and pasted into a new file and then modified to fit the widget or feature you're testing
/// An example of a test files that uses this template are:
/// [test/settings/task_history/task_history_group_task_list_v2_test.dart]
/// [test/localizations/localizations_test.dart]
/// Confluence page with more inspiration:
/// https://woltwide.atlassian.net/wiki/spaces/MAL/pages/3215262013/Widget+and+Unit+tests+for+a+new+features

void main() {
  /// Name of the widget you're testing
  group('Widget tests group description', () {
    /// Registers a function to be run once before all tests.
    /// This is where you should register all fallback values for fakes
    setUpAll(() {});

    /// This is a setup method that will be called everytime before each test.
    /// Use it to initialize and register mocks.
    /// Avoid stubbing on top level, rather do it in the method group setup callback or test case itself.
    /// If you need test objects to be created, do it in the group or test case itself.
    ///
    /// only do generic setup here, if you need to do specific setup for a test case, do it in the test case
    setUp(() {});

    /// This is a teardown method that will be called after each test
    /// use it to dispose of mocks and fakes if needed
    tearDown(() {});

    /// If widget functionality is very complex and might be divided to a smaller logical groups,
    /// test suite should be split to a smaller groups to ease understanding.
    /// Any setup that is specific to the subgroup and needs to be done once should be done in the subgroup's setup method
    /// otherwise in the test case itself
    group('subgroup-1', () {
      /// You can use the setup method to do stubbing for all test cases. If you need to do specific stubbing for a
      /// test case, do it in the test case itself.
      setUp(() {});

      /// Each test case should have a name that describes what it is testing and what the expected result is.
      /// Don't test too much in one case. If you need to test multiple things, create multiple test cases.
      /// Ideally, start the name with the word 'should' to make it clear what the expected result is and use the
      /// word 'when' to describe a specific scenario.

      testWidgets(
        'should <expected result> when <action to perform>',
        (tester) async {
          /// Arrange
          /// Create test objects and stub methods here
          // Set up needed data
          await tester.pumpWidget(
            const MaterialApp(
              home: SizedBox.shrink() /* Insert your widget to test here */,
            ),
          );
          await tester.pumpAndSettle();

          /// Act
          /// Call the method you're testing
          // Perform Step 1
          // Perform Step 2

          /// Assert
          /// Verify that the method did what it was supposed to do
          // Assert that steps reached <expected result>
          expect('Actual result', 'Expected result', reason: 'Failure reason');
        },
      );

      testWidgets(
        'should <expected result 2> when <action to perform 2>',
        (tester) async {},
      );
    });

    group('subgroup-2', () {
      setUp(() {});

      testWidgets(
        'should <expected result 1> when <actions to perform 1>',
        (tester) async {},
      );

      testWidgets(
        'should <expected result 2> when <actions to perform 2>',
        (tester) async {},
      );
    });
  });
}
