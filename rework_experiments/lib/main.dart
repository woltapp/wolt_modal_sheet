import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// TODO: Footer tracker update
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _TestScreen(),
    );
  }
}

class _TestScreen extends StatefulWidget {
  const _TestScreen();

  @override
  State<_TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<_TestScreen> {
  final GlobalKey _footerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: .5,
          // heightFactor: .5,
          child: Material(
            color: Colors.white,
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                const _Header(
                  child: _CollapsedContent('header', Colors.blue),
                ),
                _Footer(
                  key: _footerKey,
                  child: const _CollapsedContent('footer', Colors.green),
                ),
                const SliverAppBar.medium(
                  backgroundColor: Colors.amber,
                ),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    debugPrint('1st seq $index');
                    return _Slice(index);
                  },
                  itemCount: 100,
                ),
                _DummySizeSliver(trackedObjectKey: _footerKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedContent extends StatefulWidget {
  final String title;
  final Color color;

  const _CollapsedContent(this.title, this.color);

  @override
  State<_CollapsedContent> createState() => _CollapsedContentState();
}

class _CollapsedContentState extends State<_CollapsedContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: widget.color,
      height: _isExpanded ? 300 : 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(widget.title)),
          Checkbox(
            value: _isExpanded,
            onChanged: (value) => setState(() => _isExpanded = value!),
          ),
        ],
      ),
    );
  }
}

class _Slice extends StatelessWidget {
  final int index;

  const _Slice(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.all(8),
      height: 300,
      child: Text('Item $index'),
    );
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
  const _Footer({
    required GlobalKey key,
    required Widget super.child,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FooterRenderSliver();
  }
}

abstract interface class ITrackableExtent {
  double get extent;
}

class _FooterRenderSliver extends RenderSliverSingleBoxAdapter
    implements ITrackableExtent {
  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>();
  Matrix4? _paintTransform;
  double _extent = 0;

  @override
  double get extent => _extent;

  _FooterRenderSliver();

  @override
  void performLayout() {
    _paintTransform = Matrix4.identity();
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        _paintTransform!.translate(
          constraints.remainingPaintExtent - childExtent,
          .0,
        );
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        _paintTransform!.translate(
          .0,
          constraints.remainingPaintExtent - childExtent,
        );
        break;
    }
    _extent = childExtent;

    geometry = SliverGeometry(
      scrollExtent: 0,
      layoutExtent: 0,
      paintExtent: 0,
      paintOrigin: 0,
      visible: true,
      maxPaintExtent: childExtent,
      hitTestExtent: childExtent,
      hasVisualOverflow: true,
    );
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
    final factMainEndPos = constraints.remainingPaintExtent;
    final factMainStartPos = factMainEndPos - _extent;
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
  final GlobalKey trackedObjectKey;

  const _DummySizeSliver({required this.trackedObjectKey});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _DummySizeRenderSliver(trackedObjectKey);
  }
}

class _DummySizeRenderSliver extends RenderSliver {
  final GlobalKey trackedObjectKey;

  _DummySizeRenderSliver(this.trackedObjectKey);

  @override
  void performLayout() {
    final renderObject = trackedObjectKey.currentContext?.findRenderObject();
    var trackedSize = .0;
    if (renderObject != null && renderObject is ITrackableExtent) {
      trackedSize = (renderObject as ITrackableExtent).extent;
    }

    final effectiveExtent =
        math.min(trackedSize, constraints.remainingPaintExtent);

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
}
