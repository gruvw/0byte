import 'package:flutter/material.dart';

import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/routes/converter_page.dart';
import 'package:app_0byte/routes/entry_page.dart';

const routeHome = "/";
const routeEntry = "/entry";

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(
          builder: (context) => const ConverterPage(),
        );
      case routeEntry:
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
      default:
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
