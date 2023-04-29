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

  // Size
  static const double floatingActionChildrenSize = 62;
  static const double dropdownIconSize = 32;

  // Ratio
  static const double slidableExtendRatio = 0.2;
  static const double formDialogWidthRatio = 0.7;

  // Border
  static const OutlinedBorder borderButtonBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)));
  static const OutlinedBorder conversionChipBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)));
  static const OutlinedBorder conversionTypeSelectorBorder = conversionChipBorder;
  static const double borderButtonWidth = 2;
  static const double conversionTypeSelectorBorderWidth = 3;
}

abstract class PaddingTheme {
  static const EdgeInsetsGeometry drawer = EdgeInsets.all(10);
  static const EdgeInsetsGeometry secondaryBar = EdgeInsets.symmetric(vertical: 5, horizontal: 14);
  static const EdgeInsetsGeometry targetSecondaryBars = EdgeInsets.symmetric(vertical: 5);
  static const EdgeInsetsGeometry conversionTitle =
      EdgeInsets.symmetric(vertical: 10, horizontal: 5);
  static const EdgeInsetsGeometry entry = EdgeInsets.symmetric(vertical: 8, horizontal: 14);
  static const EdgeInsetsGeometry conversionChip = EdgeInsets.symmetric(horizontal: 6);
  static const EdgeInsetsGeometry borderButton = EdgeInsets.symmetric(vertical: 6);
  static const EdgeInsetsGeometry borderButtonChild = EdgeInsets.fromLTRB(12, 4, 0, 4);
  static const EdgeInsetsGeometry typeSelector = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsetsGeometry entryPagePreview = EdgeInsets.all(14);
  static const EdgeInsetsGeometry entryPageSubmit =
      EdgeInsets.symmetric(vertical: 10, horizontal: 14);
}
