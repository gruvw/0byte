import 'package:flutter/material.dart';

abstract class UIColors {
  static const Color background1 = Color(0xFF343A40);
  static const Color background2 = Color(0xFF2B3035);
  static const Color background3 = Color(0xFF212529);

  static const Color text1 = Color(0xFFF8F9FA);
  static const Color text2 = Color(0xFFC7CACC);

  static const Color textPrefix = Color(0xFF0ba6f3);

  static const Color accent = Color(0xFF16DB65);
  static const Color danger = Color(0xFFF21A35);
  static const Color warning = Color(0xffff7900);

  static const none = Colors.transparent;
}

// TODO fix colors
abstract class UIThemes {
  // Material 3 color scheme
  static const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: UIColors.background1,
    onPrimary: UIColors.text1,
    secondary: UIColors.background1,
    onSecondary: UIColors.text1,
    error: UIColors.danger,
    onError: UIColors.text1,
    background: UIColors.background1,
    onBackground: UIColors.text1,
    surface: UIColors.background1,
    onSurface: UIColors.text1,
    surfaceTint: UIColors.none,
    surfaceVariant: UIColors.none,
  );

  static final textSelectionTheme = TextSelectionThemeData(
    cursorColor: UIColors.text1,
    selectionColor: UIColors.textPrefix.withOpacity(0.4),
    selectionHandleColor: UIColors.text1,
  );
}
