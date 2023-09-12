import 'dart:io';

import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/home/home_screen.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() => runApp(const DemoApp());

const Color _darkSabGradientColor = Color(0xFF313236);

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool _isLightTheme = true;

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
    const inputDecorationTheme = InputDecorationTheme(
      suffixStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: WoltColors.black64,
      ),
      contentPadding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      border: UnderlineInputBorder(borderSide: BorderSide.none),
      constraints: BoxConstraints(minHeight: 64),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: WoltColors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: WoltColors.black16),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusColor: WoltColors.blue,
    );
    return MaterialApp(
      themeMode: _isLightTheme ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData.light().copyWith(
        brightness: Brightness.light,
        inputDecorationTheme: inputDecorationTheme,
        primaryColor: WoltColors.blue,
        useMaterial3: true,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(WoltColors.blue),
          trackColor: MaterialStateProperty.all(WoltColors.blue16),
        ),
        extensions: const <ThemeExtension>[
          WoltModalSheetThemeData(
            modalBarrierColor: Colors.black54,
          ),
        ],
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        brightness: Brightness.dark,
        inputDecorationTheme: inputDecorationTheme,
        primaryColor: WoltColors.blue,
        useMaterial3: true,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(WoltColors.blue),
          trackColor: MaterialStateProperty.all(WoltColors.blue16),
        ),
        extensions: const <ThemeExtension>[
          WoltModalSheetThemeData(
            modalBarrierColor: Colors.white12,
            sabGradientColor: _darkSabGradientColor,
            dialogShape: BeveledRectangleBorder(),
            bottomSheetShape: BeveledRectangleBorder(),
          ),
        ],
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        onThemeBrightnessChanged: (bool isLightTheme) => setState(
          () => _isLightTheme = isLightTheme,
        ),
      ),
    );
  }
}
