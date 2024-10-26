import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

void main() {
  group('ValueState', () {
    group('Factory Constructors', () {
      test('should create an IdleValueState when using ValueState.idle()', () {
        // Arrange
        const value = 42;

        // Act
        final state = ValueState<int>.idle(value: value);

        // Assert
        expect(state, isA<IdleValueState<int>>());
        expect(state.value, equals(value));
        expect(state.isIdle, isTrue);
        expect(state.isLoading, isFalse);
        expect(state.isError, isFalse);
      });

      test(
        'should create a LoadingValueState when using ValueState.loading()',
        () {
          // Arrange
          const value = 42;

          // Act
          final state = ValueState<int>.loading(value: value);

          // Assert
          expect(state, isA<LoadingValueState<int>>());
          expect(state.value, equals(value));
          expect(state.isIdle, isFalse);
          expect(state.isLoading, isTrue);
          expect(state.isError, isFalse);
        },
      );

      test(
        'should create an ErrorValueState when using ValueState.error()',
        () {
          // Arrange
          final error = Exception('An error occurred');
          const value = 42;

          // Act
          final state = ValueState<int>.error(error: error, value: value);

          // Assert
          expect(state, isA<ErrorValueState<int>>());
          expect(state.value, equals(value));
          expect(state.isIdle, isFalse);
          expect(state.isLoading, isFalse);
          expect(state.isError, isTrue);
          expect((state as ErrorValueState<int>).error, equals(error));
        },
      );
    });

    group('IdleValueState', () {
      test('should have correct properties when value is provided', () {
        // Arrange
        const value = 42;

        // Act
        const state = IdleValueState<int>(value: value);

        // Assert
        expect(state.value, equals(value));
        expect(state.isIdle, isTrue);
        expect(state.isLoading, isFalse);
        expect(state.isError, isFalse);
      });

      test('should have null value when no value is provided', () {
        // Act
        const state = IdleValueState<int>();

        // Assert
        expect(state.value, isNull);
        expect(state.isIdle, isTrue);
        expect(state.isLoading, isFalse);
        expect(state.isError, isFalse);
      });

      test('should support equality and have correct hashCode', () {
        // Arrange
        const value = 42;
        const state1 = IdleValueState<int>(value: value);
        const state2 = IdleValueState<int>(value: value);
        const state3 = IdleValueState<int>(value: 43);

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
        expect(state1.hashCode, isNot(equals(state3.hashCode)));
      });

      test('should have correct toString() representation', () {
        // Arrange
        const value = 42;
        const state = IdleValueState<int>(value: value);

        // Act
        final str = state.toString();

        // Assert
        expect(str, equals('IdleValueState(value: 42)'));
      });
    });

    group('LoadingValueState', () {
      test('should have correct properties when value is provided', () {
        // Arrange
        const value = 42;

        // Act
        const state = LoadingValueState<int>(value: value);

        // Assert
        expect(state.value, equals(value));
        expect(state.isIdle, isFalse);
        expect(state.isLoading, isTrue);
        expect(state.isError, isFalse);
      });

      test('should have null value when no value is provided', () {
        // Act
        const state = LoadingValueState<int>();

        // Assert
        expect(state.value, isNull);
        expect(state.isIdle, isFalse);
        expect(state.isLoading, isTrue);
        expect(state.isError, isFalse);
      });

      test('should support equality and have correct hashCode', () {
        // Arrange
        const value = 42;
        const state1 = LoadingValueState<int>(value: value);
        const state2 = LoadingValueState<int>(value: value);
        const state3 = LoadingValueState<int>(value: 43);

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
        expect(state1.hashCode, isNot(equals(state3.hashCode)));
      });

      test('should have correct toString() representation', () {
        // Arrange
        const value = 42;
        const state = LoadingValueState<int>(value: value);

        // Act
        final str = state.toString();

        // Assert
        expect(str, equals('LoadingValueState(value: 42)'));
      });
    });

    group('ErrorValueState', () {
      test(
        'should have correct properties when error and value are provided',
        () {
          // Arrange
          final error = Exception('An error occurred');
          const value = 42;

          // Act
          final state = ErrorValueState<int>(error: error, value: value);

          // Assert
          expect(state.value, equals(value));
          expect(state.isIdle, isFalse);
          expect(state.isLoading, isFalse);
          expect(state.isError, isTrue);
          expect(state.error, equals(error));
        },
      );

      test('should have null value when no value is provided', () {
        // Arrange
        final error = Exception('An error occurred');

        // Act
        final state = ErrorValueState<int>(error: error);

        // Assert
        expect(state.value, isNull);
        expect(state.isIdle, isFalse);
        expect(state.isLoading, isFalse);
        expect(state.isError, isTrue);
        expect(state.error, equals(error));
      });

      test('should support equality and have correct hashCode', () {
        // Arrange
        final error = Exception('An error occurred');
        const value = 42;
        final state1 = ErrorValueState<int>(error: error, value: value);
        final state2 = ErrorValueState<int>(error: error, value: value);
        final state3 = ErrorValueState<int>(
          error: Exception('Different error'),
          value: 42,
        );

        // Act & Assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
        expect(state1.hashCode, isNot(equals(state3.hashCode)));
      });

      test('should have correct toString() representation', () {
        // Arrange
        final error = Exception('An error occurred');
        const value = 42;
        final state = ErrorValueState<int>(error: error, value: value);

        // Act
        final str = state.toString();

        // Assert
        expect(
          str,
          equals(
            'ErrorValueState(error: Exception: An error occurred, value: 42)',
          ),
        );
      });
    });

    group('State Transition Methods', () {
      test(
        'setLoading transitions to LoadingValueState without retaining value',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 42);

          // Act
          final loadingState = idleState.setLoading();

          // Assert
          expect(loadingState, isA<LoadingValueState<int>>());
          expect(loadingState.isLoading, isTrue);
          expect(loadingState.value, isNull);
        },
      );

      test(
        'setLoading transitions to LoadingValueState retaining current value',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 42);

          // Act
          final loadingState = idleState.setLoading(retainValue: true);

          // Assert
          expect(loadingState, isA<LoadingValueState<int>>());
          expect(loadingState.isLoading, isTrue);
          expect(loadingState.value, equals(42));
        },
      );

      test(
        'setError transitions to ErrorValueState without retaining value',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 42);
          final exception = Exception('An error occurred');

          // Act
          final errorState = idleState.setError(error: exception);

          // Assert
          expect(errorState, isA<ErrorValueState<int>>());
          expect(errorState.isError, isTrue);
          expect(errorState.value, isNull);
          expect((errorState as ErrorValueState<int>).error, equals(exception));
        },
      );

      test(
        'setError transitions to ErrorValueState retaining current value',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 42);
          final exception = Exception('An error occurred');

          // Act
          final errorState = idleState.setError(error: exception, retainValue: true);

          // Assert
          expect(errorState, isA<ErrorValueState<int>>());
          expect(errorState.isError, isTrue);
          expect(errorState.value, equals(42));
          expect((errorState as ErrorValueState<int>).error, equals(exception));
        },
      );

      test('setIdle transitions to IdleValueState with new value', () {
        // Arrange
        final loadingState = ValueState<int>.loading(value: 42);

        // Act
        final idleState = loadingState.setIdle(value: 100);

        // Assert
        expect(idleState, isA<IdleValueState<int>>());
        expect(idleState.isIdle, isTrue);
        expect(idleState.value, equals(100));
      });

      test('setIdle transitions to IdleValueState with null value', () {
        // Arrange
        final errorState = ValueState<int>.error(error: Exception('Error'), value: 42);

        // Act
        final idleState = errorState.setIdle();

        // Assert
        expect(idleState, isA<IdleValueState<int>>());
        expect(idleState.isIdle, isTrue);
        expect(idleState.value, isNull);
      });
    });

    group('Chain of Transitions', () {
      test(
        'should retain value through multiple transitions when retaining',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 50);

          // Act
          final loadingState = idleState.setLoading(retainValue: true);
          final errorState = loadingState.setError(error: Exception('Error'), retainValue: true);

          // Assert
          expect(loadingState.value, equals(50));
          expect(errorState.value, equals(50));
        },
      );

      test(
        'should not retain value through transitions when not retaining',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 50);

          // Act
          final loadingState = idleState.setLoading();
          final errorState = loadingState.setError(error: Exception('Error'));

          // Assert
          expect(loadingState.value, isNull);
          expect(errorState.value, isNull);
        },
      );
    });

    group('Error Handling', () {
      test(
        'should throw assertion error when both retainValue and value are provided in setLoading',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 42);

          // Act & Assert
          expect(
            () => idleState.setLoading(retainValue: true, value: 100),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'should throw assertion error when both retainValue and value are provided in setError',
        () {
          // Arrange
          final idleState = ValueState<int>.idle(value: 42);

          // Act & Assert
          expect(
            () => idleState.setError(
              error: Exception('Error'),
              retainValue: true,
              value: 100,
            ),
            throwsA(isA<AssertionError>()),
          );
        },
      );
    });

    group('ValueState with Nullable Types', () {
      test('should allow null values in IdleValueState', () {
        // Act
        const state = IdleValueState<int?>();

        // Assert
        expect(state.value, isNull);
        expect(state.isIdle, isTrue);
      });

      test('should allow null value in LoadingValueState', () {
        // Act
        const state = LoadingValueState<int?>();

        // Assert
        expect(state.value, isNull);
        expect(state.isLoading, isTrue);
      });

      test('should allow null value in ErrorValueState', () {
        // Arrange
        final error = Exception('Error');

        // Act
        final state = ErrorValueState<int?>(error: error);

        // Assert
        expect(state.value, isNull);
        expect(state.isError, isTrue);
      });
    });

    group('ErrorValueState with Different Exceptions', () {
      test('should handle different exceptions correctly', () {
        // Arrange
        final exception1 = Exception('Error 1');
        const exception2 = FormatException('Error 2');

        // Act
        final state1 = ErrorValueState<int>(error: exception1);
        const state2 = ErrorValueState<int>(error: exception2);

        // Assert
        expect(state1.error, equals(exception1));
        expect(state2.error, equals(exception2));
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
