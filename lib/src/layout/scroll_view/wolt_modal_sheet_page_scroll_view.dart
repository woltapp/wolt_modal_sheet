import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wolt_modal_sheet/src/layout/scroll_view/effective_extent_viewport_dependent.dart';

class WoltModalSheetPageScrollView extends CustomScrollView {
  const WoltModalSheetPageScrollView({
    super.key,
    super.slivers = const <Widget>[],
  });

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    assert(() {
      switch (axisDirection) {
        case AxisDirection.up:
        case AxisDirection.down:
          return debugCheckHasDirectionality(
            context,
            why: 'to determine the cross-axis direction of the scroll view',
            hint:
                'Vertical scroll views create Viewport widgets that try to determine their cross axis direction '
                'from the ambient Directionality.',
          );
        case AxisDirection.left:
        case AxisDirection.right:
          return true;
      }
    }());
    return _WoltPageViewPort(
      axisDirection: axisDirection,
      offset: offset,
      slivers: slivers,
      clipBehavior: clipBehavior,
    );
  }
}

// ignore: consistent-update-render-object
class _WoltPageViewPort extends ShrinkWrappingViewport {
  const _WoltPageViewPort({
    super.axisDirection,
    required super.offset,
    super.slivers,
    super.clipBehavior,
  });

  @override
  RenderShrinkWrappingViewport createRenderObject(BuildContext context) {
    return _RenderWoltPageViewPort(
      axisDirection: axisDirection,
      crossAxisDirection:
          crossAxisDirection ?? Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      offset: offset,
      clipBehavior: clipBehavior,
    );
  }
}

class _RenderWoltPageViewPort extends RenderShrinkWrappingViewport {
  _RenderWoltPageViewPort({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    super.clipBehavior,
  });

  @override
  void performLayout() {
    super.performLayout();

    _propagateEffectiveExtent();
  }

  void _propagateEffectiveExtent() {
    final extent = axis == Axis.vertical ? size.height : size.width;
    var child = firstChild;

    while (child != null) {
      // ignore: avoid-unrelated-type-assertions
      if (child is EffectiveExtentViewPortDependent) {
        // ignore: avoid-unrelated-type-casts
        (child as EffectiveExtentViewPortDependent).performEffectiveExtent(extent);
      }

      child = childAfter(child);
    }
  }
}
