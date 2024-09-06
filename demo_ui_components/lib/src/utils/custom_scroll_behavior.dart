import 'dart:ui';

import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior({this.androidSdkVersion});
  final int? androidSdkVersion;

  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final glowingOverscrollIndicator = GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: Theme.of(context).colorScheme.primary,
      child: child,
    );
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
      case TargetPlatform.android:
        final androidSdkVer = androidSdkVersion;
        if (androidSdkVer != null && androidSdkVer > 30) {
          return StretchingOverscrollIndicator(
            axisDirection: details.direction,
            child: child,
          );
        }
        return glowingOverscrollIndicator;
      case TargetPlatform.fuchsia:
        return glowingOverscrollIndicator;
    }
  }
}
