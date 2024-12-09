import 'package:wolt_di/src/dependency_injector.dart';

/// An abstract interface for a dependency container subscription mixin.
///
/// This serves as a marker to indicate that the implementing class
/// is capable of subscribing to updates related to a specific dependency type [C] inside the
/// [DependencyInjector] widget.
abstract interface class DependencyContainerSubscriber<C> {}
