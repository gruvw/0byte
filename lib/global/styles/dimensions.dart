import 'package:flutter/material.dart';

abstract class DimensionsTheme {
  // Divider
  static const double conversionUnderlineWarningThickness = 3;
  static const double conversionUnderlineWarningHeight = 3;
  static const double entryDividerThickness = 2;
  static const double entryDividerHeight = 3;

  // Spacing
  static const double titleTargetHorizontalSpacing = 10;
  static const double titleConversionSizeHorizontalSpacing = 10;
  static const double digitsSelectorHorizontalSpacing = 5;
  static const double entryLabelNumberVerticalSpacing = 3;
  static const double converterPageEndScrollingSpacing = 100;
  static const double typesSelectorsWrapSpacing = 15;
  static const double drawerIconsSpacing = 5;
  static const double settingsCategorySpacing = 10;

  // Size
  static const double floatingActionChildrenSize = 62;
  static const double iconSize = 32;

  // Ratio
  static const double slidableWidth = 100;
  static const double formDialogWidthRatio = 0.7;

  // Border
  static const OutlinedBorder borderButtonBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
  static const OutlinedBorder conversionChipBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );
  static const OutlinedBorder conversionTypeSelectorBorder =
      conversionChipBorder;
  static const double borderButtonWidth = 2;
  static const double conversionTypeSelectorBorderWidth = 3;
}

abstract class PaddingTheme {
  static const EdgeInsetsGeometry zero = EdgeInsets.all(0);
  static const EdgeInsetsGeometry drawer = EdgeInsets.all(10);
  static const EdgeInsetsGeometry drawerFooter =
      EdgeInsets.fromLTRB(10, 15, 10, 10);
  static const EdgeInsetsGeometry secondaryBar =
      EdgeInsets.symmetric(vertical: 5, horizontal: 14);
  static const EdgeInsetsGeometry targetSecondaryBars =
      EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsetsGeometry conversionTitle =
      EdgeInsets.symmetric(vertical: 6, horizontal: 5);
  static const EdgeInsetsGeometry entry =
      EdgeInsets.symmetric(vertical: 6, horizontal: 14);
  static const EdgeInsetsGeometry conversionChip =
      EdgeInsets.only(left: 6, right: 6, top: 11);
  static const EdgeInsetsGeometry borderButton =
      EdgeInsets.symmetric(vertical: 12, horizontal: 14);
  static const EdgeInsetsGeometry borderButtonChild =
      EdgeInsets.fromLTRB(12, 4, 0, 4);
  static const EdgeInsetsGeometry typeSelector =
      EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsetsGeometry typesSelectors =
      EdgeInsets.symmetric(horizontal: 15, vertical: 15);
  static const EdgeInsetsGeometry entryPageSubmit =
      EdgeInsets.symmetric(vertical: 10, horizontal: 14);
  static const EdgeInsetsGeometry settings = EdgeInsets.fromLTRB(10, 15, 10, 0);
  static const EdgeInsetsGeometry settingsCategoryIndentation =
      EdgeInsets.fromLTRB(15, 5, 0, 0);
  static const EdgeInsetsGeometry switchButton =
      EdgeInsets.symmetric(vertical: 3);
  static const EdgeInsetsGeometry switchText = EdgeInsets.only(left: 10);
}
