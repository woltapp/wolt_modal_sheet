import 'package:coffee_maker/entities/grouped_coffee_orders.dart';
import 'package:coffee_maker/entities/mock_coffee_orders.dart';
import 'package:coffee_maker/home/home_screen.dart';
import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: WoltColors.white,
        systemNavigationBarColor: WoltColors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // This is needed to make the app working with CupertinoApp.
      // For more details on CupertinoApp support, see the "CupertinoApp Support" section in the README file.
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
      ],
      scrollBehavior: const CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Theme(
        data: AppThemeData.themeData(context),
        child: HomeScreen(
          groupedCoffeeOrders: GroupedCoffeeOrders.fromCoffeeOrders(
            mockCoffeeOrders,
          ),
          isStoreOnline: true,
          isGridOverlayVisible: false,
        ),
      ),
    );
  }
}
