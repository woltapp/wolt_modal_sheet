import 'package:coffee_maker_navigator_2/di/src/framework/dependency_injector.dart';
import 'package:flutter/widgets.dart';

/// A mixin that subscribes the state of the `StatefulWidget` to a dependency container and manages
/// its lifecycle.
///
/// This mixin automatically subscribes the stateful widget to a container of type [C] when the
/// widget is initialized, and unsubscribes from the container when the widget is disposed. This
/// ensures that the container remains active as long as the widget is part of the widget tree
/// and is
/// disposed of properly when the widget is removed.
///
/// This mixin should be used with `State` classes of `StatefulWidget` to manage
/// their dependency containers seamlessly.
mixin DependencyContainerSubscriptionMixin<C, T extends StatefulWidget>
    on State<T> {
  late DependencyInjector _injector;

  @override
  void initState() {
    super.initState();
    _injector = DependencyInjector.of(context);
    _injector.subscribeToDependencyContainer<C>(this);
  }

  @override
  void dispose() {
    // Use the stored Injector reference to unsubscribe. This avoids accessing context in an
    // unstable state during widget disposal.
    _injector.unsubscribeFromDependencyContainer<C>(this);
    super.dispose();
  }
}
