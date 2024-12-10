import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'wolt_selection_list_item_data.dart';
import 'wolt_selection_list_item_data_group.dart';
import 'wolt_selection_list_tile.dart';
import 'wolt_selection_list_type.dart';

export 'wolt_selection_list_item_data.dart';
export 'wolt_selection_list_item_data_group.dart';

/// Callback function type for handling selection updates in [WoltSelectionList].
typedef _OnSelectionUpdateInWoltSelectionList<T> = void Function(
  List<T> selectedValues,
  WoltSelectionListItemData<T> updatedItemData,
);

/// Callback function type for handling selection updates in multi-selection [WoltSelectionList].
typedef OnSelectionUpdateInMultiSelectionList<T> = void Function(
  List<T> selectedValues,
  WoltSelectionListItemData<T> updatedItemData,
);

/// Callback function type for handling selection updates in single-selection [WoltSelectionList].
typedef OnSelectionUpdateInSingleSelectionList<T> = void Function(
  WoltSelectionListItemData<T> updatedItemData,
);

/// A list widget that displays selectable items in a scrollable list.
///
/// This widget provides a customizable selectable list widget, allowing users to select
/// items based on the specified selection type and providing callbacks for selection updates.
class WoltSelectionList<T> extends StatefulWidget {
  const WoltSelectionList._({
    required this.itemTileDataGroup,
    required this.selectionListType,
    required _OnSelectionUpdateInWoltSelectionList<T>
        onSelectionUpdateInWoltSelectionList,
    this.tilePadding,
    this.tileCrossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  }) : _onSelectionUpdateInWoltSelectionList =
            onSelectionUpdateInWoltSelectionList;

  /// The list of data for each selectable item in the list.
  final WoltSelectionListItemDataGroup<T> itemTileDataGroup;

  /// The type of selection (single or multiple) for the list.
  final WoltSelectionListType selectionListType;

  final CrossAxisAlignment? tileCrossAxisAlignment;

  /// Callback function that gets triggered when an item is selected in the list.
  final _OnSelectionUpdateInWoltSelectionList<T>
      _onSelectionUpdateInWoltSelectionList;

  final EdgeInsetsDirectional? tilePadding;

  /// Creates a single-selection [WoltSelectionList] widget.
  ///
  /// The [itemTileDataGroup] is the list of data for each selectable item in the list.
  /// The [onSelectionUpdateInSingleSelectionList] is the callback function that gets triggered
  /// when an item is selected in the list. The callback function receives the updated item data.
  factory WoltSelectionList.singleSelect({
    required WoltSelectionListItemDataGroup<T> itemTileDataGroup,
    required OnSelectionUpdateInSingleSelectionList<T>
        onSelectionUpdateInSingleSelectionList,
    EdgeInsetsDirectional? tilePadding,
    CrossAxisAlignment? tileCrossAxisAlignment,
  }) {
    return WoltSelectionList._(
      tilePadding: tilePadding,
      itemTileDataGroup: itemTileDataGroup,
      tileCrossAxisAlignment: tileCrossAxisAlignment,
      selectionListType: WoltSelectionListType.singleSelect,
      onSelectionUpdateInWoltSelectionList: (selectedValues, updatedItemData) {
        onSelectionUpdateInSingleSelectionList(updatedItemData);
      },
    );
  }

  /// Creates a multi-selection [WoltSelectionList] widget.
  ///
  /// The [itemTileDataGroup] is the list of data for each selectable item in the list.
  /// The [OnSelectionUpdateInMultiSelectionList] is the callback function that gets triggered
  /// when an item is selected in the list. The callback function receives the selected values and
  /// the updated item data.
  factory WoltSelectionList.multiSelect({
    required WoltSelectionListItemDataGroup<T> itemTileDataGroup,
    required OnSelectionUpdateInMultiSelectionList<T>
        onSelectionUpdateInMultiSelectionList,
    CrossAxisAlignment? tileCrossAxisAlignment,
    EdgeInsetsDirectional? tilePadding,
  }) {
    return WoltSelectionList._(
      tilePadding: tilePadding,
      itemTileDataGroup: itemTileDataGroup,
      tileCrossAxisAlignment: tileCrossAxisAlignment,
      selectionListType: WoltSelectionListType.multiSelect,
      onSelectionUpdateInWoltSelectionList: (selectedValues, updatedItemData) {
        onSelectionUpdateInMultiSelectionList(
          selectedValues,
          updatedItemData,
        );
      },
    );
  }

  @override
  State<WoltSelectionList<T>> createState() => _WoltSelectionListState<T>();
}

class _WoltSelectionListState<T> extends State<WoltSelectionList<T>> {
  late WoltSelectionListItemDataGroup<T> _itemTileDataGroup;

  @override
  void initState() {
    super.initState();
    _itemTileDataGroup = widget.itemTileDataGroup;
  }

  @override
  Widget build(BuildContext context) {
    final selectionListType = widget.selectionListType;

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        final listItemData = _itemTileDataGroup.group.elementAtOrNull(index);

        return listItemData == null
            ? const SizedBox.shrink()
            : WoltSelectionListTile(
                tilePadding: widget.tilePadding,
                tileCrossAxisAlignment: widget.tileCrossAxisAlignment,
                woltSelectionListItemData: listItemData,
                selectionListType: selectionListType,
                onSelected: (isSelected) {
                  setState(() {
                    _itemTileDataGroup = _itemTileDataGroup.onSelectedAt(
                      index,
                      selectionListType: widget.selectionListType,
                      isSelected: isSelected,
                    );
                    final selectedValues = _itemTileDataGroup.selectedValues;
                    widget._onSelectionUpdateInWoltSelectionList(
                      selectedValues,
                      listItemData.copyWith(isSelected: isSelected),
                    );
                  });
                },
              );
      },
      separatorBuilder: (_, __) => const Divider(height: 1.0),
      itemCount: _itemTileDataGroup.itemTileCount,
    );
  }
}
