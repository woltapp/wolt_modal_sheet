import 'package:flutter/material.dart';
import 'package:rework_experiments/navigation_experiment/lib/theme/wolt_modal_sheet_theme_data.dart';
import 'package:rework_experiments/navigation_experiment/lib/type/wolt_modal_sheet_type_delegate.dart';

/// An entity responsible for creating all necessary wrappers to form a content
/// of modal sheet in appropriate form, for examle bottom sheet,
/// alert dialog, etc.
/// 
/// The [WoltModalSheetDelegate] is responsible for desision which
/// form it should be.
/// 
/// See also: [WoltModalSheetDelegate], [BottomSheet], [AlertDialog].
class WoltModalTypeAdapter extends StatefulWidget {
  final Widget child;
  final WoltModalSheetDelegate _woltModalSheetDelegate;
  final AnimationController? _routeAnimationController;

  const WoltModalTypeAdapter({
    required this.child,
    WoltModalSheetDelegate? woltModalSheetDelegate,
    AnimationController? bottomSheetController,
    super.key,
  })  : _woltModalSheetDelegate =
            woltModalSheetDelegate ?? const DefaultWoltModalSheetDelegate(),
        _routeAnimationController = bottomSheetController;

  @override
  State<WoltModalTypeAdapter> createState() => _WoltModalTypeAdapterState();
}

class _WoltModalTypeAdapterState extends State<WoltModalTypeAdapter>
    with SingleTickerProviderStateMixin {
  // Theoretically can be improved for support updating widgets with changing
  // passed controller, but for beginning we keep it simple.
  late final AnimationController _routeAnimationController;

  @override
  void initState() {
    super.initState();

    _routeAnimationController = widget._routeAnimationController ??
        (AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..forward());
  }

  @override
  void dispose() {
    if (widget._routeAnimationController == null) {
      _routeAnimationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.sizeOf(context).width;
    final woltModalType =
        widget._woltModalSheetDelegate.getWoltModalSheetType(deviceWidth);
    final style = Theme.of(context).extension<WoltModalSheetTheme>()!.style;
    BoxConstraints constraints;
    Widget child;

    switch (woltModalType) {
      case WoltModalType.bottomSheet:
        final bottomSheetStyle = style.bottomSheetStyle;
        constraints = BoxConstraints(
          maxHeight: bottomSheetStyle.maxHeight,
          minHeight: bottomSheetStyle.minHeight,
          minWidth: double.infinity,
          maxWidth: double.infinity,
        );
        child = _BottomSheet(
          routeAnimationController: _routeAnimationController,
          style: bottomSheetStyle,
          child: widget.child,
        );
      case WoltModalType.dialog:
        final dialogStyle = style.dialogStyle;
        constraints = BoxConstraints(
          maxHeight: dialogStyle.maxHeight,
          minHeight: dialogStyle.minHeight,
          maxWidth: dialogStyle.width,
          minWidth: dialogStyle.width,
        );
        child = _Dialog(style: dialogStyle, child: widget.child);
    }

    return ConstraintsProvider(constraints: constraints, child: child);
  }
}

class _Dialog extends StatelessWidget {
  final Widget child;
  final WoltModalDialogStyle style;

  const _Dialog({
    required this.child,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: style.backgroundColor,
      elevation: style.elevation,
      surfaceTintColor: style.surfaceTintColor,
      shape: style.shape,
      alignment: style.alignment,
      insetPadding: style.insetPadding,
      clipBehavior: style.clipBehavior,
      child: child,
    );
  }
}

class _BottomSheet extends StatefulWidget {
  final Widget child;
  final AnimationController routeAnimationController;
  final WoltModalBottomSheetStyle style;

  const _BottomSheet({
    required this.child,
    required this.routeAnimationController,
    required this.style,
  });

  @override
  State<_BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<_BottomSheet> {
  late final Animation<Offset> _incomingAnimation;

  @override
  void initState() {
    super.initState();

    _incomingAnimation =
        Tween(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
            .chain(CurveTween(curve: Curves.fastOutSlowIn))
            .animate(widget.routeAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheetThemeData = widget.style;

    return SlideTransition(
      position: _incomingAnimation,
      child: BottomSheet(
          backgroundColor: bottomSheetThemeData.backgroundColor,
          shadowColor: bottomSheetThemeData.shadowColor,
          elevation: bottomSheetThemeData.elevation,
          shape: bottomSheetThemeData.shape,
          clipBehavior: bottomSheetThemeData.clipBehavior,
          animationController: widget.routeAnimationController,
          showDragHandle: bottomSheetThemeData.enableDrag,
          dragHandleColor: bottomSheetThemeData.dragHandleColor,
          dragHandleSize: bottomSheetThemeData.dragHandleSize,
          enableDrag: bottomSheetThemeData.enableDrag,
          onClosing: () {
            Navigator.pop(context);
          },
          builder: (context) => Padding(
                padding: EdgeInsets.only(
                    bottom: bottomSheetThemeData.resizeToAvoidBottomInset
                        ? MediaQuery.of(context).viewInsets.bottom
                        : 0.0),
                child: widget.child,
              )),
    );
  }
}

class ConstraintsProvider extends InheritedWidget {
  final BoxConstraints constraints;

  const ConstraintsProvider({
    super.key,
    required super.child,
    required this.constraints,
  });

  @override
  bool updateShouldNotify(ConstraintsProvider oldWidget) {
    return constraints != oldWidget.constraints;
  }

  static ConstraintsProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ConstraintsProvider>();

    assert(result != null, 'No ConstraintsProvider found in context');

    return result!;
  }
}
