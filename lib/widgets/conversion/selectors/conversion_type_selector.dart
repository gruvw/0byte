import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
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
        foregroundColor: UIColors.accent,
        backgroundColor: isSelected ? UIColors.accent : UIColors.background1,
        shape: DimensionsTheme.conversionTypeSelectorBorder,
        side: const BorderSide(
          color: UIColors.accent,
          width: DimensionsTheme.conversionTypeSelectorBorderWidth,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: PaddingTheme.typeSelector,
        child: Text(
          type.prefix,
          style: UITexts.number.copyWith(
            color: isSelected ? UIColors.background1 : UIColors.accent,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
