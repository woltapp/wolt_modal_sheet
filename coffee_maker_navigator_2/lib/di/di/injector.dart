import 'package:coffee_maker_navigator_2/di/di/dependency_container_manager.dart';
import 'package:coffee_maker_navigator_2/di/di/dependency_container_subscriber.dart';
import 'package:flutter/widgets.dart';

/// A widget that provides access to the `DependencyContainerManager` throughout the widget tree.
///
/// The `Injector` widget is an `InheritedWidget` that holds a reference to the
/// `DependencyContainerManager`. It ensures that the DI system is accessible
/// from anywhere within the widget tree, facilitating the resolution and
/// management of dependencies.
///
/// This widget is used to inject the `DependencyContainerManager` into the widget
/// tree, making it possible to obtain and manage dependency containers from any
/// descendant widget.
class Injector extends InheritedWidget {
  /// The `DependencyContainerManager` that manages the lifecycle of dependency containers.
  final DependencyContainerManager containerManager;

  /// Creates an `Injector` widget.
  ///
  /// [key]: An optional key for the widget.
  /// [child]: The child widget which will have access to the DI system.
  /// [containerManager]: The `DependencyContainerManager` instance to be provided.
  const Injector({
    Key? key,
    required Widget child,
    required this.containerManager,
  }) : super(key: key, child: child);

  /// Retrieves the `DependencyContainerManager` from the given `BuildContext`.
  ///
  /// This method allows any descendant widget to access the `DependencyContainerManager`
  /// by calling `Injector.of(context)`.
  ///
  /// [context]: The `BuildContext` from which to retrieve the `DependencyContainerManager`.
  ///
  /// Returns the `DependencyContainerManager` instance provided by the nearest `Injector` widget.
  static DependencyContainerManager of(BuildContext context) {
    final Injector? injector =
        context.getInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'No Injector found in context');
    return injector!.containerManager;
  }

  /// Subscribes a given object to a container of type [C].
  ///
  /// This method adds the subscriber to the container, ensuring that the container
  /// remains active as long as there are subscribers.
  ///
  /// [subscriber]: The object subscribing to the container.
  void subscribeToContainer<C>(DependencyContainerSubscriber subscriber) {
    containerManager.subscribeToContainer<C>(subscriber);
  }

  /// Unsubscribes a given object from a container of type [C].
  ///
  /// This method removes the subscriber from the container, and if there are no
  /// more subscribers, the container may be disposed of.
  ///
  /// [subscriber]: The object unsubscribing from the container.
  void unsubscribeFromContainer<C>(DependencyContainerSubscriber subscriber) {
    containerManager.unsubscribeFromContainer<C>(subscriber);
  }

  /// Retrieves the container of type [C].
  ///
  /// This method allows any widget to access the active container of the specified type [C].
  ///
  /// Returns an instance of the container of type [C].
  C getContainer<C>() {
    return containerManager.getContainer<C>();
  }

  /// Determines whether the widget should notify its dependents when the widget's state changes.
  ///
  /// Since the `Injector` widget does not have any mutable state, this method always returns `false`.
  @override
  bool updateShouldNotify(Injector oldWidget) {
    return false;
  }
}
