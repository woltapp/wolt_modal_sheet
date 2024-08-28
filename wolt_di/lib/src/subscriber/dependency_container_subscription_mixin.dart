import 'package:flutter/widgets.dart';
import 'package:wolt_di/wolt_di.dart';

/// A mixin that manages subscription to a dependency container within
/// a widget's state, making it possible for the state to respond to
/// changes in dependencies managed by the [DependencyInjector].
///
/// It is meant to be used with state classes of [StatefulWidget]s.
///
/// Generic parameters:
/// - [C] - The type of the dependency that the subscriber is interested in.
/// - [T] - The type of [StatefulWidget] that this state belongs to.
///
/// Implements [DependencyContainerSubscriber<C>] to indicate that
/// this mixin is a subscriber for dependencies of type [C].
mixin DependencyContainerSubscriptionMixin<C, T extends StatefulWidget>
    on State<T> implements DependencyContainerSubscriber<C> {
  /// The instance of [DependencyInjector] used to manage and subscribe
  /// to dependencies. It will be initialized when subscribing.
  late DependencyInjector _injector;

  /// Subscribes this state object to the dependency container for type [C].
  ///
  /// It obtains the [DependencyInjector] instance from the current widget's
  /// context and subscribes the state object to updates for dependencies of
  /// type [C]. This ensures that the state object will receive updates when
  /// the dependency changes.
  void subscribeToDependencyContainer() {
    // Retrieve the DependencyInjector instance from the widget's context.
    _injector = DependencyInjector.of(context);

    // Subscribe to updates for dependencies of type [C].
    _injector.subscribeToDependencyContainer<C>(this);
  }

  /// Unsubscribes this state object from the dependency container for type [C].
  ///
  /// It calls the unsubscribe method on the [DependencyInjector], ensuring
  /// that the state object no longer receives updates for dependencies of
  /// type [C]. This is important for preventing memory leaks and unnecessary
  /// updates after the state object has been disposed of.
  void unsubscribeFromDependencyContainer() {
    // Unsubscribe from updates for dependencies of type [C].
    _injector.unsubscribeFromDependencyContainer<C>(this);
  }

  /// Initializes the state object.
  ///
  /// This is called when the state object is created. It is overridden to
  /// include the subscription logic, ensuring that the state object starts
  /// receiving updates from the dependency container as soon as it is initialized.
  @override
  void initState() {
    super.initState();

    // Begin subscription to the dependency container.
    subscribeToDependencyContainer();
  }

  /// Disposes of the state object.
  ///
  /// This is called when the state object is removed from the widget tree.
  /// It is overridden to include the unsubscription logic, which helps in
  /// cleaning up resources and preventing memory leaks by unsubscribing from
  /// the dependency container.
  @override
  void dispose() {
    // End subscription to the dependency container.
    unsubscribeFromDependencyContainer();
    super.dispose();
  }
}
