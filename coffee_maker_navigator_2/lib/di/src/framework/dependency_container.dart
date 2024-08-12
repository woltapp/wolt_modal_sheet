import 'package:coffee_maker_navigator_2/di/di.dart';
import 'package:coffee_maker_navigator_2/di/src/framework/manager/dependency_container_manager.dart';
import 'package:flutter/foundation.dart';

/// An abstract base class representing a dependency container in the Dependency Injection (DI)
/// system.
///
/// Dependency containers encapsulate the details of how dependencies are created and disposed.
/// A container can be subscribed to or unsubscribed from other containers, allowing for the use
/// of interdependent dependencies.
///
/// The lifecycle of the containers are managed by the [DependencyContainerManager] which ensures
/// that containers are only alive when there are subscribers that need their dependencies.
///
/// Example:
/// ```dart
/// class MyDependencyContainer extends DependencyContainer {
///   @override
///   void dispose() {
///     // Clean up resources or dependencies here.
///     someDependency.dispose();
///   }
/// }
/// ```
abstract class DependencyContainer {}

/// An abstract class representing the dependency container for app-level dependencies.
///
/// The `AppLevelDependencyContainer` is responsible for initializing and managing
/// dependencies that are required throughout the entire lifecycle of the application.
/// These dependencies are typically global in nature and are essential for the
/// core functionality of the app, such as services, configurations, and other
/// foundational components that need to be available as long as the application
/// is running.
///
/// This class extends the `DependencyContainer` base class and defines the contract
/// for initializing app-level dependencies. Concrete implementations of this class
/// should provide the necessary logic to initialize these dependencies.
///
/// Example:
/// ```dart
/// class MyAppLevelDependencyContainer extends AppLevelDependencyContainer {
///   @override
///   Future<void> init() async {
///     // Initialize global services or configurations here.
///     await someService.initialize();
///     await anotherService.loadConfiguration();
///   }
/// }
/// ```
///
/// **Usage**:
/// - This container is typically created and initialized at the application startup.
/// - It should be the first container to be initialized, as other containers might
///   depend on the services or configurations it provides.
abstract class AppLevelDependencyContainer extends DependencyContainer {
  /// Initializes the app-level dependencies managed by this container.
  ///
  /// This method is intended to be overridden by subclasses to set up the necessary
  /// global dependencies that the application will need throughout its lifecycle.
  /// This could include initializing services, loading configurations, establishing
  /// connections, or any other global setup tasks.
  ///
  /// The `init` method is asynchronous and should be called as part of the application
  /// initialization process, typically before any other dependency containers are created or used.
  ///
  /// Example:
  /// ```dart
  /// class MyAppLevelDependencyContainer extends AppLevelDependencyContainer {
  ///   @override
  ///   Future<void> init() async {
  ///     // Initialize global services or configurations here.
  ///     await someService.initialize();
  ///     await anotherService.loadConfiguration();
  ///   }
  /// }
  /// ```
  ///
  /// **Important**:
  /// - Subclasses must implement this method to provide the necessary initialization logic.
  /// - Ensure that all essential services and dependencies are fully initialized before
  ///   completing this method, as other parts of the application might depend on them.
  ///
  /// Returns a [Future] that completes once all app-level dependencies have been
  /// successfully initialized.
  Future<void> init();
}

/// An abstract base class for managing feature-level dependency containers within the application.
///
/// The `FeatureLevelDependencyContainer` is designed to handle dependencies that are specific
/// to a particular feature or a set of related features. It extends the `DependencyContainer`
/// class, leveraging the `DependencyContainerManager` to manage the lifecycle of these dependencies
/// dynamically, based on their usage and the presence of subscribers.
///
/// This class provides methods to bind to other dependency containers which allows accessing
/// dependencies from other containers when needed.
///
/// Example:
/// ```dart
/// class MyFeatureDependencyContainer extends FeatureLevelDependencyContainer {
///   MyFeatureDependencyContainer(DependencyContainerManager manager)
///       : super(dependencyContainerManager: manager);
///
///   void initDependencies() {
///     final someDependency = bindWith<SomeOtherDependencyContainer>();
///     // Use `someDependency` to set up this feature's dependencies
///   }
///
///   void disposeDependencies() {
///     unbindFrom<SomeOtherDependencyContainer>();
///   }
/// }
/// ```
abstract class FeatureLevelDependencyContainer extends DependencyContainer {
  /// The manager responsible for handling the lifecycle of dependency containers
  /// within the application.
  ///
  /// This instance is provided via the constructor and is used to manage
  /// subscriptions to other containers, ensuring that feature-level dependencies
  /// are created and disposed of in accordance with the application's needs.
  @protected
  final DependencyContainerAccessHandler dependencyContainerAccessHandler;

  /// Constructor for `FeatureLevelDependencyContainer`.
  ///
  /// Requires an instance of `DependencyContainerManager` to manage the feature's
  /// dependencies dynamically.
  ///
  /// [dependencyContainerManager]: The `DependencyContainerManager` that will manage
  /// the lifecycle of this feature-level container's dependencies.
  FeatureLevelDependencyContainer(
      {required this.dependencyContainerAccessHandler});

  /// Binds this container to another specified dependency container type [C].
  ///
  /// This method subscribes this feature-level container to the dependency container
  /// of type [C], ensuring that the required dependencies for the feature are
  /// instantiated and available for use.
  ///
  /// The container of type [C] must have been previously registered in the
  /// `DependencyContainerManager` with a corresponding factory function.
  ///
  /// Returns an instance of the dependency container of type [C] after successfully
  /// binding to it.
  ///
  /// Example:
  /// ```dart
  /// final otherContainer = bindWith<OtherDependencyContainer>();
  /// ```
  @protected
  C bindWith<C extends DependencyContainer>() {
    dependencyContainerAccessHandler.subscribeToContainer<C>(this);
    return dependencyContainerAccessHandler.getDependencyContainer<C>();
  }

  /// Unbinds this container from the specified dependency container type [C].
  ///
  /// This method unsubscribes this feature-level container from the dependency container
  /// of type [C], allowing for the clean-up and disposal of the dependencies managed
  /// by that container if there are no remaining subscribers.
  ///
  /// This is typically called during the teardown or disposal of the feature-level
  /// container to ensure that resources are properly released.
  ///
  /// Example:
  /// ```dart
  /// unbindFrom<OtherDependencyContainer>();
  /// ```
  @protected
  void unbindFrom<C extends DependencyContainer>() {
    dependencyContainerAccessHandler.unsubscribeFromContainer<C>(this);
  }

  /// Disposes the dependencies managed by this container.
  ///
  /// This method should be implemented by concrete dependency containers to release
  /// any resources they hold. It is called by the [DependencyContainerManager] when the container
  /// is no longer needed, typically when there are no more subscribers for the container.
  ///
  /// Implementers should ensure that all managed resources, such as open connections,
  /// event listeners, or other allocated objects, are properly cleaned up in this method.
  ///
  /// **Do not call this method directly** from outside the container. The
  /// `DependencyContainerManager` is responsible for determining when a container
  /// should be disposed of and will invoke this method as needed.
  void dispose();
}
