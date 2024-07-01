import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:playground/home/home_screen.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final androidSdkVersion =
      deviceInfo is AndroidDeviceInfo ? deviceInfo.version.sdkInt : 0;
  runApp(DemoApp(androidSdkVersion: androidSdkVersion));
}

const Color _darkSabGradientColor = Color(0xFF313236);

class DemoApp extends StatefulWidget {
  final int androidSdkVersion;

  const DemoApp({Key? key, required this.androidSdkVersion}) : super(key: key);

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  bool _isLightTheme = true;
  TextDirection _direction = TextDirection.ltr;

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
      scrollBehavior:
          CustomScrollBehavior(androidSdkVersion: widget.androidSdkVersion),
      theme: ThemeData.light().copyWith(
        brightness: Brightness.light,
        inputDecorationTheme: inputDecorationTheme,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: WoltColors.blue),
        extensions: const <ThemeExtension>[
          WoltModalSheetThemeData(
            modalBarrierColor: Color(0x52000000),
            surfaceTintColor: Colors.transparent,
          ),
        ],
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        brightness: Brightness.dark,
        inputDecorationTheme: inputDecorationTheme,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF009DE0)),
        useMaterial3: true,
        extensions: const <ThemeExtension>[
          WoltModalSheetThemeData(
            backgroundColor: Color(0xFF242424),
            modalBarrierColor: Color(0x52000000),
            sabGradientColor: _darkSabGradientColor,
          ),
        ],
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _direction == TextDirection.ltr
          ? const Locale('en')
          : const Locale('he'),
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('he', ''), // Hebrew
      ],
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
          onThemeBrightnessChanged: (bool isLightTheme) => setState(
                () => _isLightTheme = isLightTheme,
              ),
          onDirectionalityChanged: (TextDirection direction) {
            setState(() => _direction = direction);
          }),
    );
  }
}
