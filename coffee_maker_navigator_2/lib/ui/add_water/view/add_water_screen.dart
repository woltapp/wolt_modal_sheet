import 'package:coffee_maker_navigator_2/di/dependency_container_subscriber.dart';
import 'package:coffee_maker_navigator_2/di/dependency_containers/add_water_dependency_container.dart';
import 'package:coffee_maker_navigator_2/di/injector.dart';
import 'package:coffee_maker_navigator_2/domain/add_water/entities/water_source.dart';
import 'package:coffee_maker_navigator_2/ui/add_water/view_model/add_water_view_model.dart';
import 'package:coffee_maker_navigator_2/ui/router/view_model/router_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddWaterScreen extends StatefulWidget {
  const AddWaterScreen({super.key, required this.coffeeOrderId});

  final String coffeeOrderId;

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen>
    with
        DependencyContainerSubscriber<AddWaterDependencyContainer,
            AddWaterScreen> {
  @override
  Widget build(BuildContext context) {
    return SystemUIAnnotationWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
          child: ChangeNotifierProvider<AddWaterViewModel>(
              create: (context) => Injector.of(context)
                  .getDependencyContainer<AddWaterDependencyContainer>()
                  .createViewModel(),
              builder: (context, _) {
                final viewModel = context.read<AddWaterViewModel>();
                return Stack(
                  children: [
                    _AddWaterScreenContent(
                      onWaterQuantityUpdated: viewModel.onWaterQuantityUpdated,
                      onWaterSourceUpdated: viewModel.onWaterSourceUpdated,
                      onWaterTemperatureUpdated:
                          viewModel.onWaterTemperatureUpdated,
                    ),
                    const _AddWaterScreenBackButton(),
                    _AddWaterScreenFooter(
                      viewModel.isReadyToAddWater,
                      viewModel.errorMessage,
                    ),
                  ],
                );
              }),
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
  const _AddWaterScreenFooter(this.isReadyToAddWater, this.errorMessage);

  final ValueListenable<bool> isReadyToAddWater;
  final ValueListenable<String?> errorMessage;

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
                onPressed: () {
                  context.read<AddWaterViewModel>().checkValidity();
                },
                child: const Text('Check '),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<bool>(
                valueListenable: isReadyToAddWater,
                builder: (_, isEnabled, __) {
                  return WoltElevatedButton(
                    enabled: isEnabled,
                    onPressed: () {
                      context.read<AddWaterViewModel>().addWater();
                      context.read<RouterViewModel>().onAddWaterStepCompleted();
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
