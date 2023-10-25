import 'package:flutter/widgets.dart';

enum WoltModalSheetPageTransitionState {
  incoming,
  outgoing;

  const WoltModalSheetPageTransitionState();

  Animation<double> defaultMainContentSizeFactor(Animation<double> animation) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(animation);
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(animation);
    }
  }

  Animation<double> mainContentSizeFactor(
    Animation<double> animation, {
    required double incomingMainContentHeight,
    required double outgoingMainContentHeight,
  }) {
    const interval = Interval(0 / 350, 300 / 350, curve: Curves.fastOutSlowIn);
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(
                begin: outgoingMainContentHeight / incomingMainContentHeight,
                end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: interval));
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(
                begin: 1.0,
                end: incomingMainContentHeight / outgoingMainContentHeight)
            .animate(CurvedAnimation(parent: animation, curve: interval));
    }
  }

  Animation<double> mainContentOpacity(Animation<double> animation) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(150 / 350, 350 / 350, curve: Curves.linear),
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(50 / 350, 150 / 350, curve: Curves.linear),
          ),
        );
    }
  }

  Animation<Offset> mainContentSlidePosition(
    Animation<double> animation, {
    required double sheetWidth,
    required double screenWidth,
    required bool isForwardMove,
  }) {
    const interval = Interval(50 / 350, 350 / 350, curve: Curves.fastOutSlowIn);
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<Offset>(
          begin: Offset(
              sheetWidth * 0.3 * (isForwardMove ? 1 : -1) / screenWidth, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: interval));
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<Offset>(
          begin: Offset.zero,
          end: Offset(
              sheetWidth * 0.3 * (isForwardMove ? -1 : 1) / screenWidth, 0),
        ).animate(CurvedAnimation(parent: animation, curve: interval));
    }
  }

  Animation<double> navigationToolbarOpacity(Animation<double> animation) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(100 / 350, 300 / 350, curve: Curves.linear),
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 100 / 350, curve: Curves.linear),
          ),
        );
    }
  }

  Animation<double> sabOpacity(Animation<double> animation) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(100 / 350, 300 / 350, curve: Curves.linear),
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 100 / 350),
          ),
        );
    }
  }

  Animation<double> topBarOpacity(Animation<double> animation) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(150 / 350, 350 / 350, curve: Curves.linear),
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0, 150 / 350, curve: Curves.linear),
          ),
        );
    }
  }
}
