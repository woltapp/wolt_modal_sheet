import 'package:flutter/widgets.dart';
import 'package:wolt_di/wolt_di.dart';

mixin FeatureWithViewModelDependencyContainerSubscriptionMixin<
        C extends FeatureWithViewModelDependencyContainer,
        VM extends WoltViewModel,
        T extends StatefulWidget> on State<T>
    implements DependencyContainerSubscriber<C> {
  late DependencyInjector _injector;
  late VM _viewModel;

  VM get viewModel => _viewModel;

  @override
  void initState() {
    super.initState();
    _injector = DependencyInjector.of(context);
    _injector.subscribeToDependencyContainer<C>(this);
    _viewModel =
        DependencyInjector.container<C>(context).createViewModel() as VM;
  }

  @override
  void dispose() {
    _injector.unsubscribeFromDependencyContainer<C>(this);
    _viewModel.dispose();
    super.dispose();
  }
}
