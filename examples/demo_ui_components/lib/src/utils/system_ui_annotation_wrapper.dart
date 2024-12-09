import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that wraps another widget and applies a System UI overlay style.
///
/// This wrapper is responsible for setting the color and brightness of the
/// system navigation bar and status bar based on the provided parameters and
/// the current theme context. The system navigation bar color changes based on
/// if there is no bottom navigation bar present.
///
/// The `SystemUiOverlayStyle` is adjusted to reflect the theme's color scheme
/// and brightness, ensuring that the system UI integrates well with the overall
/// app design.
///
/// Parameters:
/// - [child]: The [Widget] that this wrapper will contain. This is the content
///   that will be displayed within the wrapper.
/// - [hasBottomNavigationBar]: A flag to indicate whether the wrapped widget
///   contains a bottom navigation bar. This affects the color of the
///   system navigation bar.
///
/// Usage:
/// ```dart
/// SystemUIAnnotationWrapper(
///   child: YourChildWidget(),
///   hasBottomNavigationBar: true, // Set to true if your child has a bottom navigation bar
/// )
/// ```
class SystemUIAnnotationWrapper extends StatelessWidget {
  final Widget child;
  final bool hasBottomNavigationBar;

  const SystemUIAnnotationWrapper({
    super.key,
    required this.child,
    this.hasBottomNavigationBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _createSystemUiOverlayStyle(
        Theme.of(context).colorScheme,
        hasBottomNavigationBar,
      ),
      child: child,
    );
  }

  static void setSystemUIOverlayStyle(
    ColorScheme colorScheme, {
    bool hasBottomNavigationBar = false,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      _createSystemUiOverlayStyle(colorScheme, hasBottomNavigationBar),
    );
  }

  static SystemUiOverlayStyle _createSystemUiOverlayStyle(
    ColorScheme colorScheme,
    bool hasBottomNavigationBar,
  ) {
    const inverseBrightness = Brightness.dark;
    final navigationBarColor =
        hasBottomNavigationBar ? Colors.white : colorScheme.surface;

    return SystemUiOverlayStyle(
      // Honored in Android. Sets the background color of the navigation bar.
      systemNavigationBarColor: navigationBarColor,
      // Honored in Android. Sets the divider color of the navigation bar.
      systemNavigationBarDividerColor: navigationBarColor,
      // Honored in Android. Sets the brightness of the icons in the navigation bar (light or dark).
      systemNavigationBarIconBrightness: inverseBrightness,
      // Honored in Android. Whether or not to enforce contrast ratio for navigation bar icons.
      systemNavigationBarContrastEnforced: false,
      // Only honored in Android version M and greater. This is why we use transparent color here
      // and get the actual color from top bar brightness and color.
      statusBarColor: Colors.transparent,
      // Honored in iOS. This influences the color of text and icons.
      statusBarBrightness: colorScheme.brightness,
      // Only honored in Android version M and greater.
      statusBarIconBrightness: inverseBrightness,
      // Honored in Android.
      systemStatusBarContrastEnforced: false,
    );
  }
}
