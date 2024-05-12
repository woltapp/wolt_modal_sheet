import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// A [ValueNotifier] that holds and manages the state of the dynamic properties for a [WoltModalSheetPage].
class DynamicPagePropertiesNotifier
    extends ValueNotifier<DynamicPagePropertiesModel> {
  /// Constructs a [DynamicPagePropertiesNotifier] instance with the initial [value].
  DynamicPagePropertiesNotifier(DynamicPagePropertiesModel value)
      : super(value);
}

/// A model class that represents the dynamic properties of a page.
class DynamicPagePropertiesModel {
  /// Indicates whether dragging is enabled for the bottom sheet.
  final bool enableCloseDrag;

  /// Creates a [DynamicPagePropertiesModel] with the provided properties.
  DynamicPagePropertiesModel({required this.enableCloseDrag});

  /// Creates a copy of [DynamicPagePropertiesModel] with optional property updates.
  DynamicPagePropertiesModel copyWith({bool? enableCloseDrag}) {
    return DynamicPagePropertiesModel(
      enableCloseDrag: enableCloseDrag ?? this.enableCloseDrag,
    );
  }
}

/// An [InheritedNotifier] that provides access to the dynamic page properties within its subtree.
class DynamicPageProperties
    extends InheritedNotifier<DynamicPagePropertiesNotifier> {
  /// Creates an instance of [DynamicPageProperties].
  ///
  /// The [notifier] holds the [DynamicPagePropertiesNotifier] that manages the dynamic page properties,
  /// and [child] is the widget subtree that this inherited widget wraps.
  const DynamicPageProperties({
    super.key,
    required DynamicPagePropertiesNotifier notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  /// Retrieves the [DynamicPagePropertiesNotifier] from the nearest ancestor [DynamicPageProperties].
  static DynamicPagePropertiesNotifier? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DynamicPageProperties>()
        ?.notifier;
  }
}
