part of '../wolt_modal_sheet.dart';

class _NavigationStack extends StatefulWidget {
  final ValueListenable<List<Page>> changePagesNotifier;
  final Function(GlobalKey?) onTopPageChanged;

  const _NavigationStack({
    required this.changePagesNotifier,
    required this.onTopPageChanged,
  });

  @override
  State<_NavigationStack> createState() => _NavigationStackState();
}

// TODO: hide the navigator from the user, there should be only 1
// way to interact - WoltModalSheetNavigator, otherwise things can be broken.
class _NavigationStackState extends State<_NavigationStack> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.changePagesNotifier,
      builder: (context, listPages, child) => Navigator(
        key: _navigatorKey,
        pages: listPages,
        clipBehavior: Clip.none,
        observers: [
          _WoltNavigatorObserver(
            context,
            widget.onTopPageChanged,
          ),
          HeroController(),
        ],
        onDidRemovePage: (page) {},
      ),
    );
  }
}

class _WoltNavigatorObserver extends NavigatorObserver {
  final BuildContext context;
  final Function(GlobalKey?) onTopPageChanged;

  _WoltNavigatorObserver(
    this.context,
    this.onTopPageChanged,
  );

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is WoltModalPageRoute) {
      onTopPageChanged((route as WoltModalPageRoute).contentKey);
    } else {
      onTopPageChanged(null);
    }

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute is WoltModalPageRoute) {
      onTopPageChanged((previousRoute as WoltModalPageRoute).contentKey);
    } else {
      onTopPageChanged(null);
    }

    super.didPop(route, previousRoute);
  }
}
