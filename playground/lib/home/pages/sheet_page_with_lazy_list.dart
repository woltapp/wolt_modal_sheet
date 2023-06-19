import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithLazyList {
  SheetPageWithLazyList._();

  static WoltModalSheetPage build({
    required VoidCallback onFooterPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    final colors = allMaterialColors;
    const titleText = 'Material Colors';
    return WoltModalSheetPage.withCustomSliverList(
      footer: StickyActionBarWrapper(
        child: WoltElevatedButton(
          onPressed: onFooterPressed,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      pageTitle: Padding(
        padding: const EdgeInsets.all(16) - const EdgeInsets.only(top: 16),
        child: const ModalSheetTitle(titleText),
      ),
      topBarTitle: const ModalSheetTopBarTitle(titleText),
      backButton: WoltModalSheetBackButton(onBackPressed: onBackPressed),
      closeButton: WoltModalSheetCloseButton(onClosed: onClosed),
      sliverList: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => ColorTile(color: colors[index]),
          childCount: colors.length,
        ),
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final Color color;

  const ColorTile({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 100,
      child: Center(
        child: Text(
          color.toString(),
          style: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

List<Color> get allMaterialColors {
  List<Color> allMaterialColorsWithShades = [];

  for (MaterialColor color in Colors.primaries) {
    allMaterialColorsWithShades.add(color.shade100);
    allMaterialColorsWithShades.add(color.shade200);
    allMaterialColorsWithShades.add(color.shade300);
    allMaterialColorsWithShades.add(color.shade400);
    allMaterialColorsWithShades.add(color.shade500);
    allMaterialColorsWithShades.add(color.shade600);
    allMaterialColorsWithShades.add(color.shade700);
    allMaterialColorsWithShades.add(color.shade800);
    allMaterialColorsWithShades.add(color.shade900);
  }
  return allMaterialColorsWithShades;
}
