import 'package:coffee_maker_navigator_2/di/di.dart';

/// A typedef for the factory function responsible for creating instances
/// of dependency containers.
typedef DependencyContainerFactory = DependencyContainer Function(
  DependencyContainerResolver,
);

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
