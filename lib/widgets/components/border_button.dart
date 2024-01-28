import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/dimensions.dart';

class BorderButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
  final Widget? child;

  const BorderButton({
    super.key,
    required this.text,
    required this.color,
    this.textColor = UIColors.text1,
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
        padding: PaddingTheme.borderButton,
        side: BorderSide(
          color: color,
          width: DimensionsTheme.borderButtonWidth,
          style: BorderStyle.solid,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        children: [
          Text(text, style: UITexts.normal.apply(color: textColor)),
          if (child != null)
            Padding(
              padding: PaddingTheme.borderButtonChild,
              child: child,
            ),
        ],
      ),
    );
  }
}
