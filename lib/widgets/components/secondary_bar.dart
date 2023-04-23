import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:flutter/material.dart';

class SecondaryBar extends StatelessWidget {
  final Widget? child;

  const SecondaryBar({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorTheme.background2,
      padding: const EdgeInsets.symmetric(
        vertical: PaddingTheme.titleVertical,
        horizontal: PaddingTheme.titleHorizontal,
      ),
      child: child,
    );
  }
}
