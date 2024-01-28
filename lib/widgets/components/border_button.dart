import 'package:app_0byte/global/styles/texts.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/dimensions.dart';

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
            Text(text, style: UITexts.normal),
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
