import 'package:coffee_maker_navigator_2/di/di.dart';
import 'package:flutter/widgets.dart';

/// A widget that proxies requests to [DependencyContainerResolver].
///
/// The [DependencyContainerInjector] widget is an [InheritedWidget] that holds a reference to
/// the [DependencyContainerResolver]. It ensures that the DI system is accessible
/// from anywhere within the widget tree.
///
/// This widget is used to inject the [DependencyContainerResolver] into the widget
/// tree, making it possible to obtain and manage dependency containers from any
/// descendant widget.
class DependencyContainerInjector extends InheritedWidget {
  /// The [DependencyContainerResolver] that manages access to dependency containers,
  /// including subscribing to, unsubscribing from, and resolving container instances.
  final DependencyContainerResolver _dependencyContainerResolver;

  /// Creates an [DependencyContainerInjector] widget.
  ///
  /// [key]: An optional key for the widget.
  /// [child]: The child widget which will have access to the DI system.
  /// [dependencyContainerResolver]: The [DependencyContainerResolver] instance to be provided.
  const DependencyContainerInjector({
    Key? key,
    required Widget child,
    required DependencyContainerResolver dependencyContainerResolver,
  })  : _dependencyContainerResolver = dependencyContainerResolver,
        super(key: key, child: child);

  /// Retrieves the [DependencyContainerInjector] from the given `BuildContext`.
  ///
  /// This method allows any descendant widget to access the [DependencyContainerResolver]
  /// by calling `Injector.of(context)`.
  ///
  /// [context]: The `BuildContext` from which to retrieve the [DependencyContainerResolver].
  ///
  /// Returns the nearest `Injector` widget.
  static DependencyContainerInjector of(BuildContext context) {
    final DependencyContainerInjector? injector =
        context.getInheritedWidgetOfExactType<DependencyContainerInjector>();
    assert(injector != null, 'No Injector found in context');
    return injector!;
  }

  /// Retrieves the container of type [C].
  ///
  /// This method allows any widget to access the active container of the specified type [C].
  ///
  /// Returns an instance of the container of type [C].
  static C container<C>(BuildContext context) {
    return DependencyContainerInjector.of(context)._getDependencyContainer<C>();
  }

  /// Subscribes a given object to a container of type [C].
  ///
  /// This method adds the subscriber to the container, ensuring that the container
  /// remains active as long as there are subscribers.
  ///
  /// [subscriber]: The [DependencyContainerSubscriber] mixin subscribing to the container.
  void subscribeToDependencyContainer<C>(
      DependencyContainerSubscriber subscriber) {
    _dependencyContainerResolver.subscribeToContainer<C>(subscriber);
  }

  /// Unsubscribes a given object from a container of type [C].
  ///
  /// This method removes the subscriber from the container, and if there are no
  /// more subscribers, the container may be disposed of.
  ///
  /// [subscriber]:  The [DependencyContainerSubscriber] mixin unsubscribing from the container.
  void unsubscribeFromDependencyContainer<C>(
      DependencyContainerSubscriber subscriber) {
    _dependencyContainerResolver.unsubscribeFromContainer<C>(subscriber);
  }

  /// Retrieves the container of type [C].
  ///
  /// This method allows any widget to access the active container of the specified type [C].
  ///
  /// Returns an instance of the container of type [C].
  C _getDependencyContainer<C>() {
    return _dependencyContainerResolver.getDependencyContainer<C>();
  }

  /// Determines whether the widget should notify its dependents when the widget's state changes.
  ///
  /// Since the `Injector` widget does not have any mutable state, this method always returns `false`.
  @override
  bool updateShouldNotify(DependencyContainerInjector oldWidget) {
    return false;
  }
}
