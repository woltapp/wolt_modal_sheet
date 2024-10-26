import 'package:flutter/widgets.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

/// A builder function that builds a widget based on the provided value.
///
/// Used in [StatefulValueListenableBuilder.idleBuilder] and [StatefulValueListenableBuilder.loadingBuilder].
typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T? value);

/// A builder function that builds a widget based on the provided error and last known value.
///
/// Used in [StatefulValueListenableBuilder.errorBuilder].
typedef ErrorWidgetBuilder<T> = Widget Function(
  BuildContext context,
  Object? error,
  T? value,
);

/// A widget that builds itself based on the latest value of a [StatefulValueListenable].
///
/// It rebuilds whenever the [valueListenable] notifies its listeners.
///
/// **Usage Example**:
///
/// ```dart
/// // Create a StatefulValueNotifier with an initial value
/// final valueNotifier = StatefulValueNotifier<int>(0);
///
/// // Use the StatefulValueListenableBuilder in your widget tree
/// StatefulValueListenableBuilder<int>(
///   valueListenable: valueNotifier,
///   idleBuilder: (context, value) {
///     return Column(
///       mainAxisAlignment: MainAxisAlignment.center,
///       children: [
///         Text('Idle State. Value: $value'),
///         ElevatedButton(
///           onPressed: () {
///             // Transition to loading state
///             valueNotifier.setLoading();
///             // Simulate a data fetch or processing delay
///             Future.delayed(Duration(seconds: 2), () {
///               // Update to a new idle state with an incremented value
///               valueNotifier.setIdle(value: (value ?? 0) + 1);
///             });
///           },
///         ),
///       ],
///     );
///   },
///   loadingBuilder: (context, value) {
///     return Center(
///       child: CircularProgressIndicator(),
///     );
///   },
///   errorBuilder: (context, error, value) {
///     return Column(
///       mainAxisAlignment: MainAxisAlignment.center,
///       children: [
///         Text('Error: $error'),
///         ElevatedButton(
///           onPressed: () {
///             // Retry by resetting to the last known value
///             valueNotifier.setIdle();
///           },
///           child: Text('Retry'),
///         ),
///       ],
///     );
///   },
/// );
/// ```
class StatefulValueListenableBuilder<T> extends StatefulWidget {
  /// The [StatefulValueListenable] to listen to.
  final StatefulValueListenable<T> valueListenable;

  /// The builder function for the idle state.
  final ValueWidgetBuilder<T> idleBuilder;

  /// The builder function for the loading state.
  final ValueWidgetBuilder<T>? loadingBuilder;

  /// The builder function for the error state.
  final ErrorWidgetBuilder<T>? errorBuilder;

  /// Creates a [StatefulValueListenableBuilder].
  ///
  /// The [valueListenable] and the [idleBuilder] are required.
  const StatefulValueListenableBuilder({
    super.key,
    required this.valueListenable,
    required this.idleBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  State<StatefulWidget> createState() => _StatefulValueListenableBuilderState<T>();
}

class _StatefulValueListenableBuilderState<T> extends State<StatefulValueListenableBuilder<T>> {
  late ValueState<T> _valueState;
  late StatefulValueListenable<T> _valueListenable;

  @override
  void initState() {
    super.initState();
    _valueListenable = widget.valueListenable;
    _valueState = _valueListenable.value;
    _valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(StatefulValueListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valueListenable != oldWidget.valueListenable) {
      _valueListenable.removeListener(_valueChanged);
      _valueListenable = widget.valueListenable;
      _valueState = _valueListenable.value;
      _valueListenable.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    _valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _valueState;

    return switch (state) {
      IdleValueState<T>(:final value) => widget.idleBuilder(context, value),
      LoadingValueState<T>(:final value) =>
        widget.loadingBuilder?.call(context, value) ?? const SizedBox.shrink(),
      ErrorValueState<T>(:final error, :final value) =>
        widget.errorBuilder?.call(context, error, value) ?? const SizedBox.shrink(),
    };
  }

  void _valueChanged() {
    setState(() {
      _valueState = _valueListenable.value;
    });
  }
}
