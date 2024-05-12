import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@immutable
class WoltModalSheetDefaultThemeData extends WoltModalSheetThemeData {
  WoltModalSheetDefaultThemeData(this.context);

  final BuildContext context;
  late final ColorScheme _colorsScheme = Theme.of(context).colorScheme;

  /// The color of the surface tint overlay applied to the material color
  /// to indicate elevation for the modal sheet page. The [surfaceTintColor] is applied to the
  /// modal sheet background color, top bar color, and the sticky action bar wrapper colors.
  ///
  /// {@template flutter.material.material.surfaceTintColor}
  /// Material Design 3 introduced a new way for some components to indicate
  /// their elevation by using a surface tint color overlay on top of the
  /// base material [color]. This overlay is painted with an opacity that is
  /// related to the [elevation] of the material.
  ///
  /// If [ThemeData.useMaterial3] is false, then this property is not used.
  ///
  /// If [ThemeData.useMaterial3] is true and [surfaceTintColor] is not null and
  /// not [Colors.transparent], then it will be used to overlay the base [backgroundColor]
  /// with an opacity based on the [modalElevation].
  ///
  /// If [ThemeData.useMaterial3] is true and [surfaceTintColor] is null, then the default
  /// [surfaceTintColor] value is taken from the [ColorScheme].
  ///
  /// See also:
  ///
  ///   * [ThemeData.useMaterial3], which turns this feature on.
  ///   * [ElevationOverlay.applySurfaceTint], which is used to implement the
  ///     tint.
  ///   * https://m3.material.io/styles/color/the-color-system/color-roles
  ///     which specifies how the overlay is applied.
  @override
  Color get surfaceTintColor => _colorsScheme.surfaceTint;

  /// The background color of the modal sheet.
  @override
  Color get backgroundColor => _colorsScheme.surface;

  /// The elevation of the modal sheet.
  @override
  double get modalElevation => 1.0;

  /// The color of the modal barrier.
  @override
  Color get modalBarrierColor => Colors.black54;

  /// The shape of the bottom sheet.
  @override
  ShapeBorder get bottomSheetShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      );

  /// The shape of the dialog.
  @override
  ShapeBorder get dialogShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      );

  /// Whether to show the drag handle.
  @override
  bool get showDragHandle => enableCloseDrag || enableDrag;

  /// Whether the bottom sheet can be dismissed by dragging.
  @override
  bool get enableCloseDrag => true;

  /// Whether to enable the drag for bottom sheet.
  @override
  bool get enableDrag => false;

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  Color get dragHandleColor => _colorsScheme.onSurfaceVariant.withOpacity(0.4);

  /// The size of the drag handle.
  @override
  Size get dragHandleSize => const Size(36, 4);

  /// The elevation color of the modal bar.
  @override
  Color get shadowColor => Colors.transparent;

  /// The elevation color of the modal bar.
  @override
  Color get topBarShadowColor => _colorsScheme.shadow;

  /// The elevation of the top bar.
  @override
  double get topBarElevation => 1.0;

  /// The height of the hero image.
  @override
  double get heroImageHeight => 200.0;

  /// Indicates whether a gentle gradient overlay should be rendered above the
  /// [stickyActionBar]. The purpose of this gradient is to visually suggest
  /// to the user that additional content might be present below the action bar.
  ///
  /// If set to `true`, a gradient from the page's background color to transparent
  /// is rendered right above the [stickyActionBar]. If `false`, no gradient is rendered.
  /// By default, it's set to `true` in [WoltModalSheetThemeData].
  @override
  bool get hasSabGradient => true;

  /// If [hasSabGradient] set to `true`, a gradient from the page's background color to transparent
  /// is rendered right above the [stickyActionBar]. [sabGradientHeight] sets the height of this
  /// transparency.
  @override
  double get sabGradientHeight => 24.0;

  /// The color of the gentle gradient overlay that is rendered above the [stickyActionBar]. The
  /// purpose of this gradient is to visually suggest to the user that additional content might
  /// be present below the action bar.
  ///
  /// If [hasSabGradient] set to `true`, a gradient from this color to transparent is rendered
  /// right above the [stickyActionBar]. If `false`, no gradient is rendered. By default, it's
  /// value is to page background color.
  @override
  Color get sabGradientColor => backgroundColor;

  /// The height of the navigation bar.
  @override
  double get navBarHeight => 72.0;

  /// Whether to show a top bar layer above the modal sheet.
  @override
  bool get hasTopBarLayer => true;

  /// Whether the top bar layer is always visible.
  @override
  bool get isTopBarLayerAlwaysVisible => false;

  /// The minimum width of the dialog.
  @override
  double get minDialogWidth => 400;

  /// The maximum width of the dialog.
  @override
  double get maxDialogWidth => 560;

  /// The minimum height of the page.
  @override
  double get minPageHeight => 0.0;

  /// The maximum height of the page.
  @override
  double get maxPageHeight => 0.9;

  /// Overrides the default value for [WoltModalSheet] clipBehavior.
  ///
  /// Defaults to [Clip.antiAliasWithSaveLayer].
  @override
  Clip get clipBehavior => Clip.antiAliasWithSaveLayer;

  /// Motion animation styles for both pagination and page scrolling.
  @override
  WoltModalSheetAnimationStyle get animationStyle =>
      const WoltModalSheetAnimationStyle();
}
