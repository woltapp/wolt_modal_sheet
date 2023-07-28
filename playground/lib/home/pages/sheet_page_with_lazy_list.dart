import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithLazyList {
  SheetPageWithLazyList._();

  static WoltModalSheetPage build({
    required VoidCallback onSabPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    final colors = allMaterialColors;
    const titleText = 'Material Colors';
    return WoltModalSheetPage.withCustomSliverList(
      mainContentPadding: EdgeInsetsDirectional.zero,
      stickyActionBar: StickyActionBarWrapper(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: WoltElevatedButton(
            onPressed: onSabPressed,
            child: Text(isLastPage ? "Close" : "Next"),
          ),
        ),
      ),
      pageTitle: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ModalSheetTitle(titleText),
      ),
      heroImageHeight: 200,
      heroImage: const Image(
        image: AssetImage('lib/assets/images/material_colors_hero.png'),
        fit: BoxFit.cover,
      ),
      backButton: WoltModalSheetBackButton(onBackPressed: onBackPressed),
      closeButton: WoltModalSheetCloseButton(onClosed: onClosed),
      sliverList: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            if (index == 0) {
              return const _HorizontalPrimaryColorList();
            }
            return ColorTile(color: colors[index]);
          },
          childCount: colors.length + 1,
        ),
      ),
    );
  }
}

class _HorizontalPrimaryColorList extends StatelessWidget {
  const _HorizontalPrimaryColorList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (Color color in Colors.primaries) Container(color: color, height: 100, width: 33),
        ],
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
