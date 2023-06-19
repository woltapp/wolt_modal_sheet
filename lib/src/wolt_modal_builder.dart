import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_custom_layout.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class WoltModalBuilder extends StatefulWidget {
  const WoltModalBuilder({
    required this.pageListBuilderNotifier,
    required this.pageIndexNotifier,
    required this.onModalDismissedWithBarrierTap,
    required this.decorator,
    required this.modalTypeBuilder,
    super.key,
  });

  final ValueNotifier<WoltModalSheetPageListBuilder> pageListBuilderNotifier;
  final ValueNotifier<int> pageIndexNotifier;
  final VoidCallback? onModalDismissedWithBarrierTap;
  final Widget Function(Widget)? decorator;
  final WoltModalType Function(BuildContext context) modalTypeBuilder;

  @override
  State<WoltModalBuilder> createState() => _WoltModalBuilderState();
}

class _WoltModalBuilderState extends State<WoltModalBuilder> {
  late WoltModalType scrollableModalType;

  ValueNotifier<int> get pageIndexNotifier => widget.pageIndexNotifier;

  ValueNotifier<WoltModalSheetPageListBuilder> get pagesListBuilderNotifier =>
      widget.pageListBuilderNotifier;

  Widget Function(Widget)? get decorator => widget.decorator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollableModalType = widget.modalTypeBuilder(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([pageIndexNotifier, pagesListBuilderNotifier]),
      builder: (BuildContext context, Widget? child) {
        final modal = WoltModalCustomLayout(
          pageIndex: pageIndexNotifier.value,
          pages: pagesListBuilderNotifier.value(context),
          woltModalType: scrollableModalType,
          onModalDismissedWithBarrierTap: () {
            widget.onModalDismissedWithBarrierTap?.call();
            Navigator.of(context).pop();
          },
        );
        final decorator = this.decorator;
        return decorator == null ? modal : decorator(modal);
      },
    );
  }
}
