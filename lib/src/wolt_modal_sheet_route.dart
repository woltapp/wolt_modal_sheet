import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/theme/wolt_modal_sheet_default_theme_data.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_modal_type_utils.dart';

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
  })  : _enableDrag = enableDrag,
        _showDragHandle = showDragHandle,
        _useSafeArea = useSafeArea ?? true,
        _transitionAnimationController = transitionAnimationController,
        _barrierDismissible = barrierDismissible ?? true,
        _modalTypeBuilder = modalTypeBuilder,
        super(settings: routeSettings);

  Widget Function(Widget)? decorator;

  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;

  final ValueNotifier<int>? pageIndexNotifier;

  final WoltModalTypeBuilder? _modalTypeBuilder;

  late final bool _barrierDismissible;

  final VoidCallback? onModalDismissedWithBarrierTap;

  final VoidCallback? onModalDismissedWithDrag;

  final bool? _enableDrag;

  final bool? _showDragHandle;

  final bool _useSafeArea;

  /// Specifies the color of the modal barrier that darkens everything below the
  /// bottom sheet.
  final Color? modalBarrierColor;

  /// The animation controller that controls the modal sheet's entrance and
  /// exit animations.
  ///
  /// The [WoltModalSheet] widget will manipulate the position of this animation, it
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
      modalTypeBuilder: _determineCurrentModalType,
      onModalDismissedWithBarrierTap: onModalDismissedWithBarrierTap,
      onModalDismissedWithDrag: onModalDismissedWithDrag,
      transitionAnimationController: animationController,
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
    final modalType = _determineCurrentModalType(context);
    return modalType.buildTransitions(
        context, animation, secondaryAnimation, child);
  }

  @override
  Color? get barrierColor {
    final context = navigator!.context;
    final themeData = Theme.of(context).extension<WoltModalSheetThemeData>();
    final defaultThemeData = WoltModalSheetDefaultThemeData(context);
    return modalBarrierColor ??
        themeData?.modalBarrierColor ??
        defaultThemeData.modalBarrierColor;
  }

  @override
  Duration get transitionDuration {
    return _determineCurrentModalType(navigator!.context).transitionDuration;
  }

  @override
  Duration get reverseTransitionDuration {
    return _determineCurrentModalType(navigator!.context)
        .reverseTransitionDuration;
  }

  @override
  AnimationController createAnimationController() {
    assert(animationController == null);
    if (_transitionAnimationController != null) {
      animationController = _transitionAnimationController;
      willDisposeAnimationController = false;
    } else {
      animationController = AnimationController(
        duration: transitionDuration,
        reverseDuration: reverseTransitionDuration,
        debugLabel: 'WoltModalSheet',
        vsync: navigator!,
      );
    }
    return animationController!;
  }

  WoltModalType _determineCurrentModalType(BuildContext context) {
    return WoltModalTypeUtils.currentModalType(_modalTypeBuilder, context);
  }
}
