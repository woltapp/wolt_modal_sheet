import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/router_cubit.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithHeroImage {
  SheetPageWithHeroImage._();

  static WoltModalSheetPage build(
    BuildContext context, {
    required int currentPage,
    bool isLastPage = true,
  }) {
    final cubit = context.read<RouterCubit>();
    return WoltModalSheetPage.withSingleChild(
      heroImageHeight: 200,
      heroImage: const Image(
        image: AssetImage('lib/assets/images/hero_image.jpg'),
        fit: BoxFit.cover,
      ),
      stickyActionBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: WoltElevatedButton(
          onPressed: isLastPage ? cubit.closeSheet : () => cubit.goToPage(currentPage + 1),
          child: Text(isLastPage ? "Close" : "Next"),
        ),
      ),
      pageTitle: const ModalSheetTitle('Page with a hero image'),
      leadingNavBarWidget:
          WoltModalSheetBackButton(onBackPressed: () => cubit.goToPage(currentPage - 1)),
      trailingNavBarWidget: WoltModalSheetCloseButton(onClosed: cubit.closeSheet),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 80, top: 16, right: 16, left: 16),
        child: ModalSheetContentText('''
A hero image is a prominent and visually appealing image that is typically placed at the top of page or section to grab the viewer's attention and convey the main theme or message of the content. It is often used in websites, applications, or marketing materials to create an impactful and visually engaging experience.
'''),
      ),
    );
  }
}
