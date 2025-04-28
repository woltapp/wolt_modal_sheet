import 'package:flutter/widgets.dart';

/// A slide transition that uses pixel-based translation (Transform.translate)
/// instead of FractionalTranslation, avoiding debugNeedsLayout asserts.
class PixelSlideTransition extends StatelessWidget {
  /// An offset animation where values represent fractional (0.0 to 1.0) positions.
  final Animation<Offset> position;

  /// The widget child to be transformed.
  final Widget child;

  const PixelSlideTransition({
    required this.position,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: position,
          builder: (context, child) {
            final offset = position.value;
            // Convert fractional offsets to pixel values
            final dx = offset.dx * constraints.maxWidth;
            final dy = offset.dy * constraints.maxHeight;
            return Transform.translate(
              offset: Offset(dx, dy),
              transformHitTests: false,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}
