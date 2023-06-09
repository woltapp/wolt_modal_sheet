import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_animated_layout_builder.dart';
import 'package:wolt_modal_sheet/src/content/wolt_modal_sheet_multi_child_layout_delegate.dart';
import 'package:wolt_modal_sheet/src/modal_page/wolt_modal_sheet_page.dart';
import 'package:wolt_modal_sheet/src/modal_type/wolt_modal_type.dart';

/// The content of the scrollable modal sheet.
class WoltModalCustomLayout extends StatelessWidget {
  /// Creates a [WoltModalCustomLayout].
  ///
  /// [pages] represents the list of pages to be displayed in the modal sheet.
  ///
  /// [woltModalType] represents the type of the scrollable modal.
  ///
  /// [pageIndex] represents the index of the current page being displayed.
  ///
  /// [onModalDismissedWithBarrierTap] is a callback invoked when the modal sheet is dismissed by tapping the barrier.
  ///
  /// [goToPreviousPage] is a callback invoked when the user wants to navigate to the previous page.
  const WoltModalCustomLayout({
    required this.pages,
    required this.pageIndex,
    required this.woltModalType,
    required this.goToPreviousPage,
    this.onModalDismissedWithBarrierTap,
    super.key,
  }) : assert(pageIndex >= 0 && pageIndex < pages.length, 'Invalid pageIndex');

  final List<WoltModalSheetPage> pages;
  final WoltModalType woltModalType;
  final int pageIndex;
  final VoidCallback? onModalDismissedWithBarrierTap;
  final VoidCallback goToPreviousPage;

  @visibleForTesting
  static const barrierLayoutId = 'barrierLayoutId';
  static const contentLayoutId = 'contentLayoutId';

  static const double _containerRadiusAmount = 24;

  @override
  Widget build(BuildContext context) {
    final page = pages[pageIndex];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomMultiChildLayout(
          delegate: WoltModalSheetMultiChildLayoutDelegate(
            contentLayoutId: contentLayoutId,
            barrierLayoutId: barrierLayoutId,
            scrollableModalType: woltModalType,
            maxPageHeight: page.maxPageHeight,
            minPageHeight: page.minPageHeight,
          ),
          children: [
            LayoutId(
              id: barrierLayoutId,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onModalDismissedWithBarrierTap,
                child: const SizedBox.expand(),
              ),
            ),
            LayoutId(
              id: contentLayoutId,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: woltModalType.borderRadiusGeometry(
                    /// TODO: Make this configurable through theme extension
                    _containerRadiusAmount,
                  ),
                  color: page.backgroundColor,
                ),
                clipBehavior: Clip.antiAlias,
                child: WoltModalSheetAnimatedLayoutBuilder(
                  woltModalType: woltModalType,
                  onBackButtonPressed: goToPreviousPage,
                  pageIndex: pageIndex,
                  pages: pages,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
