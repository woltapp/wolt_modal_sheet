import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ModalSheetHeader extends SingleChildRenderObjectWidget {
  const ModalSheetHeader({super.key, required Widget super.child});

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
