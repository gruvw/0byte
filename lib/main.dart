import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/widgets/utils/app_scroll_behavior.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:app_0byte/widgets/routes/route_generator.dart';
import 'package:app_0byte/state/providers/database.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await database.init();
  setPathUrlStrategy();

  FlutterNativeSplash.remove();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: SlidableAutoCloseBehavior(
        child: MaterialApp(
          title: CoreValues.appTitle,
          initialRoute: Routes.home.name,
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: UIThemes.colorScheme,
            textSelectionTheme: UIThemes.textSelectionTheme,
            visualDensity: VisualDensity.compact,
          ),
          builder: (context, child) => ScrollConfiguration(
            behavior: AppScrollBehavior(),
            child: child!,
          ),
        ),
      ),
    ),
  );
}
