import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/router_cubit.dart';
import 'package:playground_navigator2/modal/pages/multi_page_path_name.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RootSheetPage {
  RootSheetPage._();

  static final ValueNotifier<bool> _isButtonEnabledNotifier =
      ValueNotifier(false);

  static WoltModalSheetPage build(BuildContext context) {
    const title = 'Choose a use case';
    return WoltModalSheetPage(
      stickyActionBar: ValueListenableBuilder<bool>(
        valueListenable: _isButtonEnabledNotifier,
        builder: (_, value, __) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: WoltElevatedButton(
              onPressed: () => context.read<RouterCubit>().goToPage(1),
              enabled: value,
              child: const Text("Let's start!"),
            ),
          );
        },
      ),
      pageTitle: const ModalSheetTitle(title),
      hasTopBarLayer: false,
      trailingNavBarWidget: WoltModalSheetCloseButton(
          onClosed: context.read<RouterCubit>().closeSheet),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          children: [
            WoltSelectionList<MultiPagePathName>.singleSelect(
              itemTileDataGroup: const WoltSelectionListItemDataGroup(
                group: [
                  WoltSelectionListItemData(
                    title: 'Page with forced max height',
                    value: MultiPagePathName.forcedMaxHeight,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'Page with hero image',
                    value: MultiPagePathName.heroImage,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'Page with lazy loading list',
                    value: MultiPagePathName.lazyLoadingList,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'Page with auto-focus text field',
                    value: MultiPagePathName.textField,
                    isSelected: false,
                  ),
                  WoltSelectionListItemData(
                    title: 'All the pages in one flow',
                    value: MultiPagePathName.allPagesPath,
                    isSelected: false,
                  ),
                ],
              ),
              onSelectionUpdateInSingleSelectionList: (selectedItemData) {
                context
                    .read<RouterCubit>()
                    .onPathUpdated(selectedItemData.value);
                _isButtonEnabledNotifier.value = selectedItemData.isSelected;
              },
            ),
            const _AllPagesPushWidget(),
          ],
        ),
      ),
    );
  }
}

class _AllPagesPushWidget extends StatelessWidget {
  const _AllPagesPushWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          trailing: const Icon(Icons.arrow_forward_ios),
          title: const Text('All the pages in one flow'),
          subtitle: const Text(
            'Pressing this tile will append the page list and show the next page',
          ),
          onTap: () {
            context.read<RouterCubit>().onPathAndPageIndexUpdated(
                  MultiPagePathName.allPagesPath,
                  1,
                );
          },
        ),
      ],
    );
  }
}
