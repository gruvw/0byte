import 'package:app_0byte/global/styles/texts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/widgets/components/secondary_bar.dart';

class ConversionTitleWidget extends StatelessWidget {
  const ConversionTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SecondaryBar(
      padding: PaddingTheme.conversionTitle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            UIValues.inputTitle,
            style: UITexts.number,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                UIValues.conversionTitle,
                style: UITexts.number,
              ),
            ],
          )
        ],
      ),
    );
  }
}
