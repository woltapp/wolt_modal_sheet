import 'package:demo_ui_components/src/colors/wolt_colors.dart';
import 'package:demo_ui_components/src/selection_list/wolt_selection_list_item_data.dart';
import 'package:demo_ui_components/src/selection_list/wolt_selection_list_tile_trailing.dart';
import 'package:demo_ui_components/src/selection_list/wolt_selection_list_type.dart';
import 'package:flutter/material.dart';

/// Represents a selectable list item in the WoltSelectionList widget.
class WoltSelectionListTile<T> extends StatefulWidget {
  const WoltSelectionListTile({
    required this.woltSelectionListItemData,
    required this.selectionListType,
    required this.onSelected,
    super.key,
  });

  /// The data for the list item.
  final WoltSelectionListItemData<T> woltSelectionListItemData;

  /// The type of selection (single or multiple) for the list item.
  final WoltSelectionListType selectionListType;

  final ValueChanged<bool> onSelected;

  @override
  State<WoltSelectionListTile<T>> createState() => _WoltSelectionListTileState<T>();
}

class _WoltSelectionListTileState<T> extends State<WoltSelectionListTile<T>> {
  bool _isSelected = false;

  WoltSelectionListItemData<T> get _data => widget.woltSelectionListItemData;

  @override
  void initState() {
    super.initState();
    _isSelected = _data.isSelected;
  }

  void _onTap() {
    setState(() {
      _isSelected = !_isSelected;
      widget.onSelected.call(_isSelected);
    });
  }

  @override
  void didUpdateWidget(covariant WoltSelectionListTile<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isSelected != _data.isSelected) {
      _isSelected = _data.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _data.leadingIcon;

    return InkWell(
      onTap: _onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: WoltColors.black),
            Expanded(
              child: Text(
                _data.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 16),
            WoltSelectionListTileTrailing(
              groupType: widget.selectionListType,
              isSelected: _isSelected,
            ),
          ],
        ),
      ),
    );
  }
}
