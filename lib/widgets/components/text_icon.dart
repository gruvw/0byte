import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final Icon? leading;
  final Text text;
  final Icon? trailing;

  const TextIcon({
    super.key,
    required this.text,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (leading != null) leading!,
        text,
        if (trailing != null) trailing!,
      ],
    );
  }
}
