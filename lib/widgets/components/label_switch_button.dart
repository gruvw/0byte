import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';

class LabelSwitchButton extends StatelessWidget {
  final bool enabled;
  final String? label;

  final void Function(bool newEnabled)? onChanged;

  const LabelSwitchButton({
    super.key,
    required this.enabled,
    this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Row(
      children: [
        Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: ColorTheme.accent,
          inactiveTrackColor: ColorTheme.background3,
        ),
        if (label != null)
          Text(
            label,
            style: GoogleFonts.getFont(
              FontTheme.firaSans,
              color: ColorTheme.text1,
              fontSize: FontTheme.switchLabelSize,
            ),
          ),
      ],
    );
  }
}
