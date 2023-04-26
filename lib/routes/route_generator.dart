import 'package:flutter/material.dart';

import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/routes/converter_page.dart';
import 'package:app_0byte/routes/entry_page.dart';

enum Routes {
  home("/"),
  entry("/entry"),
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
          builder: (context) => const ConverterPage(),
        );
      case Routes.entry:
        if (args is List &&
            args.isNotEmpty &&
            args[0] is NumberConversionEntry) {
          return MaterialPageRoute(
            builder: (context) => EntryPage(
              entry: args[0],
              deleteOnCancel: args.length > 1 && args[1],
            ),
          );
        }
        return _errorRoute();
      case Routes.error:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("ERROR"),
        ),
        body: const Center(
          child: Text("ERROR"),
        ),
      ),
    );
  }
}
