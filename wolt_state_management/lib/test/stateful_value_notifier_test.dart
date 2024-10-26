// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

void main() {
  group('StatefulValueNotifier', () {
    group('Initialization', () {
      test(
        'should initialize with IdleValueState when initial value is provided',
        () {
          // Arrange
          const initialValue = 42;

          // Act
          final notifier = StatefulValueNotifier<int>.idle(initialValue);

          // Assert
          expect(notifier.value, isA<IdleValueState<int>>());
          expect(notifier.currentValue, equals(initialValue));
          expect(notifier.isIdle, isTrue);
          expect(notifier.isLoading, isFalse);
          expect(notifier.isError, isFalse);
        },
      );

      test(
        'should initialize with IdleValueState with null when no initial value is provided',
        () {
          // Act
          final notifier = StatefulValueNotifier<int>.idle();

          // Assert
          expect(notifier.value, isA<IdleValueState<int>>());
          expect(notifier.currentValue, isNull);
          expect(notifier.isIdle, isTrue);
          expect(notifier.isLoading, isFalse);
          expect(notifier.isError, isFalse);
        },
      );
    });

    group('setIdle', () {
      test('should update state to IdleValueState with provided value', () {
        // Arrange
        final notifier = StatefulValueNotifier<int>.idle();

        // Act
        notifier.setIdle(value: 100);

        // Assert
        expect(notifier.value, isA<IdleValueState<int>>());
        expect(notifier.currentValue, equals(100));
        expect(notifier.isIdle, isTrue);
      });
    });

    group('setLoading', () {
      test(
        'should update state to LoadingValueState without retaining value',
        () {
          // Arrange
          final notifier = StatefulValueNotifier<int>.idle(42);

          // Act
          notifier.setLoading();

          // Assert
          expect(notifier.value, isA<LoadingValueState<int>>());
          expect(notifier.currentValue, isNull);
          expect(notifier.isLoading, isTrue);
        },
      );

      test(
        'should update state to LoadingValueState retaining currentValue',
        () {
          // Arrange
          final notifier = StatefulValueNotifier<int>.idle(42);

          // Act
          notifier.setLoading(retainValue: true);

          // Assert
          expect(notifier.value, isA<LoadingValueState<int>>());
          expect(notifier.currentValue, equals(42));
          expect(notifier.isLoading, isTrue);
        },
      );

      test(
        'should throw assertion error when both retainValue and value are provided',
        () {
          // Arrange
          final notifier = StatefulValueNotifier<int>.idle(42);

          // Act & Assert
          expect(
            () => notifier.setLoading(retainValue: true, value: 100),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    });

    group('setError', () {
      test(
        'should update state to ErrorValueState without retaining value',
        () {
          // Arrange
          final notifier = StatefulValueNotifier<int>.idle(42);
          final error = Exception('An error occurred');

          // Act
          notifier.setError(error: error);

          // Assert
          expect(notifier.value, isA<ErrorValueState<int>>());
          expect(notifier.currentValue, isNull);
          expect(notifier.isError, isTrue);
          expect((notifier.value as ErrorValueState<int>).error, equals(error));
        },
      );

      test('should update state to ErrorValueState retaining currentValue', () {
        // Arrange
        final notifier = StatefulValueNotifier<int>.idle(42);
        final error = Exception('An error occurred');

        // Act
        notifier.setError(error: error, retainValue: true);

        // Assert
        expect(notifier.value, isA<ErrorValueState<int>>());
        expect(notifier.currentValue, equals(42));
        expect(notifier.isError, isTrue);
        expect((notifier.value as ErrorValueState<int>).error, equals(error));
      });

      test(
        'should throw assertion error when both retainValue and value are provided',
        () {
          // Arrange
          final notifier = StatefulValueNotifier<int>.idle(42);
          final error = Exception('An error occurred');

          // Act & Assert
          expect(
            () => notifier.setError(error: error, retainValue: true, value: 100),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    });

    group('Accessors', () {
      test('should return correct state properties', () {
        // Arrange
        final notifier = StatefulValueNotifier<int>.idle();

        // Act & Assert
        expect(notifier.isIdle, isTrue);
        expect(notifier.isLoading, isFalse);
        expect(notifier.isError, isFalse);

        notifier.setLoading();
        expect(notifier.isIdle, isFalse);
        expect(notifier.isLoading, isTrue);
        expect(notifier.isError, isFalse);

        notifier.setError(error: Exception('Error'));
        expect(notifier.isIdle, isFalse);
        expect(notifier.isLoading, isFalse);
        expect(notifier.isError, isTrue);

        notifier.setIdle(value: 100);
        expect(notifier.isIdle, isTrue);
        expect(notifier.isLoading, isFalse);
        expect(notifier.isError, isFalse);
      });

      test('should return correct currentValue', () {
        // Arrange
        final notifier = StatefulValueNotifier<int>.idle(42);

        // Act & Assert
        expect(notifier.currentValue, equals(42));

        notifier.setLoading(retainValue: true);
        expect(notifier.currentValue, equals(42));

        notifier.setError(error: Exception('Error'));
        expect(notifier.currentValue, isNull);
      });
    });

    group('Listeners', () {
      test('should notify listeners when state changes', () {
        // Arrange
        final notifier = StatefulValueNotifier<int>.idle(42);
        final states = <ValueState<int>>[];

        notifier.addListener(() {
          states.add(notifier.value);
        });

        // Act
        notifier.setLoading();
        notifier.setError(error: Exception('Error'));
        notifier.setIdle(value: 100);

        // Assert
        expect(states.length, equals(3));
        expect(states.first, isA<LoadingValueState<int>>());
        expect(states[1], isA<ErrorValueState<int>>());
        expect(states[2], isA<IdleValueState<int>>());
      });

      test('should not notify listeners when state does not change', () {
        // Arrange
        final notifier = StatefulValueNotifier<int>.idle(42);
        int notificationCount = 0;

        notifier
          ..addListener(() {
            notificationCount++;
          })

          // Act
          ..value = notifier.value; // Setting the same value

        expect(notificationCount, equals(0));
      });
    });

    group('Factory Constructors', () {
      test(
        'should initialize with IdleValueState when using idle factory constructor with initial value',
        () {
          // Arrange
          const initialValue = 42;

          // Act
          final notifier = StatefulValueNotifier<int>.idle(initialValue);

          // Assert
          expect(notifier.value, isA<IdleValueState<int>>());
          expect(notifier.currentValue, equals(initialValue));
          expect(notifier.isIdle, isTrue);
          expect(notifier.isLoading, isFalse);
          expect(notifier.isError, isFalse);
        },
      );

      test(
        'should initialize with IdleValueState when using idle factory constructor without initial value',
        () {
          // Act
          final notifier = StatefulValueNotifier<int>.idle();

          // Assert
          expect(notifier.value, isA<IdleValueState<int>>());
          expect(notifier.currentValue, isNull);
          expect(notifier.isIdle, isTrue);
          expect(notifier.isLoading, isFalse);
          expect(notifier.isError, isFalse);
        },
      );

      test(
        'should initialize with LoadingValueState when using loading factory constructor with initial value',
        () {
          // Arrange
          const initialValue = 42;

          // Act
          final notifier = StatefulValueNotifier<int>.loading(initialValue);

          // Assert
          expect(notifier.value, isA<LoadingValueState<int>>());
          expect(notifier.currentValue, equals(initialValue));
          expect(notifier.isIdle, isFalse);
          expect(notifier.isLoading, isTrue);
          expect(notifier.isError, isFalse);
        },
      );

      test(
        'should initialize with LoadingValueState when using loading factory constructor without initial value',
        () {
          // Act
          final notifier = StatefulValueNotifier<int>.loading();

          // Assert
          expect(notifier.value, isA<LoadingValueState<int>>());
          expect(notifier.currentValue, isNull);
          expect(notifier.isIdle, isFalse);
          expect(notifier.isLoading, isTrue);
          expect(notifier.isError, isFalse);
        },
      );

      test(
        'should initialize with ErrorValueState when using error factory constructor with initial value',
        () {
          // Arrange
          const initialValue = 42;
          final error = Exception('Test Error');

          // Act
          final notifier = StatefulValueNotifier<int>.error(error, initialValue);

          // Assert
          expect(notifier.value, isA<ErrorValueState<int>>());
          expect(notifier.currentValue, equals(initialValue));
          expect(notifier.isIdle, isFalse);
          expect(notifier.isLoading, isFalse);
          expect(notifier.isError, isTrue);
          expect((notifier.value as ErrorValueState<int>).error, equals(error));
        },
      );

      test(
        'should initialize with ErrorValueState when using error factory constructor without initial value',
        () {
          // Arrange
          final error = Exception('Test Error');

          // Act
          final notifier = StatefulValueNotifier<int>.error(error);

          // Assert
          expect(notifier.value, isA<ErrorValueState<int>>());
          expect(notifier.currentValue, isNull);
          expect(notifier.isIdle, isFalse);
          expect(notifier.isLoading, isFalse);
          expect(notifier.isError, isTrue);
          expect((notifier.value as ErrorValueState<int>).error, equals(error));
        },
      );
    });
  });
}
