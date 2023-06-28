import 'dart:io';

import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground_navigator2/bloc/playground_cubit.dart';
import 'package:playground_navigator2/router/playground_route_information_parser.dart';
import 'package:playground_navigator2/router/playground_router_delegate.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  late PlaygroundCubit playgroundCubit;

  @override
  void initState() {
    super.initState();
    playgroundCubit = PlaygroundCubit();
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
    return ScrollConfiguration(
      behavior: const DragScrollBehavior(),
      child: BlocProvider(
        create: (context) => playgroundCubit,
        child: MaterialApp.router(
          routeInformationParser: const PlaygroundRouteInformationParser(),
          backButtonDispatcher: RootBackButtonDispatcher(),
          routerDelegate: PlaygroundRouterDelegate(playgroundCubit),
          theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
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
            ),
            primaryColor: WoltColors.blue,
            useMaterial3: true,
            fontFamily: 'Inter',
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: kIsWeb || Platform.isAndroid ? 0.2 : 0.12,
              ),
            ),
            typography: Typography.material2021(platform: defaultTargetPlatform),
            scaffoldBackgroundColor: WoltColors.white,
            indicatorColor: Colors.transparent,
            cardColor: WoltColors.white,
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
