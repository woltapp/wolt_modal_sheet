import 'package:flutter/widgets.dart';

/// A widget designed to fill the top safe area with a specified color.
/// This is particularly useful for modal types or full-screen widgets that
/// need to extend their background color into the top safe area of the device,
/// ensuring a cohesive visual appearance.
///
/// Attributes:
///   [safeAreaColor]: The color used to fill the top safe area.
///   [width]: The width of the filling area, defaulting to infinity to span the full width.
///
/// Usage:
/// This widget can be used within any modal or full-screen layout that requires
/// the top padding area of the device to be colored, ensuring that the color continuity
/// of the modal's background is maintained.
class WoltModalTypeTopSafeAreaFilling extends StatelessWidget {
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
      child: SizedBox(height: MediaQuery.of(context).padding.top, width: width),
    );
  }
}

/// A widget designed to fill the bottom safe area with a specified color.
/// It is used in the context of modal implementations or full-screen views where
/// the extension of the background color into the bottom safe area is needed for visual
/// consistency.
///
/// Attributes:
///   [safeAreaColor]: The color used to fill the bottom safe area.
///   [width]: The width of the filling area, usually spanning the full width of the screen.
///
/// Usage:
/// Ideal for use in modal bottom sheets or other components that reach the bottom of the device
/// screen and need to maintain a uniform background, especially on devices with notable bottom
/// padding.
class WoltModalTypeBottomSafeAreaFilling extends StatelessWidget {
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
          SizedBox(height: MediaQuery.of(context).padding.bottom, width: width),
    );
  }
}

/// A widget that fills the start side of the safe area with a color, adapting to text direction.
/// This is crucial for supporting right-to-left (RTL) and left-to-right (LTR) languages,
/// ensuring the modal or full-screen layout respects the safe area on the start side.
///
/// Attributes:
///   [safeAreaColor]: The color used to fill the start safe area, matching the modal's or
///   screen's background.
///
/// Usage:
/// Use this widget to ensure that side navigation drawers or side sheets seamlessly blend with
/// the safe area padding, particularly in RTL layouts where the start may be on the right.
class WoltModalTypeStartSafeAreaFilling extends StatelessWidget {
  const WoltModalTypeStartSafeAreaFilling(
    this.safeAreaColor, {
    super.key,
  });

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.of(context).padding;
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

/// A widget that fills the end side of the safe area with a specified color,
/// sensitive to the current text direction. It ensures visual continuity on the
/// end side of modal types or full-screen layouts, adapting based on the layout
/// direction of the language (LTR or RTL).
///
/// Attributes:
///   [safeAreaColor]: The color used to fill the end safe area.
///
/// Usage:
/// Useful in scenarios where side sheet extends to the edges of the screen, this widget helps
/// maintain a consistent look by filling the end safe area, respecting RTL and LTR settings.
class WoltModalTypeEndSafeAreaFilling extends StatelessWidget {
  const WoltModalTypeEndSafeAreaFilling(
    this.safeAreaColor, {
    super.key,
  });

  final Color safeAreaColor;

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets padding = MediaQuery.of(context).padding;
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
