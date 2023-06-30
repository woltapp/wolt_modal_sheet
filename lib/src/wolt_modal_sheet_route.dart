import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalSheetRoute<T> extends PageRoute<T> {
  WoltModalSheetRoute({
    required this.pageListBuilderNotifier,
    required this.modalTypeBuilder,
    required this.enableDragForBottomSheet,
    required this.useSafeArea,
    required bool barrierDismissible,
    this.pageIndexNotifier,
    this.decorator,
    this.onModalDismissedWithBarrierTap,
    AnimationController? transitionAnimationController,
    VoidCallback? onDismissed,
    RouteSettings? routeSettings,
    Duration? transitionDuration,
  })  : _transitionAnimationController = transitionAnimationController,
        _transitionDuration = transitionDuration ?? const Duration(milliseconds: 300),
        _barrierDismissible = barrierDismissible,
        super(settings: routeSettings);

  Widget Function(Widget)? decorator;

  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  final ValueNotifier<int>? pageIndexNotifier;

  final WoltModalTypeBuilder modalTypeBuilder;

  late final Duration _transitionDuration;

  late final bool _barrierDismissible;

  final VoidCallback? onModalDismissedWithBarrierTap;

  final bool enableDragForBottomSheet;

  final bool useSafeArea;

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
      modalTypeBuilder: modalTypeBuilder,
      onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
      animationController: animationController,
      enableDragForBottomSheet: enableDragForBottomSheet,
      useSafeArea: useSafeArea,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final modalType = modalTypeBuilder(context);
    const easeCurve = Curves.ease;
    switch (modalType) {
      case WoltModalType.bottomSheet:
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: easeCurve)),
          ),
          child: child,
        );
      case WoltModalType.dialog:
        return ScaleTransition(
          scale: animation.drive(Tween(begin: 0.9, end: 1.0).chain(CurveTween(curve: easeCurve))),
          child: child,
        );
    }
  }

  @override
  Color? get barrierColor => Colors.black54;

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
