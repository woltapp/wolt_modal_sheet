import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WoltPage extends StatefulWidget {
  final Widget? header;
  final Widget? footer;
  final List<Widget> slivers;

  const WoltPage({
    super.key,
    this.header,
    this.footer,
    required this.slivers,
  });

  @override
  State<WoltPage> createState() => _WoltPageState();
}

class _WoltPageState extends State<WoltPage> {
  final _footerSizeDispatcher = ValueNotifier<double>(0);

  @override
  Widget build(BuildContext context) {
    return Material(
      // TODO: theming.
      color: Colors.white,
      child: _WoltPageScrollView(
        slivers: [
          if (widget.header != null)
            _Header(
              child: widget.header!,
            ),
          if (widget.footer != null)
            _Footer(
              sizeDispatcher: _footerSizeDispatcher,
              child: widget.footer!,
            ),
          ...widget.slivers,
          if (widget.footer != null)
            _DummySizeSliver(trackedSizeDispatcher: _footerSizeDispatcher),
        ],
      ),
    );
  }
}

class _WoltPageScrollView extends CustomScrollView {
  const _WoltPageScrollView({
    super.slivers = const <Widget>[],
  });

  @override
  Widget buildViewport(BuildContext context, ViewportOffset offset,
      AxisDirection axisDirection, List<Widget> slivers) {
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
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(
            context,
            axisDirection,
          ),
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
      if (child is _IEfectiveExtentViewPortDependent) {
        (child as _IEfectiveExtentViewPortDependent)
            .performEfectiveExtent(extent);
      }

      child = childAfter(child);
    }
  }
}

class _Header extends SingleChildRenderObjectWidget {
  const _Header({
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HeaderRenderSliver();
  }
}

class _HeaderRenderSliver extends RenderSliverPinnedPersistentHeader {
  late double _childSize;

  _HeaderRenderSliver();

  @override
  double get maxExtent => _childSize;

  @override
  double get minExtent => _childSize;

  @override
  void performLayout() {
    _calculateChild();

    super.performLayout();
  }

  void _calculateChild() {
    final constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    switch (constraints.axis) {
      case Axis.horizontal:
        _childSize = child!.size.width;
        break;
      case Axis.vertical:
        _childSize = child!.size.height;
        break;
    }
  }
}

class _Footer extends SingleChildRenderObjectWidget {
  final ValueNotifier<double> _sizeDispatcher;

  const _Footer({
    required Widget super.child,
    required ValueNotifier<double> sizeDispatcher,
  }) : _sizeDispatcher = sizeDispatcher;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FooterRenderSliver(_sizeDispatcher);
  }
}

abstract interface class _IEfectiveExtentViewPortDependent {
  void performEfectiveExtent(double extent);
}

class _FooterRenderSliver extends RenderSliverSingleBoxAdapter
    implements _IEfectiveExtentViewPortDependent {
  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>();
  Matrix4? _paintTransform;
  final ValueNotifier<double> _sizeDispatcher;
  late double _correction;

  _FooterRenderSliver(this._sizeDispatcher);

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
  void performEfectiveExtent(double extent) {
    _paintTransform = Matrix4.identity();
    final edgeOffset =
        constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
    _correction = extent - _sizeDispatcher.value - edgeOffset;

    switch (constraints.axis) {
      case Axis.horizontal:
        _paintTransform!.translate(_correction, .0);
        break;
      case Axis.vertical:
        _paintTransform!.translate(.0, _correction);
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
    final factMainStartPos = _correction;
    final factMainEndPos = factMainStartPos + _sizeDispatcher.value;

    if (mainAxisPosition >= factMainStartPos &&
        mainAxisPosition <= factMainEndPos &&
        crossAxisPosition >= 0.0 &&
        crossAxisPosition <= constraints.crossAxisExtent) {
      // make correction for child position
      final adjustedmainAxisPosition =
          mainAxisPosition - factMainStartPos - constraints.scrollOffset;
      var haveHit = hitTestChildren(result,
          mainAxisPosition: adjustedmainAxisPosition,
          crossAxisPosition: crossAxisPosition);

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

class _DummySizeSliver extends LeafRenderObjectWidget {
  final ValueListenable<double> trackedSizeDispatcher;

  const _DummySizeSliver({required this.trackedSizeDispatcher});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _DummySizeRenderSliver(trackedSizeDispatcher);
  }
}

class _DummySizeRenderSliver extends RenderSliver {
  final ValueListenable<double> trackedSizeDispatcher;

  _DummySizeRenderSliver(this.trackedSizeDispatcher) {
    // Is not suppose to be changed
    trackedSizeDispatcher.addListener(_onTrackedSizeChanged);
  }

  @override
  void performLayout() {
    final trackedSize = trackedSizeDispatcher.value;

    final effectiveExtent = math.min(
      trackedSize,
      constraints.remainingPaintExtent,
    );

    geometry = SliverGeometry(
      scrollExtent: trackedSize,
      layoutExtent: effectiveExtent,
      paintExtent: effectiveExtent,
      maxPaintExtent: trackedSize,
      cacheExtent: 0,
      hitTestExtent: effectiveExtent,
      hasVisualOverflow: true,
    );
  }

  @override
  void dispose() {
    trackedSizeDispatcher.removeListener(_onTrackedSizeChanged);

    super.dispose();
  }

  void _onTrackedSizeChanged() {
    scheduleMicrotask(() {
      markNeedsLayout();
    });
  }
}
