// ignore_for_file: avoid-nullable-interpolation

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

void main() {
  group('StatefulValueListenableBuilder Widget Tests', () {
    group('Idle State', () {
      testWidgets(
        'should display idleBuilder when the state is IdleValueState',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.idle(42);

          await tester.pumpWidget(
            const MaterialApp(
              home: SizedBox.shrink(), // Placeholder for the widget under test.
            ),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Act
          // No action needed since the initial state is idle.

          // Assert
          expect(find.text('Idle State. Value: 42'), findsOneWidget);
        },
      );

      testWidgets(
        'should rebuild idleBuilder when the value changes',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.idle(42);

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Act
          valueNotifier.setIdle(value: 100);
          await tester.pumpAndSettle();

          // Assert
          expect(find.text('Idle State. Value: 100'), findsOneWidget);
        },
      );
    });

    group('Loading State', () {
      testWidgets(
        'should display loadingBuilder when the state is LoadingValueState',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.loading(42);

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
                loadingBuilder: (context, currentValue) {
                  return Text('Loading State. Last Known Value: $currentValue');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Act
          // No additional action needed since the state is already set to loading.

          // Assert
          expect(
            find.text('Loading State. Last Known Value: 42'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'should display SizedBox.shrink when loadingBuilder is not provided',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.loading(42);

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
                // No loadingBuilder provided
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Act
          // No additional action needed.

          // Assert
          expect(find.byType(SizedBox), findsOneWidget);
          expect(find.byType(Text), findsNothing);
        },
      );
    });

    group('Error State', () {
      testWidgets(
        'should display errorBuilder when the state is ErrorValueState',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.idle(42);
          final error = Exception('Test Error');
          valueNotifier.setError(error: error, retainValue: true);

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
                errorBuilder: (context, error, currentValue) {
                  return Text('Error State: $error');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Act
          // No additional action needed.

          // Assert
          expect(
            find.text('Error State: Exception: Test Error'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'should display SizedBox.shrink when errorBuilder is not provided',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.idle(42);
          final error = Exception('Test Error');
          valueNotifier.setError(error: error);

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
                // No errorBuilder provided
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Act
          // No additional action needed.

          // Assert
          expect(find.byType(SizedBox), findsOneWidget);
          expect(find.byType(Text), findsNothing);
        },
      );
    });

    group('State Transitions', () {
      testWidgets(
        'should update the UI when state changes from idle to loading to idle',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.idle(42);

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
                loadingBuilder: (context, currentValue) {
                  return const Text('Loading State');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Assert initial state
          expect(find.text('Idle State. Value: 42'), findsOneWidget);

          // Act
          // Transition to loading state
          valueNotifier.setLoading(retainValue: true);
          await tester.pumpAndSettle();

          // Assert loading state
          expect(find.text('Loading State'), findsOneWidget);

          // Act
          // Transition back to idle state
          valueNotifier.setIdle(value: 100);
          await tester.pumpAndSettle();

          // Assert idle state with new value
          expect(find.text('Idle State. Value: 100'), findsOneWidget);
        },
      );

      testWidgets(
        'should update the UI when state changes from idle to error to idle',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int>.idle(42);
          final error = Exception('Test Error');

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: $value');
                },
                errorBuilder: (context, error, currentValue) {
                  return Text('Error State: $error');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Assert initial state
          expect(find.text('Idle State. Value: 42'), findsOneWidget);

          // Act
          // Transition to error state
          valueNotifier.setError(error: error, retainValue: true);
          await tester.pumpAndSettle();

          // Assert error state
          expect(
            find.text('Error State: Exception: Test Error'),
            findsOneWidget,
          );

          // Act
          // Transition back to idle state
          valueNotifier.setIdle(value: 100);
          await tester.pumpAndSettle();

          // Assert idle state with new value
          expect(find.text('Idle State. Value: 100'), findsOneWidget);
        },
      );
    });

    group('Edge Cases', () {
      testWidgets(
        'should handle null value in idle state',
        (tester) async {
          // Arrange
          final valueNotifier = StatefulValueNotifier<int?>.idle();

          await tester.pumpWidget(
            MaterialApp(
              home: StatefulValueListenableBuilder<int?>(
                valueListenable: valueNotifier,
                idleBuilder: (context, value) {
                  return Text('Idle State. Value: ${value ?? 'null'}');
                },
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Act
          // No action needed.

          // Assert
          expect(find.text('Idle State. Value: null'), findsOneWidget);
        },
      );
    });
  });
}
