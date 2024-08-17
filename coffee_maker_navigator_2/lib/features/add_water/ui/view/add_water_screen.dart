import 'package:coffee_maker_navigator_2/features/add_water/di/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/features/add_water/domain/entities/water_source.dart';
import 'package:coffee_maker_navigator_2/features/add_water/ui/view_model/add_water_view_model.dart';
import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Widget build(BuildContext context) {
    return SystemUIAnnotationWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              _AddWaterScreenContent(
                onWaterQuantityUpdated: _viewModel.onWaterQuantityUpdated,
                onWaterSourceUpdated: _viewModel.onWaterSourceUpdated,
                onWaterTemperatureUpdated: _viewModel.onWaterTemperatureUpdated,
              ),
              const _AddWaterScreenBackButton(),
              _AddWaterScreenFooter(
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

class _AddWaterScreenContent extends StatelessWidget {
  const _AddWaterScreenContent({
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

class _AddWaterScreenBackButton extends StatelessWidget {
  const _AddWaterScreenBackButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0) +
            EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: BackButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
    );
  }
}

class _AddWaterScreenFooter extends StatelessWidget {
  const _AddWaterScreenFooter(
    this.isReadyToAddWater,
    this.errorMessage,
    this.onCheckValidity,
    this.onAddWater,
  );

  final ValueListenable<bool> isReadyToAddWater;
  final ValueListenable<String?> errorMessage;
  final VoidCallback onCheckValidity;
  final VoidCallback onAddWater;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0) +
              EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<String?>(
                  valueListenable: errorMessage,
                  builder: (_, message, __) {
                    return message == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _ErrorNotificationWidget(message),
                          );
                  }),
              WoltElevatedButton(
                onPressed: onCheckValidity,
                child: const Text('Check '),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<bool>(
                valueListenable: isReadyToAddWater,
                builder: (_, isEnabled, __) {
                  return WoltElevatedButton(
                    enabled: isEnabled,
                    onPressed: () {
                      onAddWater();
                      context.routerViewModel.onAddWaterStepCompleted();
                    },
                    child: const Text('Add water'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorNotificationWidget extends StatelessWidget {
  final String message;

  const _ErrorNotificationWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: WoltColors.red8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child:
                  Text(message, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
