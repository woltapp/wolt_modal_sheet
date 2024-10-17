import 'dart:ui';
import 'package:flutter/material.dart';

/// A theme extension for the [WoltModalSheet] widget.
class WoltModalSheetTheme extends ThemeExtension<WoltModalSheetTheme> {
  final WoltModalSheetStyle style;

  WoltModalSheetTheme({
    WoltModalSheetStyle? style,
  }) : style = style ?? WoltModalSheetStyle();

  @override
  ThemeExtension<WoltModalSheetTheme> copyWith({
    WoltModalSheetStyle? style,
  }) {
    return WoltModalSheetTheme(
      style: style ?? this.style,
    );
  }

  @override
  ThemeExtension<WoltModalSheetTheme> lerp(
      WoltModalSheetTheme? other, double t) {
    if (other == null) return this;

    return WoltModalSheetTheme(
      style: style.lerp(other.style, t),
    );
  }
}

/// Style of the modal sheet.
class WoltModalSheetStyle {
  final WoltModalBottomSheetStyle bottomSheetStyle;
  final WoltModalDialogStyle dialogStyle;

  WoltModalSheetStyle({
    WoltModalBottomSheetStyle? bottomSheetStyle,
    WoltModalDialogStyle? dialogStyle,
  })  : bottomSheetStyle =
            bottomSheetStyle ?? const WoltModalBottomSheetStyle(),
        dialogStyle = dialogStyle ?? const WoltModalDialogStyle();

  WoltModalSheetStyle copyWith({
    WoltModalBottomSheetStyle? bottomSheetStyle,
    WoltModalDialogStyle? dialogStyle,
  }) {
    return WoltModalSheetStyle(
      bottomSheetStyle: bottomSheetStyle ?? this.bottomSheetStyle,
      dialogStyle: dialogStyle ?? this.dialogStyle,
    );
  }

  WoltModalSheetStyle lerp(WoltModalSheetStyle? other, double t) {
    if (other == null) return this;

    return WoltModalSheetStyle(
      bottomSheetStyle: bottomSheetStyle.lerp(other.bottomSheetStyle, t),
      dialogStyle: dialogStyle.lerp(other.dialogStyle, t),
    );
  }
}

class WoltModalBottomSheetStyle {
  const WoltModalBottomSheetStyle({
    this.backgroundColor,
    this.surfaceTintColor,
    double? elevation,
    Color? shadowColor,
    ShapeBorder? shape,
    bool? showDragHandle,
    this.dragHandleColor,
    Size? dragHandleSize,
    Clip? clipBehavior,
    bool? enableDrag,
    double? maxHeight,
    double? minHeight,
    bool? resizeToAvoidBottomInset,
  })  : elevation = elevation ?? 1.0,
        shape = shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
        dragHandleSize = dragHandleSize ?? const Size(36, 4),
        clipBehavior = clipBehavior ?? Clip.antiAliasWithSaveLayer,
        enableDrag = enableDrag ?? true,
        showDragHandle = showDragHandle ?? true,
        shadowColor = shadowColor ?? Colors.transparent,
        maxHeight = maxHeight ?? 640.0,
        minHeight = minHeight ?? 300,
        resizeToAvoidBottomInset = resizeToAvoidBottomInset ?? false;

  factory WoltModalBottomSheetStyle.fromTheme(
    ThemeData themeData, {
    double? elevation,
    bool? showDragHandle,
    Size? dragHandleSize,
    Clip? clipBehavior,
    double? maxHeight,
    double? minHeight,
    bool? enableDrag,
    Color? shadowColor,
    ShapeBorder? shape,
    bool? resizeToAvoidBottomInset,
  }) {
    final colorsScheme = themeData.colorScheme;
    return WoltModalBottomSheetStyle(
      backgroundColor: colorsScheme.surface,
      surfaceTintColor: colorsScheme.surfaceTint,
      elevation: elevation,
      showDragHandle: showDragHandle,
      dragHandleColor: colorsScheme.onSurfaceVariant.withOpacity(0.4),
      dragHandleSize: dragHandleSize,
      clipBehavior: clipBehavior,
      maxHeight: maxHeight,
      minHeight: minHeight,
      enableDrag: enableDrag,
      shadowColor: shadowColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  final Color? backgroundColor;

  final Color? surfaceTintColor;

  final double elevation;

  final Color shadowColor;

  final ShapeBorder shape;

  final bool showDragHandle;

  final Color? dragHandleColor;

  final Size dragHandleSize;

  final Clip clipBehavior;

  final double maxHeight;

  final double minHeight;

  final bool enableDrag;

  final bool resizeToAvoidBottomInset;

  WoltModalBottomSheetStyle copyWith({
    Color? backgroundColor,
    Color? surfaceTintColor,
    double? elevation,
    Color? modalBackgroundColor,
    Color? shadowColor,
    double? modalElevation,
    ShapeBorder? shape,
    bool? showDragHandle,
    Color? dragHandleColor,
    Size? dragHandleSize,
    Clip? clipBehavior,
    double? maxHeight,
    double? minHeight,
    bool? enableDrag,
    bool? resizeToAvoidBottomInset,
  }) {
    return WoltModalBottomSheetStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      shape: shape ?? this.shape,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      dragHandleSize: dragHandleSize ?? this.dragHandleSize,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      maxHeight: maxHeight ?? this.maxHeight,
      minHeight: minHeight ?? this.minHeight,
      enableDrag: enableDrag ?? this.enableDrag,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
    );
  }

  WoltModalBottomSheetStyle lerp(WoltModalBottomSheetStyle? other, double t) {
    if (other == null) return this;

    return WoltModalBottomSheetStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      surfaceTintColor: Color.lerp(surfaceTintColor, other.surfaceTintColor, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      shape: ShapeBorder.lerp(shape, other.shape, t),
      showDragHandle: t < 0.5 ? showDragHandle : other.showDragHandle,
      dragHandleColor: Color.lerp(dragHandleColor, other.dragHandleColor, t),
      dragHandleSize: Size.lerp(dragHandleSize, other.dragHandleSize, t),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      maxHeight: t < 0.5 ? maxHeight : other.maxHeight,
      minHeight: t < 0.5 ? minHeight : other.minHeight,
    );
  }
}

class WoltModalDialogStyle extends ThemeExtension<WoltModalDialogStyle> {
  /// Creates a dialog theme that can be used for [ThemeData.dialogTheme].
  const WoltModalDialogStyle({
    this.backgroundColor,
    double? elevation,
    this.surfaceTintColor,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    double? maxHeight,
    double? minHeight,
    double? width,
  })  : elevation = elevation ?? 1.0,
        shape = shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
        alignment = alignment ?? Alignment.center,
        insetPadding = insetPadding ?? EdgeInsets.zero,
        clipBehavior = clipBehavior ?? Clip.antiAliasWithSaveLayer,
        maxHeight = maxHeight ?? 640.0,
        minHeight = minHeight ?? 300.0,
        width = width ?? 500.0;

  factory WoltModalDialogStyle.fromTheme(
    ThemeData themeData, {
    double? elevation,
    Clip? clipBehavior,
    double? maxHeight,
    double? minHeight,
    double? width,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    EdgeInsets? insetPadding,
  }) {
    final colorsScheme = themeData.colorScheme;
    return WoltModalDialogStyle(
      maxHeight: maxHeight,
      minHeight: minHeight,
      width: width,
      backgroundColor: colorsScheme.surface,
      surfaceTintColor: colorsScheme.surfaceTint,
      elevation: elevation,
      clipBehavior: clipBehavior,
      shape: shape,
      alignment: alignment,
      insetPadding: insetPadding,
    );
  }

  final Color? backgroundColor;

  final double elevation;

  final Color? surfaceTintColor;

  final ShapeBorder shape;

  final AlignmentGeometry alignment;

  final EdgeInsets insetPadding;

  final Clip clipBehavior;

  final double maxHeight;

  final double minHeight;

  final double width;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  @override
  WoltModalDialogStyle copyWith({
    Color? backgroundColor,
    double? elevation,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    EdgeInsets? insetPadding,
    Clip? clipBehavior,
    double? maxHeight,
    double? minHeight,
    double? width,
  }) {
    return WoltModalDialogStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      shape: shape ?? this.shape,
      alignment: alignment ?? this.alignment,
      insetPadding: insetPadding ?? this.insetPadding,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      maxHeight: maxHeight ?? this.maxHeight,
      minHeight: minHeight ?? this.minHeight,
      width: width ?? this.width,
    );
  }

  @override
  WoltModalDialogStyle lerp(WoltModalDialogStyle? other, double t) {
    if (other == null) return this;

    return WoltModalDialogStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      surfaceTintColor: Color.lerp(surfaceTintColor, other.surfaceTintColor, t),
      elevation: lerpDouble(elevation, other.elevation, t),
      shape: ShapeBorder.lerp(shape, other.shape, t),
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      insetPadding: EdgeInsets.lerp(insetPadding, other.insetPadding, t),
      maxHeight: t < 0.5 ? maxHeight : other.maxHeight,
      minHeight: t < 0.5 ? minHeight : other.minHeight,
      width: t < 0.5 ? width : other.width,
    );
  }
}
