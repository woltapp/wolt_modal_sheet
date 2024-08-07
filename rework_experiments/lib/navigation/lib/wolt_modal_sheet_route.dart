import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path_settings.dart';

/// An imperative way to show [WoltModalSheet].
Future<T?> showWoltModalSheet<T>({
  required List<WoltModalSheetPathSettings> supportedPaths,
  required BuildContext context,
  required List<WoltModalSheetPath> initialPath,
  bool isDismissible = true,
  bool useRootNavigator = false,
  Color? modalBarrierColor,
  Duration? transitionDuration,
  String? barrierLabel,
  RouteSettings? settings,
}) {
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );

  return navigator.push(
    WoltModalSheetRoute(
      supportedPaths: supportedPaths,
      initialPath: initialPath,
      modalBarrierColor: modalBarrierColor,
      isDismissible: isDismissible,
      transitionDuration: transitionDuration,
      barrierLabel: barrierLabel,
      settings: settings,
    ),
  );
}

class WoltModalSheetRoute<T> extends PopupRoute<T> {
  /// Specifies the color of the modal barrier that darkens everything below the
  /// bottom sheet.
  ///
  /// Defaults to `Colors.black54` if not provided.
  final Color? modalBarrierColor;

  /// All the pages that the bottom tire can display.
  final List<WoltModalSheetPathSettings> supportedPaths;

  /// Initial page, or set of initial pages.
  final List<WoltModalSheetPath> initialPath;

  final bool isDismissible;

  late final String? _barrierLabel;

  late final Duration _transitionDuration;

  WoltModalSheetRoute({
    required this.supportedPaths,
    required this.initialPath,
    this.isDismissible = true,
    this.modalBarrierColor,
    Duration? transitionDuration,
    String? barrierLabel,
    super.settings,
  }) {
    _transitionDuration =
        transitionDuration ?? const Duration(milliseconds: 300);
    _barrierLabel = barrierLabel ?? 'Modal barrier';
  }

  @override
  Color? get barrierColor => modalBarrierColor ?? Colors.black54;

  @override
  String? get barrierLabel => _barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return WoltModalSheet(
      supportedPaths: supportedPaths,
      initialPath: initialPath,
    );
  }

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  bool get barrierDismissible => isDismissible;
}
