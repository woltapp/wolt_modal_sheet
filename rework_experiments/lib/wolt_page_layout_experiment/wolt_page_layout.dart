import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WoltPageLayout extends StatefulWidget {
  final Widget? header;
  final Widget? footer;
  final List<Widget> slivers;

  const WoltPageLayout({
    super.key,
    this.header,
    this.footer,
    required this.slivers,
  });

  @override
  State<WoltPageLayout> createState() => _WoltPageLayoutState();
}

class _WoltPageLayoutState extends State<WoltPageLayout>
    with TickerProviderStateMixin {
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
              child: Hero(
                  tag: 'Header',
                  flightShuttleBuilder: (
                    BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext,
                  ) {
                    final anim =
                        _HeaderAnimation(parent: animation, vsync: this);

                    return FadeTransition(
                      opacity: anim.appear,
                      child: toHeroContext.widget,
                    );
                  },
                  child: widget.header!),
            ),
          if (widget.footer != null)
            _Footer(
              sizeDispatcher: _footerSizeDispatcher,
              child: Hero(
                tag: 'Footer',
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      final fromBox =
                          fromHeroContext.findRenderObject() as RenderBox?;
                      final toBox =
                          toHeroContext.findRenderObject() as RenderBox?;
                      if (fromBox == null || toBox == null) {
                        return child!;
                      }
                      final correctionFrom =
                          (fromBox.parent as _FooterRenderSliver)._correction;
                      final correctionTo =
                          (toBox.parent as _FooterRenderSliver)._correction;
                      final av = animation.isForwardOrCompleted
                          ? animation.value
                          : 1 - animation.value;
                      final offset = Offset(
                          0,
                          correctionFrom +
                              (correctionTo - correctionFrom) * av);

                      return Transform.translate(
                        offset: offset,
                        child: child,
                      );
                    },
                    child: fromHeroContext.widget,
                  );
                },
                child: widget.footer!,
              ),
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
      if (child is _IEffectiveExtentViewPortDependent) {
        (child as _IEffectiveExtentViewPortDependent)
            .performEffectiveExtent(extent);
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

abstract interface class _IEffectiveExtentViewPortDependent {
  void performEffectiveExtent(double extent);
}

class _FooterRenderSliver extends RenderSliverSingleBoxAdapter
    implements _IEffectiveExtentViewPortDependent {
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
  void performEffectiveExtent(double extent) {
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
      final adjustedMainAxisPosition =
          mainAxisPosition - factMainStartPos - constraints.scrollOffset;
      var haveHit = hitTestChildren(result,
          mainAxisPosition: adjustedMainAxisPosition,
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

class _HeaderAnimation extends AnimationController {
  final _disappearDuration = const Duration(milliseconds: 100);
  final _appearDuration = const Duration(milliseconds: 200);

  late final Animation<double> _appearAnimation;

  Animation<double> get appear => _appearAnimation;

  _HeaderAnimation({required Animation<double> parent, required super.vsync}) {
    _appearAnimation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: _disappearDuration.inMilliseconds.toDouble(),
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: Curves.linear)),
          weight: _appearDuration.inMilliseconds.toDouble(),
        ),
      ],
    ).animate(parent);
  }
}
