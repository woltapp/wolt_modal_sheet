import 'package:coffee_maker_navigator_2/di/di/containers.dart';

class ContainerManager {
  static final _instance = ContainerManager._internal();

  final AppDependencies _appDependencies = AppDependencies();

  final Map<Type, DependencyContainer Function(DependencyContainer)>
      _registeredContainers = {};

  final _subscribers = <Type, Set<Object>>{};
  final _containers = <Type, DependencyContainer>{};

  /// Return single instance of [ContainerManager].
  static ContainerManager get instance => _instance;

  /// Return single instance of [ContainerManager].
  factory ContainerManager() => _instance;

  ContainerManager._internal();

  void registerDependency<T>(
      DependencyContainer Function(DependencyContainer) factory) {
    _registeredContainers[T] = factory;
  }

  void requireContainer<C>(Object subscriber) {
    final currentSubscribers = _subscribers[C] ??= {};
    currentSubscribers.add(subscriber);
    _subscribers[C] = currentSubscribers;

    _handleSubscibers<C>();
  }

  releaseContainer<C>(Object subscriber) {
    final currentSubscribers = _subscribers[C] ??= {};
    if (currentSubscribers.contains(subscriber)) {
      currentSubscribers.remove(subscriber);
      _subscribers[C] = currentSubscribers;
    }

    _handleSubscibers<C>();
  }

  C getContainer<C>() {
    return _containers[C] as C;
  }

  void _handleSubscibers<C>() {
    final currentSubscribers = _subscribers[C];
    if (currentSubscribers == null || currentSubscribers.isEmpty) {
      final currentContainer = _containers[C];
      if (currentContainer != null) {
        currentContainer.dispose();
        _containers.remove(C);
      }
    } else {
      final currentContainer = _containers[C];
      if (currentContainer == null) {
        final containerBuilder = _registeredContainers[C]!;
        _containers[C] = containerBuilder.call(_appDependencies);
      }
    }
  }
}