import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/routes/route_generator.dart';
import 'package:app_0byte/state/providers/database.dart';

void main() async {
  await database.init();
  setPathUrlStrategy();

  FlutterNativeSplash.remove();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: SlidableAutoCloseBehavior(
        child: MaterialApp(
          title: "0byte",
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: "/",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: FontTheme.firaSans,
            scaffoldBackgroundColor: ColorTheme.background1,
            appBarTheme: const AppBarTheme(
              backgroundColor: ColorTheme.background3,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(),
              bodyMedium: TextStyle(),
            ).apply(
              bodyColor: ColorTheme.text1,
              displayColor: ColorTheme.text1,
            ),
          ),
        ),
      ),
    ),
  );
}
