import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:playground/home/widget/sheet_title.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithHeroImage {
  SheetPageWithHeroImage._();

  static WoltModalSheetPage build({
    required VoidCallback onFooterPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    return WoltModalSheetPage.withSingleChild(
      padding: const EdgeInsetsDirectional.all(16),
      heroImageHeight: 200,
      heroImage: const Image(
        image: AssetImage('lib/assets/images/hero_image.jpg'),
        fit: BoxFit.cover,
      ),
      footer: WoltElevatedButton(
        onPressed: onFooterPressed,
        child: Text(isLastPage ? "Close" : "Next"),
      ),
      pageTitle: const SheetTitle('Page with a hero image'),
      backButton: WoltBackButton(onBackPressed: onBackPressed),
      closeButton: WoltCloseButton(onClosed: onClosed),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80, top: 16),
        child: Column(
          children: const [
            Text('''
A hero image is a prominent and visually appealing image that is typically placed at the top
of a page or section to grab the viewer's attention and convey the main theme or message of
the content. It is often used in websites, applications, or marketing materials to create an
impactful and visually engaging experience.
'''),
          ],
        ),
      ),
    );
  }
}
