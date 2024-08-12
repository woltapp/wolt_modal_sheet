import 'package:coffee_maker_navigator_2/di/di.dart';
import 'package:coffee_maker_navigator_2/di/src/dependency_containers/coffee_maker_app_level_dependency_container.dart';

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
      AppLevelDependencyContainer appLevelDependencyContainer) async {
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
          'No container factory registered for type $C. Please ensure that you have registered a container factory using registerContainerFactory<$C>() before attempting to use this container type.');
    }

    // Ensure that _containerSubscribers[C] is initialized as an empty set if it's null
    if (_containerSubscribers[C] == null) {
      _containerSubscribers[C] = {};
    }
    final isSubscriptionAdded = _containerSubscribers[C]!.add(subscriber);

    if (_activeContainers[C] == null && isSubscriptionAdded) {
      _activeContainers[C] = _containerFactories[C]!(this);
    }
  }

  @override
  void unsubscribeFromContainer<C>(Object subscriber) {
    final isSubscriptionRemoved = _containerSubscribers[C] != null &&
        _containerSubscribers[C]!.remove(subscriber);
    final isSubscriberToAppLevelContainer =
        C == _appLevelDependencyContainer.runtimeType;

    if (isSubscriptionRemoved) {
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
