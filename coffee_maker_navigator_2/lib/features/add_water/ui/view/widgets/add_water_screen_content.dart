import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_back_button.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_body.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_footer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddWaterScreenContent extends StatelessWidget {
  const AddWaterScreenContent({
    super.key,
    required this.onWaterQuantityUpdated,
    required this.onWaterTemperatureUpdated,
    required this.onWaterSourceUpdated,
    required this.onCheckValidityPressed,
    required this.onAddWaterPressed,
    required this.isReadyToAddWater,
    required this.errorMessage,
  });

  final void Function(String) onWaterQuantityUpdated;
  final void Function(String) onWaterTemperatureUpdated;
  final void Function(WaterSource) onWaterSourceUpdated;
  final ValueListenable<bool> isReadyToAddWater;
  final ValueListenable<String?> errorMessage;
  final VoidCallback onCheckValidityPressed;
  final VoidCallback onAddWaterPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AddWaterScreenBody(
          onWaterQuantityUpdated: onWaterQuantityUpdated,
          onWaterSourceUpdated: onWaterSourceUpdated,
          onWaterTemperatureUpdated: onWaterTemperatureUpdated,
        ),
        const AddWaterScreenBackButton(),
        AddWaterScreenFooter(
          isReadyToAddWater,
          errorMessage,
          onCheckValidityPressed,
          onAddWaterPressed,
        ),
      ],
    );
  }
}
