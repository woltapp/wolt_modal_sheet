import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/theme/wolt_modal_sheet_theme_data.dart';

class ThemeResolver extends StatefulWidget {
  final Widget child;
  final WoltModalSheetStyle? styleOverride;

  const ThemeResolver({
    super.key,
    required this.child,
    this.styleOverride,
  });

  @override
  State<ThemeResolver> createState() => _ThemeResolverState();
}

class _ThemeResolverState extends State<ThemeResolver> {
  late ThemeData _themeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _resolveTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeData,
      child: widget.child,
    );
  }

  void _resolveTheme() {
    final theme = Theme.of(context);
    final woltModalSheetTheme = theme.extension<WoltModalSheetTheme>();
    final styleOverride = widget.styleOverride;

    if (styleOverride != null) {
      final extensions = theme.extensions.values;

      _themeData = theme.copyWith(extensions: [
        ...extensions.where((e) => e is! WoltModalSheetTheme),
        WoltModalSheetTheme(style: styleOverride),
      ]);
    } else {
      if (woltModalSheetTheme != null) {
        _themeData = theme;
      } else {
        final extensions = theme.extensions.values;
        _themeData = theme.copyWith(extensions: [
          ...extensions,
          WoltModalSheetTheme(),
        ]);
      }
    }
  }
}
