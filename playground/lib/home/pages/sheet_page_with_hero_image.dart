import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithHeroImage {
  SheetPageWithHeroImage._();

  static const ModalPageName pageId = ModalPageName.heroImage;

  static WoltModalSheetPage build({bool isLastPage = true}) {
    return WoltModalSheetPage(
      id: pageId,
      heroImage: const Image(
        image: AssetImage('lib/assets/images/hero_image.jpg'),
        fit: BoxFit.cover,
      ),
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Builder(builder: (context) {
          return WoltElevatedButton(
            onPressed: isLastPage
                ? Navigator.of(context).pop
                : WoltModalSheet.of(context).showNext,
            child: Text(isLastPage ? "Close" : "Next"),
          );
        }),
      ),
      pageTitle: const ModalSheetTitle('Page with a hero image'),
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 80, top: 16, left: 16, right: 16),
        child: ModalSheetContentText('''
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
'''),
      ),
    );
  }
}
