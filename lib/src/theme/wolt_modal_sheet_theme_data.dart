import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_animation_style.dart';
import 'package:wolt_modal_sheet/src/wolt_modal_sheet.dart';

@immutable
class WoltModalSheetThemeData extends ThemeExtension<WoltModalSheetThemeData> {
  const WoltModalSheetThemeData({
    this.backgroundColor,
    this.modalElevation,
    this.modalBarrierColor,
    this.bottomSheetShape,
    this.dialogShape,
    this.showDragHandle,
    this.dragHandleColor,
    this.dragHandleSize,
    this.enableCloseDrag,
    this.enableDrag,
    this.topBarShadowColor,
    this.topBarElevation,
    this.heroImageHeight,
    this.hasSabGradient,
    this.sabGradientHeight,
    this.sabGradientColor,
    this.navBarHeight,
    this.hasTopBarLayer,
    this.isTopBarLayerAlwaysVisible,
    this.minDialogWidth,
    this.maxDialogWidth,
    this.minPageHeight,
    this.maxPageHeight,
    this.surfaceTintColor,
    this.clipBehavior,
    this.shadowColor,
    this.mainContentScrollPhysics,
    this.animationStyle,
    this.resizeToAvoidBottomInset,
  });

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
  final Color? surfaceTintColor;

  /// The background color of the modal sheet.
  final Color? backgroundColor;

  /// The elevation of the modal sheet.
  final double? modalElevation;

  /// The color of the modal barrier.
  final Color? modalBarrierColor;

  /// The shape of the bottom sheet.
  final ShapeBorder? bottomSheetShape;

  /// The shape of the dialog.
  final ShapeBorder? dialogShape;

  /// Whether to show the drag handle.
  final bool? showDragHandle;

  /// The color of the drag handle.
  final Color? dragHandleColor;

  /// The size of the drag handle.
  final Size? dragHandleSize;

  /// Controls the ability to close the bottom sheet by dragging.
  final bool? enableCloseDrag;

  /// Whether the bottom sheet can be dragged.
  final bool? enableDrag;

  /// The elevation color of the top bar.
  final Color? topBarShadowColor;

  /// The elevation of the top bar.
  final double? topBarElevation;

  /// The height of the hero image.
  final double? heroImageHeight;

  /// Indicates whether a gentle gradient overlay should be rendered above the
  /// [stickyActionBar]. The purpose of this gradient is to visually suggest
  /// to the user that additional content might be present below the action bar.
  ///
  /// If set to `true`, a gradient from the page's background color to transparent
  /// is rendered right above the [stickyActionBar]. If `false`, no gradient is rendered.
  /// By default, it's set to `true` in [WoltModalSheetThemeData].
  final bool? hasSabGradient;

  /// The color of the gentle gradient overlay that is rendered above the [stickyActionBar]. The
  /// purpose of this gradient is to visually suggest to the user that additional content might
  /// be present below the action bar.
  ///
  /// If [hasSabGradient] set to `true`, a gradient from this color to transparent is rendered
  /// right above the [stickyActionBar]. If `false`, no gradient is rendered. By default, it's
  /// value is to page background color.
  final Color? sabGradientColor;

  /// If [hasSabGradient] set to `true`, a gradient from the page's background color to transparent
  /// is rendered right above the [stickyActionBar]. [sabGradientHeight] sets the height of this
  /// transparency.
  final double? sabGradientHeight;

  /// The height of the navigation bar.
  final double? navBarHeight;

  /// Whether to show a top bar layer above the modal sheet.
  final bool? hasTopBarLayer;

  /// Whether the top bar layer is always visible.
  final bool? isTopBarLayerAlwaysVisible;

  /// The minimum width of the dialog.
  final double? minDialogWidth;

  /// The maximum width of the dialog.
  final double? maxDialogWidth;

  /// The minimum height of the page.
  final double? minPageHeight;

  /// The maximum height of the page.
  final double? maxPageHeight;

  /// Overrides the default value for [WoltModalSheetThemeData] shadowColor.
  final Color? shadowColor;

  /// Overrides the default value for [WoltModalSheet] clipBehavior.
  ///
  /// If null, [WoltModalSheet] uses [Clip.antiAliasWithSaveLayer].
  final Clip? clipBehavior;

  /// The default value for [WoltModalSheet] scrollPhysics in the main content.
  final ScrollPhysics? mainContentScrollPhysics;

  /// Motion animation styles for both pagination and scrolling animations.
  final WoltModalSheetAnimationStyle? animationStyle;

  /// If there is an onscreen keyboard displayed above the
  /// modal sheet, the main content can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the main content from being obscured by the keyboard.
  ///
  /// WoltModalSheet internally uses a [Scaffold] to provide this functionality and to handle the
  /// safe area color for the modal sheet. Setting this value will set the same value inside the
  /// internal [Scaffold] of the modal sheet.
  ///
  /// Defaults to true.
  final bool? resizeToAvoidBottomInset;

  @override
  WoltModalSheetThemeData copyWith({
    Color? backgroundColor,
    double? modalElevation,
    Color? modalBarrierColor,
    ShapeBorder? bottomSheetShape,
    ShapeBorder? dialogShape,
    bool? showDragHandle,
    Color? dragHandleColor,
    Size? dragHandleSize,
    Color? topBarShadowColor,
    double? topBarElevation,
    double? heroImageHeight,
    bool? hasSabGradient,
    double? sabGradientHeight,
    double? navBarHeight,
    bool? hasTopBarLayer,
    bool? isTopBarLayerAlwaysVisible,
    double? minDialogWidth,
    double? maxDialogWidth,
    double? minPageHeight,
    double? maxPageHeight,
    Color? surfaceTintColor,
    Color? shadowColor,
    Clip? clipBehavior,
    ScrollPhysics? mainContentScrollPhysics,
    WoltModalSheetAnimationStyle? animationStyle,
    bool? resizeToAvoidBottomInset,
  }) {
    return WoltModalSheetThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      modalElevation: modalElevation ?? this.modalElevation,
      modalBarrierColor: modalBarrierColor ?? this.modalBarrierColor,
      bottomSheetShape: bottomSheetShape ?? this.bottomSheetShape,
      dialogShape: dialogShape ?? this.dialogShape,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      dragHandleSize: dragHandleSize ?? this.dragHandleSize,
      topBarShadowColor: topBarShadowColor ?? this.topBarShadowColor,
      topBarElevation: topBarElevation ?? this.topBarElevation,
      heroImageHeight: heroImageHeight ?? this.heroImageHeight,
      hasSabGradient: hasSabGradient ?? this.hasSabGradient,
      sabGradientHeight: sabGradientHeight ?? this.sabGradientHeight,
      navBarHeight: navBarHeight ?? this.navBarHeight,
      hasTopBarLayer: hasTopBarLayer ?? this.hasTopBarLayer,
      isTopBarLayerAlwaysVisible:
          isTopBarLayerAlwaysVisible ?? this.isTopBarLayerAlwaysVisible,
      minDialogWidth: minDialogWidth ?? this.minDialogWidth,
      maxDialogWidth: maxDialogWidth ?? this.maxDialogWidth,
      minPageHeight: minPageHeight ?? this.minPageHeight,
      maxPageHeight: maxPageHeight ?? this.maxPageHeight,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      shadowColor: shadowColor ?? this.shadowColor,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      mainContentScrollPhysics:
          mainContentScrollPhysics ?? this.mainContentScrollPhysics,
      animationStyle: animationStyle ?? this.animationStyle,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
    );
  }

  @override
  WoltModalSheetThemeData lerp(WoltModalSheetThemeData? other, double t) {
    if (other == null) return this;

    return WoltModalSheetThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      modalElevation: lerpDouble(modalElevation, other.modalElevation, t),
      showDragHandle: t < 0.5 ? showDragHandle : other.showDragHandle,
      resizeToAvoidBottomInset:
          t < 0.5 ? resizeToAvoidBottomInset : other.resizeToAvoidBottomInset,
      modalBarrierColor:
          Color.lerp(modalBarrierColor, other.modalBarrierColor, t),
      bottomSheetShape:
          ShapeBorder.lerp(bottomSheetShape, other.bottomSheetShape, t),
      dialogShape: ShapeBorder.lerp(dialogShape, other.dialogShape, t),
      dragHandleColor: Color.lerp(dragHandleColor, other.dragHandleColor, t),
      dragHandleSize: Size.lerp(dragHandleSize, other.dragHandleSize, t),
      topBarShadowColor:
          Color.lerp(topBarShadowColor, other.topBarShadowColor, t),
      topBarElevation: lerpDouble(topBarElevation, other.topBarElevation, t),
      heroImageHeight: lerpDouble(heroImageHeight, other.heroImageHeight, t),
      hasSabGradient: t < 0.5 ? hasSabGradient : other.hasSabGradient,
      sabGradientHeight:
          lerpDouble(sabGradientHeight, other.sabGradientHeight, t),
      navBarHeight: lerpDouble(navBarHeight, other.navBarHeight, t),
      hasTopBarLayer: t < 0.5 ? hasTopBarLayer : other.hasTopBarLayer,
      isTopBarLayerAlwaysVisible: t < 0.5
          ? isTopBarLayerAlwaysVisible
          : other.isTopBarLayerAlwaysVisible,
      minDialogWidth: lerpDouble(minDialogWidth, other.minDialogWidth, t),
      maxDialogWidth: lerpDouble(maxDialogWidth, other.maxDialogWidth, t),
      minPageHeight: lerpDouble(minPageHeight, other.minPageHeight, t),
      maxPageHeight: lerpDouble(maxPageHeight, other.maxPageHeight, t),
      surfaceTintColor: Color.lerp(surfaceTintColor, other.surfaceTintColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      mainContentScrollPhysics:
          t < 0.5 ? mainContentScrollPhysics : other.mainContentScrollPhysics,
      animationStyle: t < 0.5 ? animationStyle : other.animationStyle,
    );
  }
}
