import 'package:flutter/material.dart';

// TODO: Написать доку либо спросить у Миши как сделать доступ к закрытому классу.
abstract class WoltModalPageRoute<T> extends PageRoute<T> {
  WoltModalPageRoute({
    required WoltModalInternalPage<T> page,
  }) : super(settings: page) {
    assert(opaque);
  }

  GlobalKey get contentKey;
}

/// Page with Wolt animation for internal pages.
class WoltModalInternalPage<T> extends Page<T> {
  final Widget child;

  /// {flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  const WoltModalInternalPage({
    super.key,
    super.name,
    super.arguments,
    this.maintainState = true,
    required this.child,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return _WoltModalInternalPageRoute(page: this);
  }
}

class _WoltModalInternalPageRoute<T> extends WoltModalPageRoute<T>
    with _WoltModalRouteTransitionMixin<T> {
  _WoltModalInternalPageRoute({
    required WoltModalInternalPage<T> page,
  }) : super(page: page);

  final _contentKey = GlobalKey();

  @override
  GlobalKey get contentKey => _contentKey;

  WoltModalInternalPage<T> get _page => settings as WoltModalInternalPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        key: contentKey,
        child: _page.child,
      ),
    );
  }

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  bool get maintainState => _page.maintainState;
}

mixin _WoltModalRouteTransitionMixin<T> on PageRoute<T> {
  // Builds the primary contents of the route.
  @protected
  Widget buildContent(BuildContext context);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = buildContent(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(context, animation, secondaryAnimation, child) {
    final incomingAnimation = _InAnimation(parent: animation);
    final outAnimation = _OutAnimation(parent: secondaryAnimation);

    return SlideTransition(
      position: outAnimation.translationAnimation,
      child: FadeTransition(
        opacity: outAnimation.alphaAnimation,
        child: SlideTransition(
          position: incomingAnimation.translationAnimation,
          child: FadeTransition(
            opacity: incomingAnimation.alphaAnimation,
            child: child,
          ),
        ),
      ),
    );
  }
}

abstract class _PageTransitionAnimation {
  static const animationDuration = Duration(milliseconds: 300);
  final _animationDuration = _PageTransitionAnimation.animationDuration;
}

class _InAnimation extends _PageTransitionAnimation {
  final _alphaDuration = const Duration(milliseconds: 200);

  late final Animation<Offset> _translationAnimation;
  late final Animation<double> _alphaAnimation;

  Animation<Offset> get translationAnimation => _translationAnimation;

  Animation<double> get alphaAnimation => _alphaAnimation;

  _InAnimation({required Animation<double> parent}) {
    _translationAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(parent);

    _alphaAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0),
          weight:
              (_animationDuration - _alphaDuration).inMilliseconds.toDouble(),
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: _alphaDuration.inMilliseconds.toDouble(),
        ),
      ],
    ).animate(parent);
  }
}

class _OutAnimation extends _PageTransitionAnimation {
  final _alphaDuration = const Duration(milliseconds: 100);

  late final Animation<Offset> _translationAnimation;
  late final Animation<double> _alphaAnimation;

  Animation<Offset> get translationAnimation => _translationAnimation;

  Animation<double> get alphaAnimation => _alphaAnimation;

  _OutAnimation({required Animation<double> parent}) {
    _translationAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(parent);

    _alphaAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0),
          weight: _alphaDuration.inMilliseconds.toDouble(),
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0),
          weight:
              (_animationDuration - _alphaDuration).inMilliseconds.toDouble(),
        ),
      ],
    ).animate(parent);
  }
}
