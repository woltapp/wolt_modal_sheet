import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/add_water_state.dart';
import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_back_button.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_body.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view/widgets/add_water_screen_footer.dart';
import 'package:flutter/material.dart';
import 'package:wolt_state_management/wolt_state_management.dart';

class AddWaterScreenContent extends StatelessWidget {
  const AddWaterScreenContent({
    super.key,
    required this.onWaterQuantityUpdated,
    required this.onWaterTemperatureUpdated,
    required this.onWaterSourceUpdated,
    required this.onCheckValidityPressed,
    required this.onAddWaterPressed,
    required this.state,
    required this.onStepCompleted,
  });

  final void Function(String) onWaterQuantityUpdated;
  final void Function(String) onWaterTemperatureUpdated;
  final void Function(WaterSource) onWaterSourceUpdated;
  final StatefulValueListenable<AddWaterState> state;
  final VoidCallback onCheckValidityPressed;
  final VoidCallback onAddWaterPressed;
  final VoidCallback onStepCompleted;

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
        StatefulValueListenableBuilder<AddWaterState>(
          valueListenable: state,
          idleBuilder: (context, state) {
            return AddWaterScreenFooter(
              isReadyToAddWater: state!.isReadyToAddWater,
              errorMessage: state.errorMessage,
              onCheckValidity: onCheckValidityPressed,
              onAddWater: onAddWaterPressed,
              onStepCompleted: onStepCompleted,
            );
          },
          loadingBuilder: (context, state) {
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, state) {
            return Center(child: Text('Error: $error'));
          },
        ),
      ],
    );
  }
}
