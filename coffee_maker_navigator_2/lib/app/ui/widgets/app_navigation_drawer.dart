import 'package:coffee_maker_navigator_2/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

enum AppNavigationDrawerDestination {
  ordersScreen(label: Text("Orders"), icon: Icon(Icons.coffee)),
  tutorialsScreen(label: Text("Tutorials"), icon: Icon(Icons.menu_book_outlined)),
  logOut(label: Text("Log out"), icon: Icon(Icons.logout));

  const AppNavigationDrawerDestination({
    required this.icon,
    required this.label,
  });

  final Widget icon;
  final Widget label;

  static AppNavigationDrawerDestination fromIndex(int index) {
    switch (index) {
      case 0:
        return AppNavigationDrawerDestination.ordersScreen;
      case 1:
        return AppNavigationDrawerDestination.tutorialsScreen;
      case 2:
        return AppNavigationDrawerDestination.logOut;
      default:
        return AppNavigationDrawerDestination.ordersScreen;
    }
  }
}

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({required this.selectedIndex, super.key});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        /// STEP #16: Handle the back button press event.
        /*
        final scaffold = Scaffold.maybeOf(context);
        if (scaffold != null && scaffold.isDrawerOpen) {
          // If view is open, close it and return true to indicate
          // that the router should not handle the back button.
          scaffold.closeDrawer();

          return true;
        }
         */
        // If view is not open, return false to indicate that
        // the router should handle this.
        return false;
      },
      child: NavigationDrawer(
        selectedIndex: selectedIndex,
        children: [
          const _NavigationDrawerHeader(),
          NavigationDrawerDestination(
            icon: AppNavigationDrawerDestination.ordersScreen.icon,
            label: AppNavigationDrawerDestination.ordersScreen.label,
          ),
          NavigationDrawerDestination(
            icon: AppNavigationDrawerDestination.tutorialsScreen.icon,
            label: AppNavigationDrawerDestination.tutorialsScreen.label,
          ),
          NavigationDrawerDestination(
            icon: AppNavigationDrawerDestination.logOut.icon,
            label: AppNavigationDrawerDestination.logOut.label,
          ),
        ],
        onDestinationSelected: (int index) {
          final scaffold = Scaffold.maybeOf(context);
          if (scaffold != null && scaffold.isDrawerOpen) {
            scaffold.closeDrawer();
            Future.delayed(const Duration(milliseconds: 250), () {
              if (context.mounted) {
                // If the view is still mounted, navigate to the selected destination.
                context.routerViewModel.onDrawerDestinationSelected(
                  AppNavigationDrawerDestination.fromIndex(index),
                );
              }
            });
          }
        },
      ),
    );
  }
}

class _NavigationDrawerHeader extends StatelessWidget {
  const _NavigationDrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Coffee Maker', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
