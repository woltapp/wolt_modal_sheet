import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/layout/dummy/dummy_size_sliver.dart';
import 'package:wolt_modal_sheet/src/layout/footer/wolt_modal_sheet_footer.dart';
import 'package:wolt_modal_sheet/src/layout/header/modal_sheet_header.dart';
import 'package:wolt_modal_sheet/src/layout/scroll_view/wolt_modal_sheet_page_scroll_view.dart';

class WoltModalSheetPageLayout extends StatefulWidget {
  final Widget? header;
  final Widget? footer;
  final List<Widget> slivers;

  const WoltModalSheetPageLayout({
    super.key,
    this.header,
    this.footer,
    required this.slivers,
  });

  @override
  State<WoltModalSheetPageLayout> createState() =>
      _WoltModalSheetPageLayoutState();
}

class _WoltModalSheetPageLayoutState extends State<WoltModalSheetPageLayout>
    with TickerProviderStateMixin {
  final _footerSizeDispatcher = ValueNotifier<double>(0);

  @override
  Widget build(BuildContext context) {
    return WoltModalSheetPageScrollView(
      slivers: [
        if (widget.header != null)
          ModalSheetHeader(
            child: Hero(
              tag: 'Header',
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                return FadeTransition(
                  opacity: _WoltModalSheetHeaderAnimationController(
                    parent: animation,
                    vsync: this,
                  ).opacity,
                  child: toHeroContext.widget,
                );
              },
              child: widget.header!,
            ),
          ),
        if (widget.footer != null)
          WoltModalSheetFooter(
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
                        (fromBox.parent as WoltModalSheetFooterRenderSliver)
                            .correction;
                    final correctionTo =
                        (toBox.parent as WoltModalSheetFooterRenderSliver)
                            .correction;
                    final av = animation.isForwardOrCompleted
                        ? animation.value
                        : 1 - animation.value;
                    final offset = Offset(0,
                        correctionFrom + (correctionTo - correctionFrom) * av);

                    return Transform.translate(offset: offset, child: child);
                  },
                  child: fromHeroContext.widget,
                );
              },
              child: widget.footer!,
            ),
          ),
        ...widget.slivers,
        if (widget.footer != null)
          DummySizeSliver(trackedSizeDispatcher: _footerSizeDispatcher),
      ],
    );
  }
}

class _WoltModalSheetHeaderAnimationController extends AnimationController {
  final _disappearDuration = const Duration(milliseconds: 100);
  final _appearDuration = const Duration(milliseconds: 200);

  late final Animation<double> _opacityAnimation;

  Animation<double> get opacity => _opacityAnimation;

  _WoltModalSheetHeaderAnimationController(
      {required Animation<double> parent, required super.vsync}) {
    _opacityAnimation = TweenSequence<double>(
      [
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
