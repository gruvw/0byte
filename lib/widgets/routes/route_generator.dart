import 'package:app_0byte/widgets/routes/settings/settings_route.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/widgets/routes/converter/converter_route.dart';
import 'package:app_0byte/widgets/routes/entry/entry_route.dart';

enum Routes {
  home("/"),
  entry("/entry"),
  settings("/settings"),
  error("/error");

  static Routes get miss => error;

  static Routes parse(String name) {
    return Routes.values.firstWhere((e) => e.name == name, orElse: () => miss);
  }

  final String name;

  const Routes(this.name);
}

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (Routes.parse(settings.name ?? Routes.miss.name)) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => const ConverterRoute(),
        );
      case Routes.entry:
        if (args is List &&
            args.isNotEmpty &&
            args[0] is NumberConversionEntry) {
          return MaterialPageRoute(
            builder: (context) => EntryRoute(
              entry: args[0],
              deleteOnCancel: args.length > 1 && args[1],
            ),
          );
        }
        return _errorRoute();
      case Routes.settings:
        return MaterialPageRoute(
          builder: (context) => const SettingsRoute(),
        );
      case Routes.error:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(UIValues.errorRouteText),
        ),
        body: const Center(
          child: Text(UIValues.errorRouteText),
        ),
      ),
    );
  }
}
