import 'package:flutter/material.dart';

const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

class SimpleTestRoute<T> extends PageRoute<T> {
  SimpleTestRoute({
    this.modalBarrierColor,
    bool? barrierDismissible,
    Duration? transitionDuration,
    RouteSettings? routeSettings,
  })  : _transitionDuration = transitionDuration ?? const Duration(milliseconds: 300),
        _barrierDismissible = barrierDismissible ?? true,
        super(settings: routeSettings);

  final Duration _transitionDuration;
  final bool _barrierDismissible;

  /// Specifies the color of the modal barrier that darkens everything below the
  /// bottom sheet.
  ///
  /// Defaults to `Colors.black54` if not provided.
  final Color? modalBarrierColor;

  @override
  bool get barrierDismissible => _barrierDismissible;

  /// The value of false was chosen to indicate that the modal route does not fully obscure the
  /// underlying content. This allows for a translucent effect, where the content beneath the
  /// modal is partially visible.
  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  String? get barrierLabel => 'Modal barrier';

  AnimationController? animationController;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: size.height * .5,
        width: size.width * .5,
        child: _ExampleOfContent(
          animationController: animationController,
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: animation.drive(
        Tween(
          begin: 0.9,
          end: 1.0,
        ),
      ),
      child: child,
    );
  }

  @override
  Color? get barrierColor => modalBarrierColor ?? Colors.black54;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  AnimationController createAnimationController() {
    assert(animationController == null);
    animationController = BottomSheet.createAnimationController(navigator!);

    return animationController!;
  }
}

class _ExampleOfContent extends StatefulWidget {
  const _ExampleOfContent({this.animationController});

  final AnimationController? animationController;

  @override
  State<_ExampleOfContent> createState() => _ExampleOfContentState();
}

class _ExampleOfContentState extends State<_ExampleOfContent> {
  final _list = List.generate(10, (index) => index);
  Set<MaterialState> dragHandleMaterialState = <MaterialState>{};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Material(
        key: _childKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: _list
                  .map(
                    (index) => Container(
                      color: index.isEven ? Colors.green : Colors.red,
                      height: 100,
                      width: double.infinity,
                      child: Text('$index'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey _childKey = GlobalKey(debugLabel: 'BottomSheet child');

  bool get _dismissUnderway => widget.animationController!.status == AnimationStatus.reverse;

  double get _childHeight {
    final RenderBox renderBox = _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      dragHandleMaterialState.add(MaterialState.dragged);
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_dismissUnderway) {
      return;
    }
    widget.animationController!.value -= details.primaryDelta! / _childHeight;
  }



  void _handleDragEnd(DragEndDetails details) {
    if (_dismissUnderway) {
      return;
    }
    setState(() {
      dragHandleMaterialState.remove(MaterialState.dragged);
    });
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
    } else {
      widget.animationController!.forward();
    }
  }
}
