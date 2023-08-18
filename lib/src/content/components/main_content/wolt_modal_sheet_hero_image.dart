import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/utils/wolt_layout_transformation_utils.dart';

/// The hero image widget displayed on top of the main content.
///
/// A hero image is a prominent and visually appealing image that is typically placed at the top
/// of a page or section to grab the viewer's attention and convey the main theme or message of
/// the content. It is often used in websites, applications, or marketing materials to create an
/// impactful and visually engaging experience.
class WoltModalSheetHeroImage extends StatelessWidget {
  /// Creates a [WoltModalSheetHeroImage].
  ///
  /// [heroImage] represents the widget for the hero image.
  ///
  /// [topBarHeight] represents the height of the top bar.
  ///
  /// [heroImageHeight] represents the height of the hero image.
  const WoltModalSheetHeroImage({
    required this.heroImage,
    required this.topBarHeight,
    required this.heroImageHeight,
    Key? key,
  }) : super(key: key);

  /// The widget for the hero image.
  final Widget heroImage;

  /// The height of the top bar.
  final double topBarHeight;

  /// The height of the hero image.
  final double heroImageHeight;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _HeroImageFlowDelegate(
        scrollPosition: Scrollable.of(context).position,
        topBarHeight: topBarHeight,
        heroImageHeight: heroImageHeight,
      ),
      children: [heroImage],
    );
  }
}

/// The flow delegate for handling the transformation and opacity of the hero image.
class _HeroImageFlowDelegate extends FlowDelegate {
  /// Creates a [_HeroImageFlowDelegate].
  ///
  /// [scrollPosition] represents the scroll position of the modal sheet.
  ///
  /// [topBarHeight] represents the height of the top bar.
  ///
  /// [heroImageHeight] represents the height of the hero image.
  _HeroImageFlowDelegate({
    required this.scrollPosition,
    required this.topBarHeight,
    required this.heroImageHeight,
  }) : super(repaint: scrollPosition);

  /// The scroll position of the modal sheet.
  final ScrollPosition scrollPosition;

  /// The height of the top bar.
  final double topBarHeight;

  /// The height of the hero image.
  final double heroImageHeight;

  @override
  Size getSize(BoxConstraints constraints) {
    return super.getSize(constraints.copyWith(maxHeight: heroImageHeight));
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return super.getConstraintsForChild(
      i, // index of the child. In this case, the only child: hero image
      BoxConstraints.tight(Size(constraints.maxWidth, heroImageHeight)),
    );
  }

  @override
  void paintChildren(FlowPaintingContext flowPaintingContext) {
    final currentScrollPosition = scrollPosition.pixels;

    // Calculate scale
    final double scale = WoltLayoutTransformationUtils.calculateTransformationValue(
      startValue: 1.1,
      endValue: 1.0,
      rangeInPx: heroImageHeight - topBarHeight - 8,
      progressInRangeInPx: currentScrollPosition,
    );

    // Calculate opacity
    final double opacity = WoltLayoutTransformationUtils.calculateTransformationValue(
      rangeInPx: (((heroImageHeight - topBarHeight) / 2) - 8),
      progressInRangeInPx: currentScrollPosition - ((heroImageHeight - topBarHeight) / 2),
      startValue: 1.0,
      endValue: 0.0,
    );

    // Calculate the translation to center the image
    final double translationX = (flowPaintingContext.size.width -
            (flowPaintingContext.getChildSize(0)?.width ?? 0) * scale) /
        2;
    final double translationY = (flowPaintingContext.size.height -
            (flowPaintingContext.getChildSize(0)?.height ?? 0) * scale) /
        2;
    // Create the transformation matrix
    final Matrix4 transformMatrix = Matrix4.identity()
      ..scale(scale, scale)
      ..translate(translationX, translationY);
    flowPaintingContext.paintChild(
      0,
      transform: transformMatrix,
      opacity: opacity,
    );
  }

  @override
  bool shouldRepaint(covariant _HeroImageFlowDelegate oldDelegate) {
    return heroImageHeight != oldDelegate.heroImageHeight ||
        scrollPosition != oldDelegate.scrollPosition ||
        topBarHeight != oldDelegate.topBarHeight;
  }
}
