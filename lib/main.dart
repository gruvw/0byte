import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/routes/route_generator.dart';
import 'package:app_0byte/styles/colors.dart';

void main() async {
  await database.init();
  setPathUrlStrategy();

  FlutterNativeSplash.remove();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        title: "0byte",
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: FontTheme.fontFamily1,
          scaffoldBackgroundColor: ColorTheme.background1,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorTheme.background3,
          ),
          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: ColorTheme.text1,
            displayColor: ColorTheme.text1,
          ),
        ),
      ),
    ),
  );
}
