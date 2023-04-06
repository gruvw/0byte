import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widget/conversion_chip.dart';
import 'package:app_0byte/widget/number_widget.dart';

class ConversionWidget extends StatelessWidget {
  final Number number;
  final String label;
  final ConversionTarget target;
  final ConvertedNumber converted;

  ConversionWidget({
    required this.number,
    required this.label,
    required this.target,
    super.key,
  }) : converted = number.convertTo(target);

  @override
  Widget build(BuildContext context) {
    // TODO go to tripple row layout (move conversion chip on first row) when input close to overflow
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                ConversionLabel(label: label),
                NumberWidget(type: number.type, input: number.text),
              ],
            ),
            Column(
              children: [
                ConversionChip(
                  inputType: number.type,
                  outputType: target.type,
                  digits: target.digits,
                )
              ],
            ),
          ],
        ),
        Row(
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
                    thickness:
                        DimensionsTheme.conversionUnderlineWarningThickness,
                    height: DimensionsTheme.conversionUnderlineWarningHeight,
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ConversionLabel extends StatelessWidget {
  final String label;

  const ConversionLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
