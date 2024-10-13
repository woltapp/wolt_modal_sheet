/// Represents the state of a value of type [T].
///
/// The state can be one of the following:
/// - **Idle:** When the value is successfully loaded (can be null).
/// - **Loading:** When the value is being loaded or processed.
/// - **Error:** When an error has occurred during the loading or processing of the value.
///
/// **Usage Example:**
/// ```dart
/// ValueState<int> state = ValueState.idle(42);
/// ValueState<int> loadingState = ValueState.loading();
/// ValueState<int> errorState = ValueState.error(error: 'An error occurred');
/// ```
sealed class ValueState<T> {
  const ValueState();

  /// Factory constructors for convenience.
  factory ValueState.idle(T? value) => IdleValueState<T>(value: value);
  factory ValueState.loading({T? lastKnownValue}) =>
      LoadingValueState<T>(lastKnownValue: lastKnownValue);
  factory ValueState.error({required Exception error, T? lastKnownValue}) =>
      ErrorValueState<T>(error: error, lastKnownValue: lastKnownValue);
}

/// Represents the state when the value is successfully loaded.
///
/// The [value] can be null.
final class IdleValueState<T> extends ValueState<T> {
  /// The successfully loaded value, which can be null.
  final T? value;

  const IdleValueState({required this.value});
}

/// Represents the state when the value is being loaded or processed.
final class LoadingValueState<T> extends ValueState<T> {
  /// The last known value before the loading began, if any.
  final T? lastKnownValue;

  const LoadingValueState({this.lastKnownValue});
}

/// Represents the state when an error has occurred.
final class ErrorValueState<T> extends ValueState<T> {
  /// The error that occurred.
  final Exception error;

  /// The last known value before the error occurred, if any.
  final T? lastKnownValue;

  const ErrorValueState({required this.error, this.lastKnownValue});
}
