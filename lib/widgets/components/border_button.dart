import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';

class BorderButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;
  final Widget? child;

  const BorderButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final child = this.child;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        shape: DimensionsTheme.borderButtonBorder,
        side: BorderSide(
          color: color,
          width: DimensionsTheme.borderButtonWidth,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: PaddingTheme.borderButton,
        child: Row(
          children: [
            Text(
              text,
              style: GoogleFonts.getFont(
                FontTheme.firaSans,
                color: color,
                fontSize: FontTheme.borderButtonSize,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (child != null)
              Padding(
                padding: PaddingTheme.borderButtonChild,
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}
