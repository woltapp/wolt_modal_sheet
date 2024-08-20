import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddWaterScreenContent extends StatelessWidget {
  const AddWaterScreenContent({
    super.key,
    required this.onWaterQuantityUpdated,
    required this.onWaterTemperatureUpdated,
    required this.onWaterSourceUpdated,
  });

  final void Function(String) onWaterQuantityUpdated;
  final void Function(String) onWaterTemperatureUpdated;
  final void Function(WaterSource) onWaterSourceUpdated;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Image(
            image: AssetImage('lib/assets/images/add_water_description.png'),
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0) +
                  const EdgeInsets.only(bottom: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add water to the coffee',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter the details to see the quality of the water you are adding to the coffee maker.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  AppTextFormField(
                    controller: TextEditingController(),
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: onWaterQuantityUpdated,
                    onSubmitted: onWaterQuantityUpdated,
                    inputFormatters: [
                      /* Don't allow minus or space */
                      FilteringTextInputFormatter.deny(RegExp(r'(\s|-+)')),
                    ],
                    labelText: 'Water quantity (ml)',
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: TextEditingController(),
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: onWaterTemperatureUpdated,
                    onSubmitted: onWaterTemperatureUpdated,
                    inputFormatters: [
                      /* Don't allow minus or space */
                      FilteringTextInputFormatter.deny(RegExp(r'(\s|-+)')),
                    ],
                    labelText: 'Water temperature (°C)',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select the water source:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  WoltSelectionList<WaterSource>.singleSelect(
                    tilePadding:
                        const EdgeInsetsDirectional.symmetric(vertical: 8),
                    itemTileDataGroup: WoltSelectionListItemDataGroup(
                      group: WaterSource.values
                          .map(
                            (e) => WoltSelectionListItemData(
                                title: e.label, value: e, isSelected: false),
                          )
                          .toList(),
                    ),
                    onSelectionUpdateInSingleSelectionList: (item) {
                      onWaterSourceUpdated(item.value);
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
