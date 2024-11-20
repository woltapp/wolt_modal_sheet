import 'package:flutter/foundation.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

/// An interface that extends [ValueListenable] for [ValueState] of type [T],
/// providing convenient getters for checking the current state and value.
abstract class StatefulValueListenable<T>
    extends ValueListenable<ValueState<T>> {
  /// Returns `true` if the current state is idle.
  bool get isIdle;

  /// Returns `true` if the current state is loading.
  bool get isLoading;

  /// Returns `true` if the current state is error.
  bool get isError;

  /// The current value associated with the state.
  T? get currentValue;
}

/// A [ValueNotifier] that holds a [ValueState] of type [T],
/// allowing state transitions and value updates with notification to listeners.
///
/// It implements [StatefulValueListenable] to provide convenient access to the current state and value.
///
/// **Usage Example:**
///
/// ```dart
/// // Initialize the notifier with an initial value.
/// final notifier = StatefulValueNotifier<int>(0);
///
/// // Listen to changes in the state.
/// notifier.addListener(() {
///   final state = notifier.value;
///   switch (state) {
///     case IdleValueState(value: var value):
///       print('Idle: value');
///       break;
///     case LoadingValueState(value: var value):
///       print('Loading, value: value');
///       break;
///     case ErrorValueState(error: var error, value: var value):
///       print('Error: $error, value: value');
///       break;
///   }
/// });
///
/// // Update the state to loading.
/// notifier.setLoading();
///
/// // Simulate some async operation.
/// Future.delayed(Duration(seconds: 2), () {
///   // Update the state to idle with a new value.
///   notifier.setIdle(value: 42);
/// });
///
/// // Update the state to error.
/// notifier.setError(error: Exception('Something went wrong'));
/// ```
class StatefulValueNotifier<T> extends ValueNotifier<ValueState<T>>
    implements StatefulValueListenable<T> {
  @override
  bool get isIdle => value.isIdle;

  @override
  bool get isLoading => value.isLoading;

  @override
  bool get isError => value.isError;

  @override
  T? get currentValue => value.value;

  /// Creates a [StatefulValueNotifier] with an optional initial value.
  ///
  /// If [initialValue] is provided, the initial state is [IdleValueState] with that value.
  /// If [initialValue] is not provided, the initial state is [IdleValueState] with `null` value.
  StatefulValueNotifier._([T? initialValue])
      : super(ValueState.idle(value: initialValue));

  factory StatefulValueNotifier.idle([T? initialValue]) {
    return StatefulValueNotifier._(initialValue);
  }

  factory StatefulValueNotifier.loading([T? initialValue]) {
    return StatefulValueNotifier._()..setLoading(value: initialValue);
  }

  factory StatefulValueNotifier.error(Object error, [T? initialValue]) {
    return StatefulValueNotifier._()
      ..setError(error: error, value: initialValue);
  }

  /// Transitions to an idle state with a new value.
  void setIdle({T? value}) {
    this.value = this.value.setIdle(value: value);
  }

  /// Transitions to a loading state, optionally retaining the current value or setting a new value.
  ///
  /// If [retainValue] is `true`, the current value is retained.
  /// If a new [value] is provided and [retainValue] is `false`, the new [value] is used.
  /// If both [retainValue] and [value] are provided, an assertion error is thrown.
  void setLoading({bool retainValue = false, T? value}) {
    this.value = this.value.setLoading(retainValue: retainValue, value: value);
  }

  /// Transitions to an error state with a given [error], optionally retaining the current value or setting a new value.
  ///
  /// Requires a non-null [error].
  /// If [retainValue] is `true`, the current value is retained.
  /// If a new [value] is provided and [retainValue] is `false`, the new [value] is used.
  /// If both [retainValue] and [value] are provided, an assertion error is thrown.
  void setError({required Object error, bool retainValue = false, T? value}) {
    this.value = this
        .value
        .setError(error: error, retainValue: retainValue, value: value);
  }
}
