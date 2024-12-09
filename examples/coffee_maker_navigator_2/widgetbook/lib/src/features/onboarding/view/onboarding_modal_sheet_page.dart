import 'package:coffee_maker_navigator_2/features/onboarding/ui/view/onboarding_modal_sheet_page.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

@UseCase(
  name: 'OnboardingModalSheetPage',
  type: OnboardingModalSheetPage,
  path: 'Onboarding/View/',
)
Widget onboardingModalSheetPage(BuildContext context) {
  return Scaffold(
    body: Center(
      child: WoltElevatedButton(
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (context) => [
              OnboardingModalSheetPage(),
            ],
          );
        },
        child: const Text('Open OnboardingModalSheetPage'),
      ),
    ),
  );
}
