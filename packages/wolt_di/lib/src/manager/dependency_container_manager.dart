import 'package:wolt_di/wolt_di.dart';

/// A typedef for the factory function responsible for creating instances
/// of dependency containers.
typedef DependencyContainerFactory = DependencyContainer Function();

/// A contract for registering dependency container factories.
///
/// The [DependencyContainerRegistrar] interface defines the methods required for
/// registering factory functions that create instances of dependency containers.
/// Implementations of this interface manage the registration process, ensuring
/// that the correct factory functions are associated with the appropriate container types.
///
/// [DependencyContainerManager] is typically the only class that implements this interface.
abstract interface class DependencyContainerRegistrar {
  /// Registers a factory function for a specific dependency container type [T].
  ///
  /// This method allows registering a factory function that will be responsible
  /// for creating instances of the dependency container for the specified type [T].
  /// The registered factory function should take a [DependencyContainerResolver] as a
  /// parameter and return an instance of the container type [T].
  ///
  /// [factory]: A factory function that takes a [DependencyContainerResolver] and returns
  /// an instance of the dependency container of type [T].
  ///
  /// **Example**:
  /// ```dart
  /// containerManager.registerContainerFactory<MyFeatureContainer>(
  ///   (manager) => MyFeatureContainer(manager),
  /// );
  /// ```
  void registerContainerFactory<T>(DependencyContainerFactory factory);
}

/// A contract for managing access to dependency containers, including subscribing to,
/// unsubscribing from, and resolving container instances.
///
/// Implementations of this interface are responsible for adding and removing the subscription of
/// objects to containers, as well as resolving and providing active instances of
/// those containers.
///
/// This interface ensures that dependency containers are accessible, created, and
/// disposed of based on their usage within the application, promoting efficient
/// resource management and modular design.
abstract interface class DependencyContainerResolver {
  /// Subscribes an object to a dependency container of type [C].
  ///
  /// This method registers an object as a subscriber to the specified container type [C],
  /// ensuring that the container is instantiated and available for use. If no container
  /// instance of type [C] exists when a subscription is made, this method will create
  /// the container using the associated factory function. Otherwise, the existing container will
  /// be used, and the subscriber will be added to the list of subscribers for that container.
  ///
  /// [subscriber]: The object that subscribes to the container of type [C].
  ///
  /// **Example**:
  /// ```dart
  /// containerManager.subscribeToContainer<MyFeatureContainer>(this);
  /// ```
  void subscribeToContainer<C>(Object subscriber);

  /// Unsubscribes an object from a dependency container of type [C], managing its access.
  ///
  /// This method removes a subscriber from the specified container type [C]. If there are
  /// no remaining subscribers for the container after this operation, the container will
  /// be disposed of, releasing any resources it holds.
  ///
  /// [subscriber]: The object that unsubscribes from the container of type [C].
  ///
  /// **Example**:
  /// ```dart
  /// containerManager.unsubscribeFromContainer<MyFeatureContainer>(this);
  /// ```
  void unsubscribeFromContainer<C>(Object subscriber);

  /// Retrieves the active instance of a dependency container of type [C].
  ///
  /// This method returns the currently active container of the specified type [C]. If the
  /// container does not exist or has not been instantiated (since it has not been subscribed to)
  /// an error is thrown. Ensure that the container type [C] has been correctly registered with
  /// a factory function and has at least one active subscriber before calling this method.
  ///
  /// Throws [StateError] if the container of type [C] does not exist.
  ///
  /// **Example**:
  /// ```dart
  /// final myFeatureContainer = containerManager.getDependencyContainer<MyFeatureContainer>();
  /// ```
  C getDependencyContainer<C>();
}

/// The `DependencyContainerManager` is a singleton class responsible for managing
/// the lifecycle of dependency containers in the application.
///
/// It initializes app-level dependencies at startup and manages feature-level
/// dependencies dynamically, creating and disposing them based on their usage.
class DependencyContainerManager
    implements DependencyContainerResolver, DependencyContainerRegistrar {
  static final _instance = DependencyContainerManager._internal();

  // App-level dependencies that live for the entire duration of the app.
  late AppLevelDependencyContainer _appLevelDependencyContainer;

  // A map that registers container factories by their type.
  //
  // This map holds factory functions that are responsible for creating instances
  // of dependency containers. Each entry in the map associates a type [T] with a
  // factory function that produces a [DependencyContainer] of that type.
  //
  // The key is the type of the dependency container, and the value is a function
  // that takes an existing [AppLevelDependencies] and returns a new instance of a
  // [DependencyContainer] for the specified type [T].
  final _containerFactories = <Type, DependencyContainerFactory>{};

  // A map that tracks the subscribers for each container type.
  final _containerSubscribers = <Type, Set<Object>>{};

  // A map that holds the currently active containers by their type.
  // An active container is one that is currently in use, meaning it has at least one subscriber.
  final _activeContainers = <Type, DependencyContainer>{};

  /// Returns the single instance of [DependencyContainerManager].
  static DependencyContainerManager get instance => _instance;

  /// Internal constructor for singleton implementation.
  DependencyContainerManager._internal();

  /// Initializes the app-level dependencies.
  Future<void> init(
    AppLevelDependencyContainer appLevelDependencyContainer,
  ) async {
    _appLevelDependencyContainer = appLevelDependencyContainer;
    _registerAppLevelDependencies();
    await _appLevelDependencyContainer.init();
  }

  @override
  void registerContainerFactory<T>(DependencyContainerFactory factory) {
    // Ensure that the type C is explicitly provided by checking its runtime type.
    assert(T != dynamic,
        'The Container type parameter T must be explicitly provided.');
    _containerFactories[T] = factory;
  }

  @override
  void subscribeToContainer<C>(Object subscriber) {
    final isSubscribingToAppLevelContainer =
        C == _appLevelDependencyContainer.runtimeType;

    // Ensure that the container factory is registered for the specified type. Note that
    // AppLevelDependencyContainer is not registered as a factory since it is a singleton and
    // created when the container manager is created.
    if (!isSubscribingToAppLevelContainer && _containerFactories[C] == null) {
      throw StateError(
        'No container factory registered for type $C. Please ensure that you have registered a container factory using registerContainerFactory<$C>() before attempting to use this container type.',
      );
    }

    // Ensure that _containerSubscribers[C] is initialized as an empty set if it's null
    if (_containerSubscribers[C] == null) {
      _containerSubscribers[C] = {};
    }
    final isSubscriptionAdded = _containerSubscribers[C]!.add(subscriber);

    if (_activeContainers[C] == null && isSubscriptionAdded) {
      _activeContainers[C] = _containerFactories[C]!();
    }
  }

  @override
  void unsubscribeFromContainer<C>(Object subscriber) {
    final isSubscriptionRemoved = _containerSubscribers[C] != null &&
        _containerSubscribers[C]!.remove(subscriber);

    if (isSubscriptionRemoved) {
      final isSubscriberToAppLevelContainer =
          C == _appLevelDependencyContainer.runtimeType;
      final hasRemainingSubscribers = _containerSubscribers[C]!.isEmpty;
      // Dispose the container and remove it from the active list if there is no subscriber left.
      if (!hasRemainingSubscribers &&
          _activeContainers[C] != null &&
          !isSubscriberToAppLevelContainer) {
        (_activeContainers[C] as FeatureLevelDependencyContainer).dispose();
        _activeContainers.remove(C);
      }
    }
  }

  @override
  C getDependencyContainer<C>() {
    final container = _activeContainers[C];
    if (container == null) {
      throw StateError('''
Container of type $C does not exist. Ensure that the container type has been correctly registered
 with a factory function and that there is at least one active subscriber. If not already done, 
 consider registering a factory for this container type and adding a subscriber to activate its 
 instantiation.
''');
    }
    return container as C;
  }

  void _registerAppLevelDependencies() {
    final type = _appLevelDependencyContainer.runtimeType;
    _containerSubscribers[type] = {this};
    _activeContainers[type] = _appLevelDependencyContainer;
  }
}
