import 'package:wolt_di/wolt_di.dart';

/// An abstract base class for a feature level dependency container that provides a view model.
abstract class FeatureWithViewModelDependencyContainer<VM extends WoltViewModel>
    extends FeatureLevelDependencyContainer {
  /// Creates a new view model instance.
  VM createViewModel();
}
