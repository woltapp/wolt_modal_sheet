import 'package:coffee_maker_navigator_2/di/dependency_container_manager.dart';
import 'package:flutter/foundation.dart';

/// An abstract class representing a dependency container.
///
/// The `DependencyContainer` class serves as a base class for all containers
/// that manage dependencies in the Dependency Injection (DI) system. It defines
/// a common interface that all concrete dependency containers must implement.
///
/// The primary responsibility of a dependency container is to manage the lifecycle of the
/// dependencies it holds. This includes initializing and disposing of dependencies as needed.
///
/// The `dispose` method is a crucial part of this class, as it ensures that
/// resources held by the container are properly released when the container
/// is no longer needed.
abstract class DependencyContainer {
  /// Disposes of the dependencies managed by this container.
  ///
  /// This method should be implemented by concrete dependency containers to
  /// release any resources they hold. It is called when the container is no
  /// longer needed, ensuring that resources are properly cleaned up.
  void dispose();
}

/// Depenency container that should live the whole life of the application.
/// Usually it is a single container.
/// Only this container can wait for initialization,
/// because it should be done before app started.
abstract class GlobalDependencyContainer extends DependencyContainer {
  Future<void> init() async {}

  @mustCallSuper
  @override
  void dispose() {
    throw StateError(
      'This container should remain available for the life of the application and cannot be disposed.',
    );
  }
}

/// Dependency container that containts dependencies for limited area of the
/// app. This container is created by demand, and remains available while there
/// is at least one subsciber. After this it is disposed. Cannot initialize
/// asynchroniously.
abstract class LocalDependencyContainer extends DependencyContainer {
  @protected
  final IContainerResolver resolver;

  LocalDependencyContainer({required this.resolver});

  @protected
  C bindWith<C>() {
    resolver.subscribeToContainer<C>(this);
    return resolver.getDependencyContainer<C>();
  }

  @protected
  void unbindFrom<C>() {
    resolver.unsubscribeFromContainer<C>(this);
  }
}

// /// An abstract class representing a dependency container that supports
// /// asynchronous initialization.
// ///
// /// The `AsyncDependencyContainer` class extends `DependencyContainer` and adds
// /// an `init` method that returns a `Future<void>`. This allows for asynchronous
// /// initialization of dependencies.
// abstract class AsyncDependencyContainer extends DependencyContainer {
//   /// Asynchronously initializes the dependencies managed by this container.
//   ///
//   /// This method should be implemented by concrete asynchronous dependency containers
//   /// to perform any necessary asynchronous initialization. It returns a `Future<void>`
//   /// that completes when the initialization is done.
//   Future<void> init() async {}

//   @override
//   void dispose() async {}
// }

// /// An abstract class representing a dependency container that supports
// /// synchronous initialization.
// ///
// /// The `SyncDependencyContainer` class extends `DependencyContainer` and adds
// /// an `init` method that does not return a `Future`. This allows for synchronous
// /// initialization of dependencies.
// abstract class SyncDependencyContainer extends DependencyContainer {
//   /// Synchronously initializes the dependencies managed by this container.
//   ///
//   /// This method should be implemented by concrete synchronous dependency containers
//   /// to perform any necessary synchronous initialization.
//   void init() {}

//   @override
//   void dispose() {}
// }
