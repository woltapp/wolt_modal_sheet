import 'package:flutter/widgets.dart';

/// A widget that extends the tinted background color into the top safe area.
///
/// This widget is designed to ensure visual continuity by filling the top safe area
/// with a specified color. It's useful in modal types or full-screen layouts where the
/// background color needs to extend into the top padding area of the device.
///
/// The `safeAreaColor` is the color used to fill the top safe area, and `width` controls
/// the horizontal extent of the colored area, defaulting to spanning the full width.
class WoltModalTypeTopSafeAreaFilling extends StatelessWidget {
  /// Creates a widget that fills the top safe area with a color.
  ///
  /// The `safeAreaColor` must be provided. Optionally, the `width` can be adjusted to
  /// control the horizontal span of the color fill.
  const WoltModalTypeTopSafeAreaFilling(
    this.safeAreaColor, {
    this.width = double.infinity,
    super.key,
  });

  final Color safeAreaColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(height: MediaQuery.paddingOf(context).top, width: width),
    );
  }
}

/// A widget that extends the tinted background color into the bottom safe area.
///
/// Ideal for modal bottom sheets or other components reaching the bottom edge of the device
/// screen, this widget fills the bottom safe area with a specified color to maintain uniform
/// background appearance, especially on devices with notable bottom padding.
class WoltModalTypeBottomSafeAreaFilling extends StatelessWidget {
  /// Creates a widget that fills the bottom safe area with a color.
  ///
  /// The `safeAreaColor` must be provided. The `width` controls the horizontal extent
  /// of the color fill, defaulting to spanning the full width.
  const WoltModalTypeBottomSafeAreaFilling(
    this.safeAreaColor, {
    this.width = double.infinity,
    super.key,
  });

  final Color safeAreaColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: safeAreaColor,
      child:
          SizedBox(height: MediaQuery.paddingOf(context).bottom, width: width),
    );
  }
}

/// A widget that fills the start side of the safe area with a color, respecting text direction.
///
/// This widget is crucial for supporting both right-to-left (RTL) and left-to-right (LTR) text
/// directions. It ensures that side navigation drawers or side sheets seamlessly extend into
/// the safe area on the start side of the screen, matching the background color.
class WoltModalTypeStartSafeAreaFilling extends StatelessWidget {
  /// Creates a widget that fills the start side safe area with a color.
  ///
  /// The `safeAreaColor` is used to match the modal's or screen's background.
  const WoltModalTypeStartSafeAreaFilling(
    this.safeAreaColor, {
    super.key,
  });

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(
        height: double.infinity,
        width:
            textDirection == TextDirection.ltr ? padding.left : padding.right,
      ),
    );
  }
}

/// A widget that fills the end side of the safe area with a specified color, sensitive to text
/// direction.
///
/// This widget helps maintain visual continuity by extending the background color to the end side
/// of the screen. It adapts to the layout direction of the language (LTR or RTL), making it
/// ideal for side sheets that extend to the edges of the screen in various text environments.
class WoltModalTypeEndSafeAreaFilling extends StatelessWidget {
  /// Creates a widget that fills the end side safe area with a color.
  ///
  /// The `safeAreaColor` is used to maintain consistency with the modal's or screen's background.
  const WoltModalTypeEndSafeAreaFilling(
    this.safeAreaColor, {
    super.key,
  });

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    return ColoredBox(
      color: safeAreaColor,
      child: SizedBox(
        height: double.infinity,
        width:
            textDirection == TextDirection.ltr ? padding.right : padding.left,
      ),
    );
  }
}
