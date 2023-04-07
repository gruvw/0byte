import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:flutter/material.dart';

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
        if (args is Mutable<NumberEntry>) {
          return MaterialPageRoute(
            builder: (context) => EntryPage(entry: args),
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
