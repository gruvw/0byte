import 'package:app_0byte/global/styles/colors.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/dimensions.dart';

class SecondaryBar extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget? child;

  const SecondaryBar({
    super.key,
    this.padding = EdgeInsets.zero,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UIColors.background2,
      padding: PaddingTheme.secondaryBar.add(padding),
      child: child,
    );
  }
}
