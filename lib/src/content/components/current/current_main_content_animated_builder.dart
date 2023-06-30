import 'package:flutter/material.dart';

class CurrentMainContentAnimatedBuilder extends StatefulWidget {
  final AnimationController controller;
  final Animation<double> _opacity;
  final GlobalKey outgoingOffstagedMainContentKey;
  final GlobalKey currentOffstagedMainContentKey;
  final Widget mainContent;
  final bool forwardMove;
  final double sheetWidth;

  CurrentMainContentAnimatedBuilder({
    required this.controller,
    required this.mainContent,
    required this.outgoingOffstagedMainContentKey,
    required this.currentOffstagedMainContentKey,
    required this.forwardMove,
    required this.sheetWidth,
    super.key,
  })  : _opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              150 / 350,
              350 / 350,
            ),
          ),
        );

  @override
  State<CurrentMainContentAnimatedBuilder> createState() =>
      _CurrentMainContentAnimatedBuilderState();
}

class _CurrentMainContentAnimatedBuilderState extends State<CurrentMainContentAnimatedBuilder> {
  Animation<double>? _sizeFactor;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (_sizeFactor == null) {
        final currentHeight = widget.currentOffstagedMainContentKey.currentContext!.size!.height;
        final outgoingHeight = widget.outgoingOffstagedMainContentKey.currentContext!.size!.height;
        _sizeFactor = Tween<double>(begin: outgoingHeight / currentHeight, end: 1.0).animate(
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
          sizeFactor: _sizeFactor ?? Tween<double>(begin: 0.0, end: 1.0).animate(widget.controller),
          child: Opacity(
            opacity: widget._opacity.value,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(widget.sheetWidth * 0.3 * (widget.forwardMove ? 1 : -1) / screenWidth,
                  0),
                end: Offset.zero,
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
