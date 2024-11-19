import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/ready/extra_recommendation.dart';
import 'package:coffee_maker_navigator_2/features/orders/ui/view/modal_pages/ready/extra_recommendation_tile.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'ExtraRecommendationTile',
  type: ExtraRecommendationTile,
  path: 'Orders/View/ModalPages/Ready',
)
Widget extraRecommendationTile(BuildContext context) {
  return Scaffold(
    body: Center(
      child: ExtraRecommendationTile(
        recommendation: context.knobs.list(
          label: 'Extra recommendation',
          options: ExtraRecommendation.values,
          initialOption: ExtraRecommendation.baklava,
          labelBuilder: (value) => value.label,
        ),
        isSelected: context.knobs.boolean(
          label: 'Is selected',
          initialValue: false,
        ),
        onPressed: (_) {},
      ),
    ),
  );
}
