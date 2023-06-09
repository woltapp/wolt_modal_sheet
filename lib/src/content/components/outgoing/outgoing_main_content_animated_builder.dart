import 'package:flutter/material.dart';

class OutgoingMainContentAnimatedBuilder extends StatefulWidget {
  final AnimationController controller;
  final Animation<double> _opacity;
  final GlobalKey outgoingOffstagedMainContentKey;
  final GlobalKey currentOffstagedMainContentKey;
  final Widget mainContent;
  final bool forwardMove;

  OutgoingMainContentAnimatedBuilder({
    required this.controller,
    required this.mainContent,
    required this.outgoingOffstagedMainContentKey,
    required this.currentOffstagedMainContentKey,
    required this.forwardMove,
    super.key,
  })  : _opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              50 / 350,
              150 / 350,
            ),
          ),
        );

  @override
  State<OutgoingMainContentAnimatedBuilder> createState() =>
      _OutgoingMainContentAnimatedBuilderState();
}

class _OutgoingMainContentAnimatedBuilderState extends State<OutgoingMainContentAnimatedBuilder> {
  Animation<double>? _sizeFactor;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (_sizeFactor == null) {
        final currentHeight = widget.currentOffstagedMainContentKey.currentContext!.size!.height;
        final outgoingHeight = widget.outgoingOffstagedMainContentKey.currentContext!.size!.height;
        _sizeFactor = Tween<double>(begin: 1.0, end: currentHeight / outgoingHeight).animate(
          CurvedAnimation(
            parent: widget.controller,
            curve: const Interval(0 / 350, 300 / 350, curve: Curves.fastOutSlowIn),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget? _) {
        return SizeTransition(
          axisAlignment: -1,
          sizeFactor: _sizeFactor ?? Tween<double>(begin: 1.0, end: 0.0).animate(widget.controller),
          child: Opacity(
            opacity: widget._opacity.value,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: Offset(80 * (widget.forwardMove ? -1 : 1) / screenWidth, 0),
              ).animate(
                CurvedAnimation(
                  parent: widget.controller,
                  curve: const Interval(50 / 350, 350 / 350, curve: Curves.fastOutSlowIn),
                ),
              ),
              child: widget.mainContent,
            ),
          ),
        );
      },
    );
  }
}
