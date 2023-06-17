import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:example/home/online/modal_pages/ready/extra_recommendation.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class OfferRecommendationModalPage {
  OfferRecommendationModalPage._();

  static WoltModalSheetPage build({
    required VoidCallback onCoffeeOrderServed,
    required VoidCallback onBackButtonPressed,
    required VoidCallback onClosed,
  }) {
    final buttonEnabledListener = ValueNotifier(false);
    final selectedItemCountListener = ValueNotifier(0);
    const pageTitle = 'Recommendations';

    return WoltModalSheetPage.withSingleChild(
      footer: AnimatedBuilder(
        animation: Listenable.merge([buttonEnabledListener, selectedItemCountListener]),
        builder: (_, __) {
          final count = selectedItemCountListener.value;
          final String buttonText;
          if (count == 0) {
            buttonText = 'Select recommendations';
          } else if (count == 1) {
            buttonText = 'Serve with 1 suggestion';
          } else {
            buttonText = 'Serve with $count suggestions';
          }
          return StickyActionBarWrapper(
            child: WoltElevatedButton(
              onPressed: onCoffeeOrderServed,
              enabled: buttonEnabledListener.value,
              child: Text(buttonText),
            ),
          );
        },
      ),
      topBarTitle: const ModalSheetTopBarTitle(pageTitle),
      pageTitle: const ModalSheetTitle(pageTitle),
      closeButton: WoltModalSheetCloseButton(onClosed: onClosed),
      backButton: WoltModalSheetBackButton(onBackPressed: onBackButtonPressed),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ModalSheetContentText(
              'Please select any extras the customer would be interested in purchasing',
            ),
            WoltSelectionList<ExtraRecommendation>.multiSelect(
              tileCrossAxisAlignment: CrossAxisAlignment.center,
              itemTileDataGroup: WoltSelectionListItemDataGroup(
                group: ExtraRecommendation.values
                    .map(
                      (e) => WoltSelectionListItemData(
                        title: e.label,
                        subtitle: e.price,
                        leadingImageAssetPath: e.imageAssetPath,
                        value: e,
                        isSelected: false,
                      ),
                    )
                    .toList(),
              ),
              onSelectionUpdateInMultiSelectionList: (List<ExtraRecommendation> selectedValues,
                  WoltSelectionListItemData<ExtraRecommendation> updatedItemData) {
                buttonEnabledListener.value = selectedValues.isNotEmpty;
                selectedItemCountListener.value = selectedValues.length;
              },
            ),
          ],
        ),
      ),
    );
  }
}
