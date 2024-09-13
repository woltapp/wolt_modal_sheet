/// Represents the state of a value of type [T].
///
/// The state can be one of the following:
/// - Idle: when the value is successfully loaded (can be null).
/// - Loading: when the value is being loaded or processed.
/// - Error: when an error has occurred during the loading or processing of the value.
sealed class ValueState<T> {
  /// Constructor for [ValueState].
  const ValueState();

  /// Applies a function based on the current state.
  ///
  /// This enforces exhaustive handling of all possible states.
  ///
  /// **Usage example**:
  /// ```dart
  /// ValueState<int?> valueState = ValueState<int?>.idle(42);
  ///
  /// valueState.when(
  ///   idle: (value) {
  ///     // Handle the idle state with value (which can be null)
  ///     print('Idle: $value');
  ///   },
  ///   loading: (lastKnownValue) {
  ///     // Handle the loading state with last known value
  ///     print('Loading...');
  ///     if (lastKnownValue != null) {
  ///       print('Last known value: $lastKnownValue');
  ///     }
  ///   },
  ///   error: (error, lastKnownValue) {
  ///     // Handle the error state
  ///     print('Error occurred: $error');
  ///     if (lastKnownValue != null) {
  ///       print('Last known value: $lastKnownValue');
  ///     }
  ///   },
  /// );
  /// ```
  ///
  /// In this example, depending on the current state of `valueState`, the appropriate
  /// callback will be executed.
  R when<R>({
    required R Function(T? value) idle,
    required R Function(T? lastKnownValue) loading,
    required R Function(Object? error, T? lastKnownValue) error,
  }) {
    if (this is IdleValueState<T>) {
      return idle((this as IdleValueState<T>).value);
    } else if (this is LoadingValueState<T>) {
      return loading((this as LoadingValueState<T>).lastKnownValue);
    } else if (this is ErrorValueState<T>) {
      final errorState = this as ErrorValueState<T>;
      return error(errorState.error, errorState.lastKnownValue);
    }
    throw StateError('Unknown state: $this');
  }

  /// Factory constructors for convenience.
  factory ValueState.idle([T? value]) => IdleValueState<T>(value);
  factory ValueState.loading([T? lastKnownValue]) =>
      LoadingValueState<T>(lastKnownValue);
  factory ValueState.error(Object? error, [T? lastKnownValue]) =>
      ErrorValueState<T>(error, lastKnownValue);
}

/// Represents the state when the value is successfully loaded.
///
/// The [value] can be null.
final class IdleValueState<T> extends ValueState<T> {
  /// The successfully loaded value, which can be null.
  final T? value;

  /// Constructor for [IdleValueState].
  const IdleValueState([this.value]);
}

/// Represents the state when the value is being loaded or processed.
final class LoadingValueState<T> extends ValueState<T> {
  /// The last known value before the loading began, if any.
  final T? lastKnownValue;

  /// Constructor for [LoadingValueState].
  const LoadingValueState([this.lastKnownValue]);
}

/// Represents the state when an error has occurred.
final class ErrorValueState<T> extends ValueState<T> {
  /// The error that occurred.
  final Object? error;

  /// The last known value before the error occurred, if any.
  final T? lastKnownValue;

  /// Constructor for [ErrorValueState].
  const ErrorValueState(this.error, [this.lastKnownValue]);
}
