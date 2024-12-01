import 'dart:ui';

import 'package:demo_ui_components/demo_ui_components.dart';

enum WoltElevatedButtonTheme {
  secondary,
  primary;

  const WoltElevatedButtonTheme();

  Color enabledForegroundColor(WoltColorName colorName) {
    switch (this) {
      case WoltElevatedButtonTheme.primary:
        return WoltColorName.white.color100;
      case WoltElevatedButtonTheme.secondary:
        return colorName.color100;
    }
  }

  Color disabledForegroundColor(WoltColorName colorName) {
    switch (this) {
      case WoltElevatedButtonTheme.primary:
        return colorName.color16;
      case WoltElevatedButtonTheme.secondary:
        return colorName.color48;
    }
  }

  Color enabledBackgroundColor(WoltColorName colorName) {
    switch (this) {
      case WoltElevatedButtonTheme.primary:
        return colorName.color100;
      case WoltElevatedButtonTheme.secondary:
        return colorName.color8;
    }
  }

  Color disabledBackgroundColor(WoltColorName colorName) {
    switch (this) {
      case WoltElevatedButtonTheme.primary:
        return colorName.color64;
      case WoltElevatedButtonTheme.secondary:
        return enabledBackgroundColor(colorName);
    }
  }

  Color splashColor(WoltColorName colorName) {
    switch (this) {
      case WoltElevatedButtonTheme.primary:
        return WoltColorName.white.color100.withOpacity(0.12);
      case WoltElevatedButtonTheme.secondary:
        return colorName.color100.withOpacity(0.12);
    }
  }
}
