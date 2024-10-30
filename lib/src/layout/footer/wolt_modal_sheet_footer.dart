import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:wolt_modal_sheet/src/layout/scroll_view/effective_extent_viewport_dependent.dart';

// ignore: consistent-update-render-object
class WoltModalSheetFooter extends SingleChildRenderObjectWidget {
  final ValueNotifier<double> _sizeDispatcher;

  const WoltModalSheetFooter({
    super.key,
    required Widget super.child,
    required ValueNotifier<double> sizeDispatcher,
  }) : _sizeDispatcher = sizeDispatcher;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return WoltModalSheetFooterRenderSliver(_sizeDispatcher);
  }
}

class WoltModalSheetFooterRenderSliver extends RenderSliverSingleBoxAdapter
    implements EffectiveExtentViewPortDependent {
  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>();
  Matrix4? _paintTransform;
  final ValueNotifier<double> _sizeDispatcher;
  late double correction;

  WoltModalSheetFooterRenderSliver(this._sizeDispatcher);

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    _sizeDispatcher.value = childExtent;

    geometry = SliverGeometry(
      scrollExtent: 0,
      layoutExtent: 0,
      paintExtent: 0,
      paintOrigin: 0,
      visible: true,
      maxPaintExtent: 0,
      hitTestExtent: childExtent,
      hasVisualOverflow: true,
    );
  }

  @override
  void performEffectiveExtent(double extent) {
    _paintTransform = Matrix4.identity();
    final edgeOffset =
        constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
    correction = extent - _sizeDispatcher.value - edgeOffset;

    switch (constraints.axis) {
      case Axis.horizontal:
        _paintTransform!.translate(correction, .0);
        break;
      case Axis.vertical:
        _paintTransform!.translate(.0, correction);
        break;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      _transformLayer.layer = context.pushTransform(
        needsCompositing,
        offset,
        _paintTransform ?? Matrix4.identity(),
        _paintChild,
        oldLayer: _transformLayer.layer,
      );
    } else {
      _transformLayer.layer = null;
    }
  }

  @override
  void dispose() {
    _transformLayer.layer = null;
    super.dispose();
  }

  void _paintChild(PaintingContext context, Offset offset) {
    final childParentData = child!.parentData! as SliverPhysicalParentData;
    context.paintChild(child!, offset + childParentData.paintOffset);
  }

  @override
  bool hitTest(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    final factMainStartPos = correction;
    final factMainEndPos = factMainStartPos + _sizeDispatcher.value;

    if (mainAxisPosition >= factMainStartPos &&
        mainAxisPosition <= factMainEndPos &&
        crossAxisPosition >= 0.0 &&
        crossAxisPosition <= constraints.crossAxisExtent) {
      // make correction for child position
      final adjustedMainAxisPosition =
          mainAxisPosition - factMainStartPos - constraints.scrollOffset;
      var haveHit = hitTestChildren(
        result,
        mainAxisPosition: adjustedMainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      );

      if (!haveHit) {
        // always false and not necessary if we don't want to make class extendable
        haveHit = hitTestSelf(
            mainAxisPosition: mainAxisPosition,
            crossAxisPosition: crossAxisPosition);
      }

      if (haveHit) {
        result.add(
          SliverHitTestEntry(
            this,
            mainAxisPosition: mainAxisPosition,
            crossAxisPosition: crossAxisPosition,
          ),
        );
        return true;
      }
    }
    return false;
  }
}
