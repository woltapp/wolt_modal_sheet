import 'package:flutter/widgets.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

enum WoltModalSheetPageTransitionState {
  incoming,
  outgoing;

  const WoltModalSheetPageTransitionState();

  Animation<double> defaultMainContentSizeFactor(
    AnimationController controller,
  ) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(controller);
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(controller);
    }
  }

  Animation<double> mainContentHeightTransition(
    AnimationController controller,
    WoltModalSheetPaginationAnimationStyle style, {
    required double incomingMainContentHeight,
    required double outgoingMainContentHeight,
  }) {
    final interval = style.modalSheetHeightTransitionCurve;
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(
          begin: outgoingMainContentHeight / incomingMainContentHeight,
          end: 1.0,
        ).animate(CurvedAnimation(parent: controller, curve: interval));
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(
          begin: 1.0,
          end: incomingMainContentHeight / outgoingMainContentHeight,
        ).animate(CurvedAnimation(parent: controller, curve: interval));
    }
  }

  Animation<double> mainContentOpacity(
    AnimationController controller,
    WoltModalSheetPaginationAnimationStyle style,
  ) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.mainContentIncomingOpacityCurve,
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.mainContentOutgoingOpacityCurve,
          ),
        );
    }
  }

  /// Returns an animation for the main content slide position based on the
  /// provided parameters, supporting both LTR and RTL directions.
  Animation<Offset> mainContentSlidePosition(
    AnimationController controller,
    WoltModalSheetPaginationAnimationStyle style, {
    required double sheetWidth,
    required double screenWidth,
    required bool isForwardMove,
    required TextDirection textDirection,
  }) {
    final directionMultiplier = (textDirection == TextDirection.ltr ? 1 : -1) *
        (isForwardMove ? 1 : -1);

    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        final incomingBeginOffset =
            Offset(sheetWidth * 0.3 * directionMultiplier / screenWidth, 0);

        return Tween<Offset>(
          begin:
              style.incomingMainContentSlideBeginOffset ?? incomingBeginOffset,
          end: style.incomingMainContentSlideEndOffset,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.mainContentIncomingSlidePositionCurve,
          ),
        );

      case WoltModalSheetPageTransitionState.outgoing:
        final outgoingEndOffset =
            Offset(sheetWidth * 0.3 * -directionMultiplier / screenWidth, 0);

        return Tween<Offset>(
          begin: style.outgoingMainContentSlideBeginOffset,
          end: style.outgoingMainContentSlideEndOffset ?? outgoingEndOffset,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.mainContentOutgoingSlidePositionCurve,
          ),
        );
    }
  }

  Animation<double> navigationToolbarOpacity(
    AnimationController controller,
    WoltModalSheetPaginationAnimationStyle style,
  ) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.incomingNavigationToolbarOpacityCurve,
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.incomingNavigationToolbarOpacityCurve,
          ),
        );
    }
  }

  Animation<double> sabOpacity(
    AnimationController controller,
    WoltModalSheetPaginationAnimationStyle style,
  ) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.incomingSabOpacityCurve,
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.outgoingSabOpacityCurve,
          ),
        );
    }
  }

  Animation<double> topBarOpacity(
    AnimationController controller,
    WoltModalSheetPaginationAnimationStyle style,
  ) {
    switch (this) {
      case WoltModalSheetPageTransitionState.incoming:
        return Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.incomingTopBarOpacityCurve,
          ),
        );
      case WoltModalSheetPageTransitionState.outgoing:
        return Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: style.outgoingTopBarOpacityCurve,
          ),
        );
    }
  }
}
