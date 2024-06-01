import 'package:coffee_maker_navigator_2/ui/orders/view/modal_pages/ready/extra_recommendation.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view/modal_pages/ready/extra_recommendation_tile.dart';
import 'package:coffee_maker_navigator_2/ui/orders/view_model/orders_screen_view_model.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class OfferRecommendationModalPage {
  OfferRecommendationModalPage._();

  static SliverWoltModalSheetPage build({required String coffeeOrderId}) {
    final selectedItemCountListener = ValueNotifier(0);
    const pageTitle = 'Recommendations';
    const allRecommendations = ExtraRecommendation.values;
    final tileCount = allRecommendations.length + 1;
    final Set<ExtraRecommendation> selectedRecommendations = {};

    return SliverWoltModalSheetPage(
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
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Builder(builder: (context) {
              final model = context.read<OrdersScreenViewModel>();
              return WoltElevatedButton(
                onPressed: () {
                  model.onCoffeeOrderStatusChange(coffeeOrderId);
                  Navigator.pop(context);
                },
                enabled: count > 0,
                child: Text(buttonText),
              );
            }),
          );
        },
      ),
      topBarTitle: const ModalSheetTopBarTitle(pageTitle),
      pageTitle: const ModalSheetTitle(pageTitle),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      mainContentSlivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ModalSheetContentText(
                    'Please select any extras the customer would be interested in purchasing',
                  ),
                );
              } else {
                final recommendation = allRecommendations[index - 1];
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    index == tileCount - 1 ? WoltElevatedButton.defaultHeight * 2 : 0,
                  ),
                  child: ExtraRecommendationTile(
                    recommendation: recommendation,
                    onPressed: (isSelected) {
                      isSelected
                          ? selectedRecommendations.add(recommendation)
                          : selectedRecommendations.remove(recommendation);
                      selectedItemCountListener.value =
                          selectedRecommendations.length;
                    },
                    isSelected:
                        selectedRecommendations.contains(recommendation),
                  ),
                );
              }
            },
            childCount: tileCount,
          ),
        ),
      ],
    );
  }
}
