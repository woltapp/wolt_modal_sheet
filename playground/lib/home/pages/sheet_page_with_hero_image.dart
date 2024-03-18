import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithHeroImage {
  SheetPageWithHeroImage._();

  static WoltModalSheetPage build({
    required VoidCallback onSabPressed,
    required VoidCallback onBackPressed,
    required VoidCallback onClosed,
    bool isLastPage = true,
  }) {
    return WoltModalSheetPage(
      heroImage: const Image(
        image: AssetImage('lib/assets/images/hero_image.jpg'),
        fit: BoxFit.cover,
      ),
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: onSabPressed,
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      pageTitle: const ModalSheetTitle('Page with a hero image'),
      leadingNavBarWidget:
          WoltModalSheetBackButton(onBackPressed: onBackPressed),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: onClosed),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 80, top: 16, left: 16, right: 16),
        child: ModalSheetContentText('''
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
\n
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.

'''),
      ),
    );
  }
}
