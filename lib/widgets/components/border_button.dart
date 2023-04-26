import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/fonts.dart';

// TODO 0 extract constants

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        side: BorderSide(
          color: color,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(
              text,
              style: GoogleFonts.getFont(
                FontTheme.firaSans,
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (child != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}
