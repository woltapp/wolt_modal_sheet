import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_breakpoints.dart';
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

  /// Whether to show the drag handle.
  @override
  bool get showDragHandle => enableDrag;

  /// Whether to enable the drag for bottom sheet.
  @override
  bool get enableDrag => true;

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

  /// The height of the navigation bar.
  @override
  double get navBarHeight => 72.0;

  /// Whether to show a top bar layer above the modal sheet.
  @override
  bool get hasTopBarLayer => true;

  /// Whether the top bar layer is always visible.
  @override
  bool get isTopBarLayerAlwaysVisible => false;

  /// Overrides the default value for [WoltModalSheet] clipBehavior.
  ///
  /// Defaults to [Clip.antiAliasWithSaveLayer].
  @override
  Clip get clipBehavior => Clip.antiAliasWithSaveLayer;

  /// A boolean that determines whether the modal should avoid system UI intrusions such as the
  /// notch and system gesture areas.
  @override
  bool get useSafeArea => true;

  /// [mainContentScrollPhysics] sets the scrolling behavior for the main content area of the
  /// WoltModalSheet, defaulting to [ClampingScrollPhysics]. This physics type is chosen for
  /// several key reasons:
  ///
  /// 1. **Prevent Overscroll:** ClampingScrollPhysics stops the scrollable content from moving
  /// beyond the viewport's bounds. This clear boundary is crucial for drag-to-dismiss feature,
  /// ensuring that any drag beyond the scroll limit is recognized as an intent to dismiss the
  /// modal.
  ///
  /// 2. **Clear Interaction Boundaries:** By preventing the content from bouncing or scrolling
  /// past the edge, users receive clear feedback that reaching the end of the scrollable area can
  /// transition to other interactions, like closing the modal. This helps avoid confusion
  /// between scrolling and modal dismissal gestures.
  ///
  /// 3. **Simplify Gesture Detection:** Using ClampingScrollPhysics simplifies the detection of
  /// user gestures, differentiating more reliably between scrolling and actions intended to
  /// dismiss the modal. This reduces the complexity and potential errors in handling these
  /// interactions.
  ///
  /// Choosing alternative scroll physics like [BouncingScrollPhysics] or [ElasticScrollPhysics]
  /// could disrupt the drag-to-dismiss feature. These physics allow content to move beyond
  /// scroll limits, which can interfere with gesture recognition, making it unclear whether a
  /// gesture is intended for scrolling or dismissing the modal. As a result, drag-to-dismiss
  /// would only be functional with a custom drag handle, limiting interaction flexibility on
  /// main content area.
  @override
  ScrollPhysics get mainContentScrollPhysics => const ClampingScrollPhysics();

  @override
  WoltModalTypeBuilder get modalTypeBuilder => (context) {
        final width = MediaQuery.sizeOf(context).width;
        if (width < WoltBreakpoints.small.minValue) {
          return WoltModalType.bottomSheet();
        }
        return WoltModalType.dialog();
      };

  /// Motion animation styles for both pagination and page scrolling.
  @override
  WoltModalSheetAnimationStyle get animationStyle =>
      const WoltModalSheetAnimationStyle();
}
