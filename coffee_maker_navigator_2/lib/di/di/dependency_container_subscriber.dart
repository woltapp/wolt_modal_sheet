import 'package:coffee_maker_navigator_2/di/di/injector.dart';
import 'package:flutter/widgets.dart';

/// A mixin that subscribes a `StatefulWidget` to a dependency container and manages its lifecycle.
///
/// This mixin automatically subscribes the widget to a container of type [C] when the widget is
/// initialized, and unsubscribes from the container when the widget is disposed. This ensures
/// that the container remains active as long as the widget is part of the widget tree and is
/// disposed of properly when the widget is removed.
///
/// This mixin should be used with `State` classes of `StatefulWidget` to manage
/// their dependency containers seamlessly.
mixin DependencyContainerSubscriber<C, T extends StatefulWidget> on State<T> {
  /// Subscribes the widget to the container of type [C] when the widget state is initialized.
  @override
  void initState() {
    super.initState();
    Injector.of(context).subscribeToContainer<C>(this);
  }

  /// Unsubscribes the widget from the container of type [C] when the widget is disposed.
  @override
  void dispose() {
    Injector.of(context).unsubscribeFromContainer<C>(this);
    super.dispose();
  }
}
