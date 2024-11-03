import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_back_button.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_body.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_footer.dart';
import 'package:flutter/material.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

class AddWaterScreenContent extends StatelessWidget {
  const AddWaterScreenContent({
    super.key,
    required this.waterQuantity,
    required this.waterTemperature,
    required this.waterSource,
    required this.onWaterQuantityUpdated,
    required this.onWaterTemperatureUpdated,
    required this.onWaterSourceUpdated,
    required this.isReadyToAddWater,
    required this.errorMessage,
    required this.onCheckValidity,
    required this.onAddWater,
    required this.onStepCompleted,
  });

  final StatefulValueListenable<String> waterQuantity;
  final StatefulValueListenable<String> waterTemperature;
  final StatefulValueListenable<WaterSource> waterSource;
  final void Function(String) onWaterQuantityUpdated;
  final void Function(String) onWaterTemperatureUpdated;
  final void Function(WaterSource) onWaterSourceUpdated;
  final StatefulValueListenable<bool> isReadyToAddWater;
  final StatefulValueListenable<String?> errorMessage;
  final VoidCallback onCheckValidity;
  final VoidCallback onAddWater;
  final VoidCallback onStepCompleted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AddWaterScreenBody(
          waterQuantity: waterQuantity,
          waterTemperature: waterTemperature,
          waterSource: waterSource,
          onWaterQuantityUpdated: onWaterQuantityUpdated,
          onWaterSourceUpdated: onWaterSourceUpdated,
          onWaterTemperatureUpdated: onWaterTemperatureUpdated,
        ),
        const AddWaterScreenBackButton(),
        AddWaterScreenFooter(
          isReadyToAddWater: isReadyToAddWater,
          errorMessage: errorMessage,
          onCheckValidity: onCheckValidity,
          onAddWater: onAddWater,
          onStepCompleted: onStepCompleted,
        ),
      ],
    );
  }
}
