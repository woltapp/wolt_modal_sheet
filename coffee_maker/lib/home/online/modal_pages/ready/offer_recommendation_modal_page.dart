import 'package:coffee_maker/home/online/modal_pages/ready/extra_recommendation.dart';
import 'package:coffee_maker/home/online/modal_pages/ready/extra_recommendation_tile.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class OfferRecommendationModalPage {
  OfferRecommendationModalPage._();

  static WoltModalSheetPage build({
    required VoidCallback onCoffeeOrderServed,
    required VoidCallback onBackButtonPressed,
    required VoidCallback onClosed,
  }) {
    final selectedItemCountListener = ValueNotifier(0);
    const pageTitle = 'Recommendations';
    const allRecommendations = ExtraRecommendation.values;
    final tileCount = allRecommendations.length + 1;
    final Set<ExtraRecommendation> selectedRecommendations = {};

    return WoltModalSheetPage.withCustomSliverList(
      stickyActionBar: ValueListenableBuilder<int>(
        valueListenable: selectedItemCountListener,
        builder: (_, count, __) {
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
              enabled: count > 0,
              child: Text(buttonText),
            ),
          );
        },
      ),
      topBarTitle: const ModalSheetTopBarTitle(pageTitle),
      pageTitle: const ModalSheetTitle(pageTitle),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      leadingNavBarWidget: WoltModalSheetBackButton(onBackPressed: onBackButtonPressed),
      sliverList: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            if (index == 0) {
              return const ModalSheetContentText(
                'Please select any extras the customer would be interested in purchasing',
              );
            } else {
              final recommendation = allRecommendations[index - 1];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == tileCount - 1 ? WoltElevatedButton.height * 2 : 0,
                ),
                child: ExtraRecommendationTile(
                  recommendation: recommendation,
                  onPressed: (isSelected) {
                    isSelected
                        ? selectedRecommendations.add(recommendation)
                        : selectedRecommendations.remove(recommendation);
                    selectedItemCountListener.value = selectedRecommendations.length;
                  },
                  isSelected: selectedRecommendations.contains(recommendation),
                ),
              );
            }
          },
          childCount: tileCount,
        ),
      ),
    );
  }
}
