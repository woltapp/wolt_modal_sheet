import 'package:coffee_maker_navigator_2/features/add_water/di/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_back_button.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_content.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_footer.dart';
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
          child: Stack(
            children: [
              AddWaterScreenContent(
                onWaterQuantityUpdated: _viewModel.onWaterQuantityUpdated,
                onWaterSourceUpdated: _viewModel.onWaterSourceUpdated,
                onWaterTemperatureUpdated: _viewModel.onWaterTemperatureUpdated,
              ),
              const AddWaterScreenBackButton(),
              AddWaterScreenFooter(
                _viewModel.isReadyToAddWater,
                _viewModel.errorMessage,
                _viewModel.onCheckValidityPressed,
                _viewModel.onAddWaterPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
