import 'package:app_0byte/global/styles/values.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/widgets/components/secondary_bar.dart';

class ConversionTitleWidget extends StatelessWidget {
  static const _titleStyle = TextStyle(
    fontSize: FontTheme.titleSize,
    fontFamily: FontTheme.firaCode,
  );

  const ConversionTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SecondaryBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(ValuesTheme.inputTitle, style: _titleStyle),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(ValuesTheme.conversionTitle, style: _titleStyle),
              ],
            )
          ],
        ),
      ),
    );
  }
}
