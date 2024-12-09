import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithNonScrollingLayout {
  SheetPageWithNonScrollingLayout._();

  static const ModalPageName pageId = ModalPageName.flexibleLayout;

  static NonScrollingWoltModalSheetPage build({
    bool isLastPage = true,
  }) {
    const textStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    return NonScrollingWoltModalSheetPage(
      id: pageId,
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      hasTopBarLayer: true,
      navBarHeight: 72.0,
      topBarTitle: const Text('Non-scrolling page'),
      child: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Flexible(
              flex: 2,
              child: Center(
                child: Text('Flex: 2', style: textStyle),
              ),
            ),
            const Flexible(
              flex: 3,
              child: ColoredBox(
                color: Colors.amber,
                child: Center(child: Text('Flex: 3', style: textStyle)),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: isLastPage
                    ? Navigator.of(context).pop
                    : WoltModalSheet.of(context).showNext,
                child: ColoredBox(
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "Flex: 1\n Tap here to ${isLastPage ? 'close' : 'go to the next page'}",
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
