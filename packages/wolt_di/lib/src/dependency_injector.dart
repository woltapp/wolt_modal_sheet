import 'package:flutter/widgets.dart';
import 'package:wolt_di/src/manager/dependency_container_manager.dart';
import 'package:wolt_di/wolt_di.dart';

/// A widget that proxies requests to [DependencyContainerResolver].
///
/// The [DependencyInjector] widget is an [InheritedWidget] that holds a reference to
/// the [DependencyContainerResolver]. It ensures that the DI system is accessible
/// from anywhere within the widget tree.
///
/// This widget is used to inject the [DependencyContainerResolver] into the widget
/// tree, making it possible to obtain and manage dependency containers from any
/// descendant widget.
class DependencyInjector extends InheritedWidget {
  /// The [DependencyContainerResolver] that manages access to dependency containers,
  /// including subscribing to, unsubscribing from, and resolving container instances.
  final DependencyContainerResolver _resolver;

  /// Creates an [DependencyInjector] widget.
  ///
  /// [key]: An optional key for the widget.
  /// [child]: The child widget which will have access to the DI system.
  /// [dependencyContainerResolver]: The [DependencyContainerResolver] instance to be provided.
  DependencyInjector({Key? key, required Widget child})
      : _resolver = DependencyContainerManager.instance,
        super(key: key, child: child);

  /// Retrieves the [DependencyInjector] from the given `BuildContext`.
  ///
  /// This method allows any descendant widget to access the [DependencyContainerResolver]
  /// by calling `Injector.of(context)`.
  ///
  /// [context]: The `BuildContext` from which to retrieve the [DependencyContainerResolver].
  ///
  /// Returns the nearest `Injector` widget.
  static DependencyInjector of(BuildContext context) {
    final DependencyInjector? injector =
        context.getInheritedWidgetOfExactType<DependencyInjector>();
    assert(injector != null, 'No Injector found in context');
    return injector!;
  }

  /// Retrieves the container of type [C].
  ///
  /// This method allows any widget to access the active container of the specified type [C].
  ///
  /// This method returns the currently active container of the specified type [C]. If the
  /// container does not exist or has not been instantiated (since it has not been subscribed to)
  /// an error is thrown. Ensure that the container type [C] has been correctly registered with
  /// a factory function and has at least one active subscriber before calling this method.
  ///
  /// Returns an instance of the container of type [C].
  static C container<C>(BuildContext context) {
    return DependencyInjector.of(context)._getDependencyContainer();
  }

  /// Subscribes a given object to a container of type [C].
  ///
  /// This method adds the subscriber to the container, ensuring that the container
  /// remains active as long as there are subscribers.
  ///
  /// [subscriber]: The [DependencyContainerSubscriber] mixin subscribing to the container.
  void subscribeToDependencyContainer<C>(
    DependencyContainerSubscriber subscriber,
  ) {
    _resolver.subscribeToContainer<C>(subscriber);
  }

  /// Unsubscribes a given object from a container of type [C].
  ///
  /// This method removes the subscriber from the container, and if there are no
  /// more subscribers, the container may be disposed of.
  ///
  /// [subscriber]:  The [DependencyContainerSubscriber] mixin unsubscribing from the container.
  void unsubscribeFromDependencyContainer<C>(
    DependencyContainerSubscriber subscriber,
  ) {
    _resolver.unsubscribeFromContainer<C>(subscriber);
  }

  C _getDependencyContainer<C>() {
    return _resolver.getDependencyContainer();
  }

  /// Determines whether the widget should notify its dependents when the widget's state changes.
  ///
  /// Since the `Injector` widget does not have any mutable state, this method always returns `false`.
  @override
  bool updateShouldNotify(DependencyInjector oldWidget) {
    return false;
  }
}
