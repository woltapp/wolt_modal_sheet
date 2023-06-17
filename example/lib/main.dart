import 'dart:io';

import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:example/entities/grouped_coffee_orders.dart';
import 'package:example/home/home_screen.dart';
import 'package:example/entities/mock_coffee_orders.dart';
import 'constants/demo_app_colors.dart';

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
        systemNavigationBarDividerColor: DemoAppColors.white,
        systemNavigationBarColor: DemoAppColors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: DemoAppColors.blue,
        useMaterial3: false,
        fontFamily: 'Inter',
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: kIsWeb || Platform.isAndroid ? 0.2 : 0.12,
          ),
        ),
        typography: Typography.material2021(platform: defaultTargetPlatform),
        scaffoldBackgroundColor: DemoAppColors.white,
        indicatorColor: Colors.transparent,
        cardColor: DemoAppColors.white,
        cardTheme: CardTheme(
          elevation: 2,
          color: DemoAppColors.white,
          surfaceTintColor: DemoAppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            textStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            foregroundColor: DemoAppColors.black,
            backgroundColor: DemoAppColors.white,
            surfaceTintColor: DemoAppColors.white,
            fixedSize: const Size.fromHeight(36),
            padding: const EdgeInsets.all(12),
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide.none,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 56,
          surfaceTintColor: Colors.transparent,
          backgroundColor: DemoAppColors.white,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (state) {
              return TextStyle(
                fontSize: 10,
                color: state.contains(MaterialState.selected)
                    ? DemoAppColors.blue
                    : DemoAppColors.black64,
              );
            },
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: ScrollConfiguration(
        behavior: const DragScrollBehavior(),
        child: HomeScreen(
          groupedCoffeeOrders: GroupedCoffeeOrders.fromCoffeeOrders(mockCoffeeOrders),
          isStoreOnline: true,
        ),
      ),
    );
  }
}
