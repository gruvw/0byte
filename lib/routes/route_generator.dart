import 'package:app_0byte/routes/converter_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) {
          return const ConverterPage();
        });
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
