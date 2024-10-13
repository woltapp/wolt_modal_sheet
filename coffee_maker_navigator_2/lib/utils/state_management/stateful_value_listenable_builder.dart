import 'package:coffee_maker_navigator_2/utils/state_management/stateful_value_notifier.dart';
import 'package:coffee_maker_navigator_2/utils/state_management/value_state.dart';
import 'package:flutter/widgets.dart';

/// A builder function that builds a widget based on the provided value.
typedef ValueWidgetBuilder<T> = Widget Function(
    BuildContext context, T? value, Widget? child);

/// A builder function that builds a widget based on the provided error and last known value.
typedef ErrorWidgetBuilder<T> = Widget Function(
    BuildContext context, Object error, T? lastKnownValue, Widget? child);

/// A widget that builds itself based on the latest value of a [StatefulValueListenable].
///
/// It rebuilds whenever the [valueListenable] notifies its listeners.
///
/// **Usage example**:
/// ```dart
///  // Create a StatefulValueNotifier with an initial value
///  final valueNotifier = StatefulValueNotifier<int>(0);
///
///  // Use the StatefulValueListenableBuilder in your widget tree
///  StatefulValueListenableBuilder<int>(
///    valueListenable: valueNotifier,
///    idleBuilder: (context, value, child) {
///      return Column(
///        mainAxisAlignment: MainAxisAlignment.center,
///        children: [
///          Text('Idle State. Value: \$value'),
///          ElevatedButton(
///            onPressed: () {
///              // Transition to loading state
///              valueNotifier.setLoading();
///              // Simulate a data fetch or processing delay
///              Future.delayed(Duration(seconds: 2), () {
///                // Update to a new idle state with an incremented value
///                valueNotifier.setIdle((value ?? 0) + 1);
///              });
///            },
///            child: Text('Increment Value'),
///          ),
///        ],
///      );
///    },
///    loadingBuilder: (context, lastKnownValue, child) {
///      return Center(
///        child: CircularProgressIndicator(),
///      );
///    },
///    errorBuilder: (context, error, lastKnownValue, child) {
///      return Column(
///        mainAxisAlignment: MainAxisAlignment.center,
///        children: [
///          Text('Error: \$error'),
///          ElevatedButton(
///            onPressed: () {
///              // Retry by resetting to the last known value
///              valueNotifier.setIdle(lastKnownValue);
///            },
///            child: Text('Retry'),
///          ),
///        ],
///      );
///    },
///  );
///  ```
///
/// In this example:
/// - The `idleBuilder` displays the current value and a button to increment it.
/// - The `loadingBuilder` shows a `CircularProgressIndicator` while loading.
/// - The `errorBuilder` displays the error message and a retry button.
class StatefulValueListenableBuilder<T> extends StatefulWidget {
  /// The [StatefulValueListenable] to listen to.
  final StatefulValueListenable<T> valueListenable;

  /// The builder function for the idle state.
  final ValueWidgetBuilder<T> idleBuilder;

  /// The builder function for the loading state.
  final ValueWidgetBuilder<T>? loadingBuilder;

  /// The builder function for the error state.
  final ErrorWidgetBuilder<T>? errorBuilder;

  /// An optional child widget that does not depend on the [valueListenable].
  final Widget? child;

  /// Creates a [StatefulValueListenableBuilder].
  ///
  /// The [valueListenable] and the builder functions are required.
  const StatefulValueListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.idleBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _StatefulValueListenableBuilderState<T>();
}

class _StatefulValueListenableBuilderState<T>
    extends State<StatefulValueListenableBuilder<T>> {
  late ValueState<T?> _valueState;

  @override
  void initState() {
    super.initState();
    _valueState = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(StatefulValueListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valueListenable != oldWidget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      _valueState = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      _valueState = widget.valueListenable.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _valueState;
    switch (state) {
      case IdleValueState(value: final value):
        return widget.idleBuilder(context, value, widget.child);
      case LoadingValueState(lastKnownValue: final lastKnownValue):
        final loadingBuilder = widget.loadingBuilder;
        return loadingBuilder == null
            ? const SizedBox.shrink()
            : loadingBuilder(context, lastKnownValue, widget.child);
      case ErrorValueState(
          error: final error,
          lastKnownValue: final lastKnownValue
        ):
        final errorBuilder = widget.errorBuilder;
        return errorBuilder == null
            ? const SizedBox.shrink()
            : errorBuilder(context, error, lastKnownValue, widget.child);
      default:
        throw StateError('Unhandled state: $state');
    }
  }
}
