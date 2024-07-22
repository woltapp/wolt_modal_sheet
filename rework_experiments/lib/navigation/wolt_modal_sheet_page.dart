import 'package:flutter/material.dart';

/// Page with Wolt animation.
class WoltModalSheetPage<T> extends Page<T> {
  final Widget child;

  const WoltModalSheetPage({
    super.key,
    super.name,
    super.arguments,
    required this.child,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      transitionDuration: _PageTransitionAnimation.animationDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

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
      },
      settings: this,
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
          weight: (_animationDuration - _alphaDuration).inMilliseconds.toDouble(),
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin:0, end: 1),
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
      end: const Offset(-1 , 0),
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(parent);

    _alphaAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0),
          weight: _alphaDuration.inMilliseconds.toDouble(),
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0),
          weight: (_animationDuration - _alphaDuration).inMilliseconds.toDouble(),
        ),
      ],
    ).animate(parent);
  }
}
