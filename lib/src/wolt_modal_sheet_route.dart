import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetRoute<T> extends PageRoute<T> {
  WoltModalSheetRoute({
    required this.pageListBuilderNotifier,
    this.pageIndexNotifier,
    this.decorator,
    this.onModalDismissedWithBarrierTap,
    this.onModalDismissedWithDrag,
    this.modalBarrierColor,
    WoltModalTypeBuilder? modalTypeBuilder,
    bool? enableDrag,
    bool? showDragHandle,
    bool? useSafeArea,
    bool? barrierDismissible,
    AnimationController? transitionAnimationController,
    RouteSettings? routeSettings,
    Duration? transitionDuration,
  })  : _enableDrag = enableDrag,
        _showDragHandle = showDragHandle,
        _useSafeArea = useSafeArea ?? true,
        _transitionAnimationController = transitionAnimationController,
        _transitionDuration =
            transitionDuration ?? const Duration(milliseconds: 300),
        _barrierDismissible = barrierDismissible ?? true,
        _modalTypeBuilder = modalTypeBuilder,
        super(settings: routeSettings);

  Widget Function(Widget)? decorator;

  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  final ValueNotifier<int>? pageIndexNotifier;

  final WoltModalTypeBuilder? _modalTypeBuilder;

  late final Duration _transitionDuration;

  late final bool _barrierDismissible;

  final VoidCallback? onModalDismissedWithBarrierTap;

  final VoidCallback? onModalDismissedWithDrag;

  final bool? _enableDrag;

  final bool? _showDragHandle;

  final bool _useSafeArea;

  /// Specifies the color of the modal barrier that darkens everything below the
  /// bottom sheet.
  ///
  /// Defaults to `Colors.black54` if not provided.
  final Color? modalBarrierColor;

  /// The animation controller that controls the bottom sheet's entrance and
  /// exit animations.
  ///
  /// The BottomSheet widget will manipulate the position of this animation, it
  /// is not just a passive observer.
  final AnimationController? _transitionAnimationController;

  @override
  bool get barrierDismissible => _barrierDismissible;

  /// The value of false was chosen to indicate that the modal route does not fully obscure the
  /// underlying content. This allows for a translucent effect, where the content beneath the
  /// modal is partially visible.
  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  String? get barrierLabel => 'Modal barrier';

  AnimationController? animationController;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return WoltModalSheet(
      route: this,
      decorator: decorator,
      pageIndexNotifier: pageIndexNotifier ?? ValueNotifier(0),
      pageListBuilderNotifier: pageListBuilderNotifier,
      modalTypeBuilder: _modalTypeBuilder ??
          WoltModalSheetDefaultThemeData(context).modalTypeBuilder,
      onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
      onModalDismissedWithDrag: onModalDismissedWithDrag,
      animationController: animationController,
      enableDrag: _enableDrag,
      showDragHandle: _showDragHandle,
      useSafeArea: _useSafeArea,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final builder = _modalTypeBuilder ??
        WoltModalSheetDefaultThemeData(context).modalTypeBuilder;
    final modalType = builder(context);
    return modalType.buildTransitions(
        context, animation, secondaryAnimation, child);
  }

  @override
  Color? get barrierColor => modalBarrierColor ?? Colors.black54;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  AnimationController createAnimationController() {
    assert(animationController == null);
    if (_transitionAnimationController != null) {
      animationController = _transitionAnimationController;
      willDisposeAnimationController = false;
    } else {
      animationController = BottomSheet.createAnimationController(navigator!);
    }
    return animationController!;
  }
}
