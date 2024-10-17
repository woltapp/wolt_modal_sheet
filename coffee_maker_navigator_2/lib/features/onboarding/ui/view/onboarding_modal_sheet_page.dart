import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class OnboardingModalSheetPage extends WoltModalSheetPage {
  OnboardingModalSheetPage()
      : super(
          child: const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 150),
            child: ModalSheetContentText('''
We're excited to assist you with the orders. To ensure you get the most out of our app, we've prepared a brief tutorial that will guide you through the features and functionalities available.
\nLet's begin your journey to quick and easy coffee order fulfillment!
'''),
          ),
          heroImage: const Image(
            image: AssetImage('lib/assets/images/welcome_modal.webp'),
            fit: BoxFit.cover,
          ),
          pageTitle: const Padding(
            padding: EdgeInsets.only(top: 16),
            child: ModalSheetTitle('Welcome! 👋'),
          ),
          trailingNavBarWidget: const WoltModalSheetCloseButton(),
          stickyActionBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Builder(builder: (context) {
                  return WoltElevatedButton(
                    onPressed: () {
                      // No need to call RouterViewModel because onPopPage method of the
                      // RouterDelegate will capture this and the RouterViewModel will handle
                      // from there.
                      Navigator.of(context).pop();
                    },
                    theme: WoltElevatedButtonTheme.secondary,
                    child: const Text('Show me later'),
                  );
                }),
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  return WoltElevatedButton(
                    onPressed: () {
                      context.routerViewModel
                          .onUserRequestedTutorialFromOnboardingModal();
                    },
                    child: const Text('Show me tutorials!'),
                  );
                }),
              ],
            ),
          ),
        );
}
