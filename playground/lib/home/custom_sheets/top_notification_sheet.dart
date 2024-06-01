import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class TopNotificationModalSheet extends WoltModalType {
  const TopNotificationModalSheet()
      : super(
          shapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          isDragEnabled: false,
          shouldForceContentToMaxHeight: false,
        );

  @override
  String routeLabel(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return localizations.dialogLabel;
  }

  @override
  BoxConstraints modalContentBoxConstraints(Size availableSize) {
    return BoxConstraints(
      minWidth: availableSize.width - 64,
      maxWidth: availableSize.width - 64,
      minHeight: 0,
      maxHeight: availableSize.height * 0.6,
    );
  }

  @override
  Offset modalContentOffset(Size availableSize, Size modalContentSize) {
    return const Offset(32, 48);
  }

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // Combined slide and fade transition.
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween(
            begin: const Offset(0.0, -0.1),  // Modified to start slightly above the screen
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutQuad)),  // Smoother curve for easing out
        ),
        child: child,
      ),
    );
  }
}
