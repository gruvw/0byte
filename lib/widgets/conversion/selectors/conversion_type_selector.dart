import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_types.dart';

class ConversionTypeSelector extends StatelessWidget {
  final ConversionType type;
  final bool isSelected;
  final VoidCallback? onSelected;

  const ConversionTypeSelector({
    super.key,
    required this.type,
    required this.isSelected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onSelected,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? ColorTheme.accent : ColorTheme.background1,
        shape: DimensionsTheme.conversionTypeSelectorBorder,
        side: const BorderSide(
          color: ColorTheme.accent,
          width: DimensionsTheme.conversionTypeSelectorBorderWidth,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: PaddingTheme.typeSelector,
        child: Text(
          type.prefix,
          style: GoogleFonts.getFont(
            FontTheme.firaCode,
            color: isSelected ? ColorTheme.background1 : ColorTheme.accent,
            fontSize: FontTheme.typeSelectorSize,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
