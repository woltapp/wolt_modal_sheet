import 'package:coffee_maker_navigator_2/utils/state_management/value_state.dart';
import 'package:flutter/foundation.dart';

/// An abstract class that extends [ValueListenable] for [ValueState] of type [T].
///
/// It provides getters to check the current state and retrieve the current value.
abstract class StatefulValueListenable<T> extends ValueListenable<ValueState<T>> {
  /// Returns `true` if the current state is [IdleValueState].
  bool get isIdle;

  /// Returns `true` if the current state is [LoadingValueState].
  bool get isLoading;

  /// Returns `true` if the current state is [ErrorValueState].
  bool get isError;

  /// Returns the current value based on the state.
  ///
  /// - For [IdleValueState], it returns the [value].
  /// - For [LoadingValueState] and [ErrorValueState], it returns [lastKnownValue].
  T? get currentValue;
}

/// A notifier class that extends [ValueNotifier] for [ValueState] of type [T].
///
/// It implements [StatefulValueListenable] and provides methods to update the state.
class StatefulValueNotifier<T> extends ValueNotifier<ValueState<T>>
    implements StatefulValueListenable<T> {
  /// Creates a [StatefulValueNotifier] with an optional initial value.
  ///
  /// If [initialValue] is provided, the initial state will be [IdleValueState]
  /// with that value.
  StatefulValueNotifier([T? initialValue])
      : super(ValueState<T>.idle(initialValue));

  @override
  bool get isIdle => value is IdleValueState<T>;

  @override
  bool get isLoading => value is LoadingValueState<T>;

  @override
  bool get isError => value is ErrorValueState<T>;

  @override
  T? get currentValue {
    return value.when(
      idle: (value) => value,
      loading: (lastKnownValue) => lastKnownValue,
      error: (error, lastKnownValue) => lastKnownValue,
    );
  }

  /// Updates the state to [IdleValueState] with an optional [value].
  void setIdle([T? value]) {
    this.value = ValueState<T>.idle(value);
  }

  /// Updates the state to [LoadingValueState] with an optional [lastKnownValue].
  void setLoading() {
    value = ValueState<T>.loading(currentValue);
  }

  /// Updates the state to [ErrorValueState] with an [error] and an optional [lastKnownValue].
  void setError(Object? error) {
    value = ValueState<T>.error(error, currentValue);
  }
}
