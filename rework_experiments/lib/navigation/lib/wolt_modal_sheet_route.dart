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

/// Rout for displaying the [WoltModalSheet].
class WoltModalSheetRoute<T> extends PopupRoute<T> {
  /// All the pages that the bottom tire can display.
  final List<WoltModalSheetPathSettings> supportedPaths;

  /// Initial page, or set of initial paths.
  final List<WoltModalSheetPath> initialPath;

  /// Specifies whether the bottom sheet will be dismissed
  /// when user taps on the scrim.
  ///
  /// If true, the bottom sheet will be dismissed when user taps on the scrim.
  ///
  /// Defaults to true.
  final bool isDismissible;

  /// Specifies the color of the modal barrier that darkens everything below the
  /// bottom sheet.
  ///
  /// Defaults to `Colors.black54` if not provided.
  final Color? modalBarrierColor;

  /// Callback function that is triggered whenever there is a change in navigation
  /// within the [WoltModalSheet].
  /// The function receives a list of the current active routes as a parameter, allowing
  /// you to track and respond to navigation changes.
  final Function(List<WoltModalSheetPath>)? onPathChangedInternal;

  late final Duration _transitionDuration;

  late final String? _barrierLabel;

  late final BoxConstraints _constraints;


  WoltModalSheetRoute({
    required this.supportedPaths,
    required this.initialPath,
    this.isDismissible = true,
    this.modalBarrierColor,
    this.onPathChangedInternal,
    Duration? transitionDuration,
    String? barrierLabel,
    BoxConstraints? constraints,
    super.settings,
  }) {
    _transitionDuration =
        transitionDuration ?? const Duration(milliseconds: 300);
    _barrierLabel = barrierLabel ?? 'Modal barrier';
    _constraints = constraints ?? const BoxConstraints(maxHeight: 300);
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
    final routeController = controller;
    return WoltModalSheet(
      constraints: _constraints,
      supportedPaths: supportedPaths,
      initialPath: initialPath,
      appearingAnimationController: routeController,
      onPathChangedInternal: onPathChangedInternal,
    );
  }

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  bool get barrierDismissible => isDismissible;
}

/// A page that creates a [WoltModalSheet] style [PageRoute].
///
/// Example of usage with GoRouter:
///
///  GoRoute(
///    name: 'bottom_sheet',
///    path: 'bottom_sheet/:pages',
///    pageBuilder: (BuildContext context, GoRouterState state) {
///        return WoltModalSheetPage(
///               supportedPaths: supportedPaths,
///               initialPath: pages,
///               ),
///             }
class WoltModalSheetPage extends Page {
  /// All the pages that the bottom tire can display.
  final List<WoltModalSheetPathSettings> supportedPaths;

  /// Initial page, or set of initial pages.
  final List<WoltModalSheetPath> initialPath;

  /// Data that might be useful in constructing a [Route].
  final RouteSettings? settings;

  final BoxConstraints? constraints;

  /// Callback function that is triggered whenever there is a change in navigation
  /// within the [WoltModalSheet].
  /// The function receives a list of the current active routes as a parameter, allowing
  /// you to track and respond to navigation changes.
  final Function(List<WoltModalSheetPath>)? onPathChangedInternal;

  const WoltModalSheetPage({
    required this.supportedPaths,
    required this.initialPath,
    this.settings,
    this.constraints,
    this.onPathChangedInternal,
  });

  @override
  Route createRoute(BuildContext context) {
    return WoltModalSheetRoute(
      initialPath: initialPath,
      supportedPaths: supportedPaths,
      settings: settings ?? this,
      onPathChangedInternal: onPathChangedInternal,
      constraints: constraints,
    );
  }
}
