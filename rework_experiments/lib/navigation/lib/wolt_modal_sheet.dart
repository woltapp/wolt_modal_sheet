import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/theme/theme_resolver.dart';
import 'package:rework_experiments/navigation/lib/theme/wolt_modal_sheet_theme_data.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_coordinator.dart';
import 'package:rework_experiments/navigation/lib/type/wolt_modal_sheet_type_delegate.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_navigator.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_page.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/navigation/internal/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/lib/type/wolt_modal_type_adapter.dart';

part 'navigation/navigation_stack.dart';
part 'navigation/navigation_size_adapter.dart';

/// Main widget for displaying the [WoltModalSheet] and using the [WoltModalSheetNavigator].
/// It is important to pass all the supported pages that can be displayed
/// in the [WoltModalSheet].
///
/// If you want to receive updates from the [WoltModalSheet] about navigation
/// changes, pass the [onPathChangedInternal] function. It will provide you
/// a list of active routes, allowing you to process them as needed.
class WoltModalSheet extends StatefulWidget {
  /// All the pages that the modal sheet can display.
  final List<WoltModalSheetPathSettings> supportedPaths;

  /// Initial paths, that are shown on modal sheet appears.
  final List<WoltModalSheetPath> initialPath;

  final BoxConstraints constraints;

  /// Callback function that is triggered whenever there is a change in navigation
  /// within the [WoltModalSheet].
  /// The function receives a list of the current active routes as a parameter, allowing
  /// you to track and respond to navigation changes.
  final Function(List<WoltModalSheetPath>)? onPathChangedInternal;

  final VoidCallback? closeModalSheetDelegate;

  final AnimationController? appearingAnimationController;

  final WoltModalSheetDelegate? woltModalSheetDelegate;

  final WoltModalSheetStyle? style;

  const WoltModalSheet({
    super.key,
    required this.supportedPaths,
    required this.initialPath,
    required this.constraints,
    this.onPathChangedInternal,
    this.closeModalSheetDelegate,
    this.appearingAnimationController,
    this.woltModalSheetDelegate,
    this.style,
  });

  @override
  State<WoltModalSheet> createState() => _WoltModalSheetState();
}

class _WoltModalSheetState extends State<WoltModalSheet> {
  final _navigationContentKey = GlobalKey<NavigatorState>();
  late final WoltModalSheetCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator =
        WoltModalSheetCoordinator(_onPathChanged, _onModalSheetEmpty);
    _coordinator.init(widget.supportedPaths, widget.initialPath);
  }

  @override
  void didUpdateWidget(WoltModalSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialPath != widget.initialPath) {
      _coordinator.actualizeNavigationStack(widget.initialPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WoltModalSheetNavigator(
      coordinator: _coordinator,
      child: ThemeResolver(
        styleOverride: widget.style,
        child: WoltModalTypeAdapter(
          bottomSheetController: widget.appearingAnimationController,
          woltModalSheetDelegate: widget.woltModalSheetDelegate,
          child: _NavigationSizeAdapter(
            key: _navigationContentKey,
            coordinator: _coordinator,
          ),
        ),
      ),
    );
  }

  void _onPathChanged(List<WoltModalSheetPath> path) {
    widget.onPathChangedInternal?.call(path);
  }

  void _onModalSheetEmpty() {
    final closeDelegate = widget.closeModalSheetDelegate;
    if (closeDelegate != null) {
      closeDelegate.call();
    } else {
      Navigator.of(context).pop();
    }
  }
}
