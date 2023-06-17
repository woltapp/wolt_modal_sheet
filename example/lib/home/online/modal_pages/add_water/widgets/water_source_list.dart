import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:example/home/online/modal_pages/add_water/water_source.dart';
import 'package:flutter/material.dart';

class WaterSourceList extends StatelessWidget {
  const WaterSourceList({super.key, required this.onWaterSourceSelected});

  final OnSelectionUpdateInSingleSelectionList<WaterSource> onWaterSourceSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModalSheetSubtitle('Water source'),
        WoltSelectionList<WaterSource>.singleSelect(
          tilePadding: const EdgeInsetsDirectional.symmetric(vertical: 8),
          itemTileDataGroup: WoltSelectionListItemDataGroup(
            group: WaterSource.values
                .map(
                  (e) => WoltSelectionListItemData(title: e.label, value: e, isSelected: false),
                )
                .toList(),
          ),
          onSelectionUpdateInSingleSelectionList: onWaterSourceSelected,
        ),
      ],
    );
  }
}
