import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithNonScrollingLayout {
  SheetPageWithNonScrollingLayout._();

  static NonScrollingWoltModalSheetPage build({
    required VoidCallback nextPagePressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    const textStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    return NonScrollingWoltModalSheetPage(
      leadingNavBarWidget:
          WoltModalSheetBackButton(onBackPressed: onBackPressed),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Flexible(
            flex: 2,
            child: ColoredBox(
              color: Colors.blue,
              child: Center(
                child: Text('Flex: 2', style: textStyle),
              ),
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
              onTap: isLastPage ? onClosed : nextPagePressed,
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
      ),
    );
  }
}
