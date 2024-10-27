import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// ignore: consistent-update-render-object
class DummySizeSliver extends LeafRenderObjectWidget {
  final ValueListenable<double> trackedSizeDispatcher;

  const DummySizeSliver({super.key, required this.trackedSizeDispatcher});

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
