import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:playground/home/pages/modal_page_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SheetPageWithUpdatePage {
  SheetPageWithUpdatePage._();

  static const ModalPageName pageId = ModalPageName.updatePage;

  static WoltModalSheetPage build(
    BuildContext context, {
    bool isLastPage = true,
  }) {
    bool enableDrag = true;
    bool hasTopBarLayer = true;
    return WoltModalSheetPage(
      id: pageId,
      hasSabGradient: false,
      enableDrag: enableDrag,
      hasTopBarLayer: hasTopBarLayer,
      stickyActionBar: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: WoltElevatedButton(
            onPressed: isLastPage
                ? Navigator.of(context).pop
                : WoltModalSheet.of(context).showNext,
            colorName: WoltColorName.green,
            child: Text(isLastPage ? "Close" : "Next"),
          ),
        );
      }),
      isTopBarLayerAlwaysVisible: hasTopBarLayer,
      topBarTitle: const ModalSheetTopBarTitle('Update page'),
      leadingNavBarWidget: const WoltModalSheetBackButton(),
      trailingNavBarWidget: const WoltModalSheetCloseButton(),
      child: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _ConfigSwitch(
                label: 'Enable Drag for Bottom Sheet',
                initialConfigValue: enableDrag,
                updatePageCallback: ({required bool newValue}) {
                  WoltModalSheet.of(context).updateCurrentPage((currentPage) {
                    return currentPage.copyWith(
                        enableDrag: newValue,
                        mainContentSliversBuilder: (context) {
                          return [
                            SliverToBoxAdapter(
                              child: Placeholder(
                                fallbackHeight:
                                    MediaQuery.sizeOf(context).height / 2,
                                color: Colors.green,
                              ),
                            ),
                          ];
                        });
                  });
                },
              ),
              _ConfigSwitch(
                label: 'Is top bar layer visible',
                initialConfigValue: hasTopBarLayer,
                updatePageCallback: ({required bool newValue}) {
                  WoltModalSheet.of(context).updateCurrentPage((currentPage) {
                    return currentPage.copyWithChild(
                      isTopBarLayerAlwaysVisible: newValue,
                      hasTopBarLayer: newValue,
                      topBarTitle: newValue
                          ? const ModalSheetTopBarTitle('Update page')
                          : const SizedBox.shrink(),
                      leadingNavBarWidget: newValue
                          ? const WoltModalSheetBackButton()
                          : const SizedBox.shrink(),
                      trailingNavBarWidget: newValue
                          ? const WoltModalSheetCloseButton()
                          : const SizedBox.shrink(),
                      child: const Placeholder(
                          fallbackHeight: 1200, color: Colors.pink),
                    );
                  });
                },
              ),
              const Placeholder(fallbackHeight: 1200, color: Colors.grey),
            ],
          ),
        );
      }),
    );
  }
}

class _ConfigSwitch extends StatefulWidget {
  const _ConfigSwitch({
    required this.label,
    required this.initialConfigValue,
    required this.updatePageCallback,
  });

  final bool initialConfigValue;
  final String label;
  final void Function({required bool newValue}) updatePageCallback;

  @override
  State<_ConfigSwitch> createState() => _ConfigSwitchState();
}

class _ConfigSwitchState extends State<_ConfigSwitch> {
  late bool configValue;

  @override
  void initState() {
    super.initState();
    configValue = widget.initialConfigValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: Text(widget.label)),
          Switch(
            value: configValue,
            onChanged: (newValue) {
              setState(() {
                widget.updatePageCallback(newValue: newValue);
                configValue = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
