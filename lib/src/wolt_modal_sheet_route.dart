import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

double _defaultModalTypeBreakPoint = 768.0;

WoltModalTypeBuilder _defaultModalTypeBuilder = (context) {
  return MediaQuery.sizeOf(context).width < _defaultModalTypeBreakPoint
      ? WoltModalType.bottomSheet
      : WoltModalType.dialog;
};

class WoltModalSheetRoute<T> extends PageRoute<T> {
  WoltModalSheetRoute({
    required this.pageListBuilderNotifier,
    this.pageIndexNotifier,
    this.decorator,
    this.onModalDismissedWithBarrierTap,
    this.onModalDismissedWithDrag,
    this.modalBarrierColor,
    WoltModalTypeBuilder? modalTypeBuilder,
    bool? enableCloseDrag,
    bool? enableDrag,
    bool? showDragHandle,
    bool? useSafeArea,
    bool? barrierDismissible,
    AnimationController? transitionAnimationController,
    RouteSettings? routeSettings,
    Duration? transitionDuration,
    AnimatedWidget? bottomSheetTransitionAnimation,
    AnimatedWidget? dialogTransitionAnimation,
    double? minDialogWidth,
    double? maxDialogWidth,
    double? minPageHeight,
    double? maxPageHeight,
  })  : _enableCloseDrag = enableCloseDrag,
        _enableDrag = enableDrag,
        _showDragHandle = showDragHandle,
        _useSafeArea = useSafeArea ?? true,
        _transitionAnimationController = transitionAnimationController,
        _transitionDuration =
            transitionDuration ?? const Duration(milliseconds: 300),
        _barrierDismissible = barrierDismissible ?? true,
        _modalTypeBuilder = modalTypeBuilder ?? _defaultModalTypeBuilder,
        _bottomSheetTransitionAnimation = bottomSheetTransitionAnimation,
        _dialogTransitionAnimation = dialogTransitionAnimation,
        _minDialogWidth = minDialogWidth,
        _maxDialogWidth = maxDialogWidth,
        _minPageHeight = minPageHeight,
        _maxPageHeight = maxPageHeight,
        super(settings: routeSettings);

  Widget Function(Widget)? decorator;

  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  final ValueNotifier<int>? pageIndexNotifier;

  final WoltModalTypeBuilder _modalTypeBuilder;

  late final Duration _transitionDuration;

  late final bool _barrierDismissible;

  final VoidCallback? onModalDismissedWithBarrierTap;

  final VoidCallback? onModalDismissedWithDrag;

  final bool? _enableCloseDrag;

  final bool? _enableDrag;

  final bool? _showDragHandle;

  final bool _useSafeArea;

  final AnimatedWidget? _bottomSheetTransitionAnimation;

  final AnimatedWidget? _dialogTransitionAnimation;

  final double? _minDialogWidth;

  final double? _maxDialogWidth;

  final double? _minPageHeight;

  final double? _maxPageHeight;

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
      modalTypeBuilder: _modalTypeBuilder,
      onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
      onModalDismissedWithDrag: onModalDismissedWithDrag,
      animationController: animationController,
      enableCloseDrag: _enableCloseDrag,
      enableDrag: _enableDrag,
      showDragHandle: _showDragHandle,
      useSafeArea: _useSafeArea,
      minDialogWidth: _minDialogWidth,
      maxDialogWidth: _maxDialogWidth,
      minPageHeight: _minPageHeight,
      maxPageHeight: _maxPageHeight,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final modalType = _modalTypeBuilder(context);
    const easeCurve = Curves.ease;
    switch (modalType) {
      case WoltModalType.bottomSheet:
        return _bottomSheetTransitionAnimation ??
            SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: easeCurve)),
              ),
              child: child,
            );
      case WoltModalType.dialog:
        return _dialogTransitionAnimation ??
            ScaleTransition(
              scale: animation.drive(Tween(
                begin: 0.9,
                end: 1.0,
              ).chain(CurveTween(curve: easeCurve))),
              child: child,
            );
    }
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
