/// A sealed class representing the state of a value of type [T].
///
/// This class is useful for handling asynchronous operations or computations
/// where the value can be in one of three states:
///
/// - **Idle**: The value is successfully loaded or initialized.
/// - **Loading**: The value is in the process of being loaded or processed.
/// - **Error**: An error occurred during the loading or processing of the value.
sealed class ValueState<T> {
  /// The current value associated with the state.
  final T? value;

  /// Indicates whether the state is [IdleValueState].
  bool get isIdle;

  /// Indicates whether the state is [LoadingValueState].
  bool get isLoading;

  /// Indicates whether the state is [ErrorValueState].
  bool get isError;

  /// Constructs a [ValueState] with an optional [value].
  const ValueState(this.value);

  /// Factory constructor to create an [IdleValueState] with an optional [value].
  factory ValueState.idle({T? value}) => IdleValueState<T>(value: value);

  /// Factory constructor to create a [LoadingValueState] with an optional [value].
  factory ValueState.loading({T? value}) => LoadingValueState<T>(value: value);

  /// Factory constructor to create an [ErrorValueState] with a required [error]
  /// and an optional [value].
  factory ValueState.error({required Object error, T? value}) =>
      ErrorValueState<T>(error: error, value: value);

  String toString();

  /// Transitions to a [LoadingValueState], optionally retaining the current [value]
  /// or setting a new [value].
  ///
  /// If [retainValue] is `true`, the current [value] is retained.
  /// If a new [value] is provided and [retainValue] is `false`, the new [value] is used.
  /// If both [retainValue] and [value] are provided, an assertion error is thrown.
  ValueState<T> setLoading({bool retainValue = false, T? value}) {
    assert(
      !(retainValue && value != null),
      'Cannot specify both retainValue as true and provide a new value.',
    );

    return ValueState.loading(value: retainValue ? this.value : value);
  }

  /// Transitions to an [ErrorValueState], optionally retaining the current [value]
  /// or setting a new [value].
  ///
  /// Requires a non-null [error].
  /// If [retainValue] is `true`, the current [value] is retained.
  /// If a new [value] is provided and [retainValue] is `false`, the new [value] is used.
  /// If both [retainValue] and [value] are provided, an assertion error is thrown.
  ValueState<T> setError({
    required Object error,
    bool retainValue = false,
    T? value,
  }) {
    assert(
      !(retainValue && value != null),
      'Cannot specify both retainValue as true and provide a new value.',
    );

    return ValueState.error(
      error: error,
      value: retainValue ? this.value : value,
    );
  }

  /// Transitions to an [IdleValueState], setting a new [value].
  ValueState<T> setIdle({T? value}) {
    return ValueState.idle(value: value);
  }
}

/// Represents the state when the value is successfully loaded.
///
/// The [value] can be `null`.
final class IdleValueState<T> extends ValueState<T> {
  @override
  bool get isIdle => true;

  @override
  bool get isLoading => false;

  @override
  bool get isError => false;

  @override
  int get hashCode => value.hashCode;

  /// Creates an [IdleValueState] with an optional [value].
  const IdleValueState({T? value}) : super(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdleValueState<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  String toString() => 'IdleValueState(value: ${value ?? 'null'})';
}

/// Represents the state when the value is being loaded or processed.
///
/// Optionally holds the [value], which may be retained from a previous state.
final class LoadingValueState<T> extends ValueState<T> {
  @override
  bool get isIdle => false;

  @override
  bool get isLoading => true;

  @override
  bool get isError => false;

  @override
  int get hashCode => value.hashCode;

  /// Creates a [LoadingValueState] with an optional [value].
  const LoadingValueState({T? value}) : super(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingValueState<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  String toString() => 'LoadingValueState(value: ${value ?? 'null'})';
}

/// Represents the state when an error has occurred.
///
/// Holds an [error] representing the exception that occurred, and optionally
/// holds the [value], which may be retained from a previous state.
final class ErrorValueState<T> extends ValueState<T> {
  /// The error that occurred.
  final Object error;

  @override
  bool get isIdle => false;

  @override
  bool get isLoading => false;

  @override
  bool get isError => true;

  @override
  int get hashCode => Object.hash(error, value);

  /// Creates an [ErrorValueState] with a required [error] and an optional [value].
  const ErrorValueState({required this.error, T? value}) : super(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorValueState<T> &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          value == other.value;

  @override
  String toString() =>
      'ErrorValueState(error: $error, value: ${value ?? 'null'})';
}
