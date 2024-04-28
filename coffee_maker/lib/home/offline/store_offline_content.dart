import 'package:coffee_maker/constants/demo_app_colors.dart';
import 'package:coffee_maker/home/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:wolt_responsive_layout_grid/wolt_responsive_layout_grid.dart';

/// /// By default, the `widthBreakPoint` is set to 768, which corresponds to the common breakpoint between small and large screens.
const defaultWidthBreakPoint = 768;

/// The content displayed when the store is in the offline state.
class StoreOfflineContent extends StatefulWidget {
  /// Creates a new instance of [StoreOfflineContent] widget.
  ///
  /// The [isStoreOnlineNotifier] is a [ValueNotifier] that tracks the online state of the store.
  const StoreOfflineContent({
    required ValueNotifier<bool> isStoreOnlineNotifier,
    ValueNotifier<bool>? isGridOverlayVisibleNotifier,
    super.key,
  })  : _isStoreOnlineNotifier = isStoreOnlineNotifier,
        _isGridOverlayVisibleNotifier = isGridOverlayVisibleNotifier;

  final ValueNotifier<bool> _isStoreOnlineNotifier;
  final ValueNotifier<bool>? _isGridOverlayVisibleNotifier;

  @override
  State<StoreOfflineContent> createState() => _StoreOfflineContentState();
}

class _StoreOfflineContentState extends State<StoreOfflineContent> {
  @override
  Widget build(BuildContext context) {
    final content =
        _OfflineContent(isStoreOnlineNotifier: widget._isStoreOnlineNotifier);
    final screenSize =
        MediaQuery.sizeOf(context).width < defaultWidthBreakPoint
            ? WoltScreenSize.small
            : WoltScreenSize.large;
    final isLargeScreen = screenSize == WoltScreenSize.large;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              isStoreOnlineNotifier: widget._isStoreOnlineNotifier,
              isGridOverlayVisibleNotifier:
                  isLargeScreen ? widget._isGridOverlayVisibleNotifier : null,
            ),
            Expanded(
              child: ColoredBox(
                color: DemoAppColors.red,
                child: WoltScreenWidthAdaptiveWidget(
                  smallScreenWidthChild: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: content,
                    ),
                  ),
                  largeScreenWidthChild: WoltResponsiveLayoutGrid.centered(
                    centerWidgetColumnCount: 2,
                    paddedColumnCountPerSide: 1,
                    isOverlayVisible:
                        widget._isGridOverlayVisibleNotifier?.value ?? false,
                    child: content,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineContent extends StatelessWidget {
  const _OfflineContent({
    required ValueNotifier<bool> isStoreOnlineNotifier,
  }) : _isStoreOnlineNotifier = isStoreOnlineNotifier;

  final ValueNotifier<bool> _isStoreOnlineNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'You are offline',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.bold, color: DemoAppColors.white),
        ),
        const SizedBox(height: 12),
        Text(
          'Go online to receive new orders.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: DemoAppColors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 56,
          child: OutlinedButton(
            onPressed: () => _isStoreOnlineNotifier.value = true,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Go online',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
