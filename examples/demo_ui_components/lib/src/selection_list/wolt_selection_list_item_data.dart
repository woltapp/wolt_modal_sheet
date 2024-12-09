import 'package:flutter/material.dart';

/// Represents the data for a list item in the WoltSelectionList widget.
class WoltSelectionListItemData<T> {
  /// The title of the list item.
  final String title;

  /// The subtitle of the list item.
  final String? subtitle;

  /// The value associated with the list item.
  final T value;

  /// The optional icon to display for the list item in the leading position.
  final IconData? leadingIcon;

  /// Asset path of the optional image to display for the list item in the leading position.
  final String? leadingImageAssetPath;

  /// Indicates whether the list item is selected.
  final bool isSelected;

  const WoltSelectionListItemData({
    required this.title,
    required this.value,
    this.leadingImageAssetPath,
    this.subtitle,
    this.isSelected = false,
    this.leadingIcon,
  });

  WoltSelectionListItemData<T> copyWith({
    String? title,
    String? description,
    T? value,
    IconData? leadingIcon,
    bool? isSelected,
    String? leadingImageAssetPath,
  }) {
    return WoltSelectionListItemData(
      title: title ?? this.title,
      subtitle: description ?? this.subtitle,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      leadingImageAssetPath:
          leadingImageAssetPath ?? this.leadingImageAssetPath,
    );
  }
}
