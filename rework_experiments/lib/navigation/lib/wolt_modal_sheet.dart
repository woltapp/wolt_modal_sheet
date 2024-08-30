import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation/lib/theme/theme_resolver.dart';
import 'package:rework_experiments/navigation/lib/theme/wolt_modal_sheet_theme_data.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_coordinator.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_delegate.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_navigator.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_page.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path_settings.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_sheet_path.dart';
import 'package:rework_experiments/navigation/lib/wolt_modal_type_adapter.dart';

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

  /// Callback function that is triggered whenever there is a change in navigation
  /// within the [WoltModalSheet].
  /// The function receives a list of the current active routes as a parameter, allowing
  /// you to track and respond to navigation changes.
  final Function(List<WoltModalSheetPath>)? onPathChangedInternal;

  final WoltModalSheetStyle? style;

  final BoxConstraints constraints;

  final AnimationController? appearingAnimationController;

  final WoltModalSheetDelegate? woltModalSheetDelegate;

  const WoltModalSheet({
    super.key,
    required this.supportedPaths,
    required this.initialPath,
    required this.constraints,
    this.onPathChangedInternal,
    this.appearingAnimationController,
    this.woltModalSheetDelegate,
    this.style,
  });

  @override
  State<WoltModalSheet> createState() => _WoltModalSheetState();
}

class _WoltModalSheetState extends State<WoltModalSheet> {
  final _navigationContentKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ThemeResolver(
      styleOverride: widget.style,
      child: WoltModalTypeAdapter(
        bottomSheetController: widget.appearingAnimationController,
        woltModalSheetDelegate: widget.woltModalSheetDelegate,
        child: _NavigationSizeAdapter(
          key: _navigationContentKey,
          onPathChangedInternal: widget.onPathChangedInternal,
          initialPath: widget.initialPath,
          supportedPaths: widget.supportedPaths,
        ),
      ),
    );
  }
}

class _NavigationSizeAdapter extends StatefulWidget {
  final Function(List<WoltModalSheetPath>)? onPathChangedInternal;
  final List<WoltModalSheetPathSettings> supportedPaths;
  final List<WoltModalSheetPath> initialPath;

  const _NavigationSizeAdapter({
    super.key,
    required this.supportedPaths,
    required this.initialPath,
    this.onPathChangedInternal,
  });

  @override
  State<_NavigationSizeAdapter> createState() => _NavigationSizeAdapterState();
}

class _NavigationSizeAdapterState extends State<_NavigationSizeAdapter>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _sizeChangedNotifier;
  late final WoltModalSheetCoordinator _coordinator;
  late final AnimationController _sizeAnimationController;
  late Animation<double> _heightAnimation;

  GlobalKey? _topPageKey;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _coordinator = WoltModalSheetCoordinator(_onPathChanged);
    _coordinator.init(widget.supportedPaths, widget.initialPath);

    _sizeChangedNotifier = ValueNotifier<double>(0);
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = _createAnimation(0, 0);
    _sizeAnimationController.forward(from: 1);
  }

  @override
  void didUpdateWidget(covariant _NavigationSizeAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialPath != widget.initialPath) {
      _coordinator.actualizeNavigationStack(widget.initialPath);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Subscribe on constraints changing.
    _actualizeConstraints(ConstraintsProvider.of(context).constraints);
  }

  @override
  void dispose() {
    _sizeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _sizeChangedNotifier,
      builder: (context, height, child) => _AnimatedSizeWidget(
        heightAnimation: _heightAnimation,
        child: ClipRRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Builder(builder: (context) {
                  return ConstrainedBox(
                    constraints: ConstraintsProvider.of(context).constraints,
                    child: WoltModalSheetNavigator(
                      coordinator: _coordinator,
                      child: _NavigationStack(
                        changePagesNotifier: _coordinator.pagesPublisher,
                        onTopPageChanged: _onTopPageChanged,
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onPathChanged(List<WoltModalSheetPath> path) {
    widget.onPathChangedInternal?.call(path);
  }

  Animation<double> _createAnimation(double begin, double end) {
    return Tween<double>(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(_sizeAnimationController);
  }

  void _actualizeConstraints(BoxConstraints constraints) {
    if (!_isInitialized) {
      // postpone for the first call of _onTopPageChanged;
      return;
    }

    _updateSize(isAnimated: false);
  }

  void _onTopPageChanged(GlobalKey? topPageKey) {
    _topPageKey = topPageKey;

    if (!_isInitialized) {
      // first time handled;
      _isInitialized = true;
      _updateSize(isAnimated: false);
    } else {
      _updateSize(isAnimated: true);
    }
  }

  void _updateSize({bool isAnimated = true}) {
    final topPageKey = _topPageKey;

    if (topPageKey != null) {
      _waitForLayoutAndUpdateConstraints(topPageKey, isAnimated: isAnimated);
    } else {
      final currentHeight = _sizeChangedNotifier.value;
      final targetHeight =
          ConstraintsProvider.of(context).constraints.maxHeight;

      if (currentHeight == targetHeight) {
        return;
      }

      _sizeChangedNotifier.value = targetHeight;
      _heightAnimation = _createAnimation(currentHeight, targetHeight);
      _sizeAnimationController.forward(from: isAnimated ? 0 : 1);
    }
  }

  void _waitForLayoutAndUpdateConstraints(
    GlobalKey key, {
    bool isAnimated = true,
  }) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          final size = key.currentContext?.size;
          if (size != null) {
            final currentHeight = _sizeChangedNotifier.value;
            final targetHeight = size.height;

            if (currentHeight == targetHeight) {
              return;
            }

            _sizeChangedNotifier.value = targetHeight;
            _heightAnimation = _createAnimation(currentHeight, targetHeight);
            _sizeAnimationController.forward(from: isAnimated ? 0 : 1);
          }
        }
      },
    );
  }
}

class _AnimatedSizeWidget extends AnimatedWidget {
  final Widget child;
  final Animation<double> heightAnimation;

  const _AnimatedSizeWidget({
    Key? key,
    required this.child,
    required this.heightAnimation,
  }) : super(key: key, listenable: heightAnimation);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightAnimation.value,
      child: child,
    );
  }
}

class _NavigationStack extends StatefulWidget {
  final ValueListenable<List<Page>> changePagesNotifier;
  final Function(GlobalKey?) onTopPageChanged;

  const _NavigationStack({
    required this.changePagesNotifier,
    required this.onTopPageChanged,
  });

  @override
  State<_NavigationStack> createState() => _NavigationStackState();
}

class _NavigationStackState extends State<_NavigationStack> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.changePagesNotifier,
      builder: (context, listPages, child) => Navigator(
        key: _navigatorKey,
        pages: listPages,
        clipBehavior: Clip.none,
        observers: [
          _WoltNavigatorObserver(widget.onTopPageChanged, context),
        ],
        onDidRemovePage: (page) {},
      ),
    );
  }
}

class _WoltNavigatorObserver extends NavigatorObserver {
  final BuildContext context;
  final Function(GlobalKey?) onTopPageChanged;

  _WoltNavigatorObserver(this.onTopPageChanged, this.context);

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is WoltModalPageRoute) {
      onTopPageChanged(route.contentKey);
    } else {
      onTopPageChanged(null);
    }

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute is WoltModalPageRoute) {
      onTopPageChanged(previousRoute.contentKey);
    } else {
      onTopPageChanged(null);
    }

    super.didPop(route, previousRoute);
  }
}
