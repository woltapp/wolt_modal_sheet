import 'package:coffee_maker_navigator_2/features/add_water/di/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_content.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_step_order_not_found.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view_model/add_water_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_di/wolt_di.dart';

class AddWaterScreen extends StatefulWidget {
  const AddWaterScreen({super.key, required this.coffeeOrderId});

  final String coffeeOrderId;

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen>
    with
        DependencyContainerSubscriptionMixin<AddWaterDependencyContainer,
            AddWaterScreen> {
  late AddWaterViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final dependencyContainer =
        DependencyInjector.container<AddWaterDependencyContainer>(context);
    _viewModel = dependencyContainer.createViewModel()
      ..onInit(widget.coffeeOrderId);
  }

  @override
  void didUpdateWidget(covariant AddWaterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coffeeOrderId != widget.coffeeOrderId) {
      _viewModel.onInit(widget.coffeeOrderId);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemUIAnnotationWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
          child: _viewModel.orderExists
              ? AddWaterScreenContent(
                  onWaterQuantityUpdated: _viewModel.onWaterQuantityUpdated,
                  onWaterTemperatureUpdated:
                      _viewModel.onWaterTemperatureUpdated,
                  onWaterSourceUpdated: _viewModel.onWaterSourceUpdated,
                  isReadyToAddWater: _viewModel.isReadyToAddWater,
                  errorMessage: _viewModel.errorMessage,
                  onCheckValidityPressed: _viewModel.onCheckValidityPressed,
                  onAddWaterPressed: _viewModel.onAddWaterPressed,
                )
              : const AddWaterStepOrderNotFound(),
        ),
      ),
    );
  }
}
