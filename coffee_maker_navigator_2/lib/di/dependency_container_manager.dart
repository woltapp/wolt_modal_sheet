import 'package:coffee_maker_navigator_2/di/dependency_containers/app_level_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/dependency_container.dart';

/// A typedef for the factory function responsible for creating instances
/// of dependency containers.
typedef DependencyContainerFactory = DependencyContainer Function(
    IContainerResolver);

/// A contract for classes that can register container factories.
abstract interface class IContainerRegister {
  void registerContainerFactory<T>(DependencyContainerFactory factory);
}

/// A contract for classes that can manage subscribers on containers,
/// and existence of containers.
abstract interface class IContainerResolver {
  void subscribeToContainer<C>(Object subscriber);
  void unsubscribeFromContainer<C>(Object subscriber);
  C getDependencyContainer<C>();
}

/// The `DependencyContainerManager` is a singleton class responsible for managing
/// the lifecycle of dependency containers in the application.
///
/// It initializes app-level dependencies at startup and manages feature-level
/// dependencies dynamically, creating and disposing them based on their usage.
class DependencyContainerManager implements IContainerRegister, IContainerResolver {
  static final _instance = DependencyContainerManager._internal();

  // App-level dependencies that live for the entire duration of the app.
  final AppLevelDependencyContainer _appLevelDependencyContainer =
      AppLevelDependencyContainer();

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
  Future<void> init() async {
    _registerAppLevelDependencies();
    await _appLevelDependencyContainer.init();
  }

  /// Registers a dependency container factory for a specific type [T].
  ///
  /// This method allows you to register a factory function that will be responsible
  /// for creating instances of the dependency container for the specified dependency container
  /// type [T].
  ///
  /// [factory]: A function that takes existing [AppLevelDependencyContainer] and returns
  /// a new instance of a [DependencyContainer] for the specified type [T].
  void registerContainerFactory<T>(DependencyContainerFactory factory) {
    // Ensure that the type C is explicitly provided by checking its runtime type.
    assert(T != dynamic,
        'The Container type parameter T must be explicitly provided.');
    _containerFactories[T] = factory;
  }

  /// Adds a subscriber for the container of type [C] and manages the container's lifecycle.
  ///
  /// This method registers a subscriber for the specified container type [C] and
  /// manages the lifecycle of the container based on the presence of subscribers.
  ///
  /// [subscriber]: An object that subscribes to the container of type [C]. The presence
  /// of subscribers influences the creation and destruction of the container.
  @override
  void subscribeToContainer<C>(Object subscriber) {
    final containerBuilder = _containerFactories[C];
    if (containerBuilder == null) {
      throw StateError(
          'No container factory registered for type $C. Please ensure that you have registered a container factory using registerContainerFactory<$C>() before attempting to use this container type.');
    }

    // Ensure that _containerSubscribers[C] is initialized as an empty set if it's null
    if (_containerSubscribers[C] == null) {
      _containerSubscribers[C] = {};
    }

    if (_containerSubscribers[C]!.add(subscriber)) {
      _activeContainers[C] = containerBuilder(_appLevelDependencyContainer);
    }
  }

  /// Removes a subscriber for the container of type [C] and manages the container's lifecycle.
  ///
  /// This method unregisters a subscriber for the specified container type [C] and
  /// manages the lifecycle of the container based on the remaining subscribers.
  ///
  /// [subscriber]: An object that unsubscribes from the container of type [C]. The absence
  /// of subscribers leads to the destruction of the container.
  @override
  void unsubscribeFromContainer<C>(Object subscriber) {
    final isUnsubscribed = _containerSubscribers[C] != null &&
        _containerSubscribers[C]!.remove(subscriber);

    if (isUnsubscribed) {
      final hasRemainingSubscribers = _containerSubscribers[C]!.isEmpty;
      // Dispose the container and remove it from the active list if there is no subscriber left.
      if (!hasRemainingSubscribers && _activeContainers[C] != null) {
        _activeContainers[C]!.dispose();
        _activeContainers.remove(C);
      }
    }
  }

  /// Retrieves the container of type [C].
  ///
  /// This method returns the active container of the specified type [C]. If the container
  /// does not exist, an error is thrown.
  ///
  /// Throws [StateError] if the container of type [C] does not exist.
  ///
  /// Returns an instance of the container of type [C].
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
