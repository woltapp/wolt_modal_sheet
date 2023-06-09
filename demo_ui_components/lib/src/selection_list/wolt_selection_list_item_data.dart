import 'package:flutter/material.dart';

/// Represents the data for a list item in the WoltSelectionList widget.
class WoltSelectionListItemData<T> {
  /// The title of the list item.
  final String title;

  /// The value associated with the list item.
  final T value;

  /// The optional icon to display for the list item in the leading position.
  final IconData? leadingIcon;

  /// Indicates whether the list item is selected.
  final bool isSelected;

  const WoltSelectionListItemData({
    required this.title,
    required this.value,
    this.isSelected = false,
    this.leadingIcon,
  });

  WoltSelectionListItemData<T> copyWith({
    String? title,
    T? value,
    IconData? leadingIcon,
    bool? isSelected,
  }) {
    return WoltSelectionListItemData(
      title: title ?? this.title,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
      leadingIcon: leadingIcon ?? this.leadingIcon,
    );
  }
}
