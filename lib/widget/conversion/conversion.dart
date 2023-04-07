import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widget/number_widget.dart';

class Conversion extends StatelessWidget {
  final Number number;
  final ConversionTarget target;
  final Converted<Number>? converted;

  Conversion({
    required this.number,
    required this.target,
    super.key,
  }) : converted = number.convertTo(target);

  @override
  Widget build(BuildContext context) {
    final converted = this.converted;

    if (converted == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            NumberWidget(
              type: converted.convertedNumber.type,
              input: converted.convertedNumber.text,
            ),
            if (!converted.wasSymmetric)
              const Divider(
                color: ColorTheme.warning,
                thickness: DimensionsTheme.conversionUnderlineWarningThickness,
                height: DimensionsTheme.conversionUnderlineWarningHeight,
              ),
          ],
        ),
      ],
    );
  }
}
