import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_types.dart';

// TODO extract constants

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
        backgroundColor:
            isSelected ? ColorTheme.accent : ColorTheme.background1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        side: const BorderSide(
          color: ColorTheme.accent,
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          type.prefix,
          style: GoogleFonts.getFont(
            FontTheme.firaCode,
            color: isSelected ? ColorTheme.background1 : ColorTheme.accent,
            fontSize: 35,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
