import 'package:app_0byte/routes/route_generator.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: ColorTheme.background1,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorTheme.background3,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          fontFamily: "Fira Code",
          bodyColor: ColorTheme.text1,
          displayColor: ColorTheme.text1,
        ),
      ),
    ),
  );
}
