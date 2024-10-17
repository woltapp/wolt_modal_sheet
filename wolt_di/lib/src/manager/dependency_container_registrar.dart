import 'package:wolt_di/wolt_di.dart';

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
  ///
  /// [factory]: A factory function that returns an instance of the dependency container of type
  /// [T].
  ///
  /// **Example**:
  /// ```dart
  /// containerManager.registerContainerFactory<MyFeatureContainer>(
  ///   () => MyFeatureContainer(),
  /// );
  /// ```
  void registerContainerFactory<T>(DependencyContainerFactory factory);
}
