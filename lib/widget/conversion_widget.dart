import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widget/conversion_chip.dart';
import 'package:app_0byte/widget/number_widget.dart';

class ConversionWidget extends StatelessWidget {
  final Number number;
  final String label;
  final ConversionTarget target;
  final Converted<Number> converted;
  final bool editable;

  ConversionWidget({
    required this.number,
    required this.label,
    required this.target,
    this.editable = true,
    super.key,
  }) : converted = number.convertTo(target);

  @override
  Widget build(BuildContext context) {
    // TODO go to tripple row layout (move conversion chip on first row) when input close to overflow
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConversionLabel(label: label),
                const SizedBox(height: 2),
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
    return Text(
      label,
      style: GoogleFonts.getFont(
        FontTheme.firaSans,
        fontSize: FontTheme.numberLabelSize,
      ).apply(color: ColorTheme.text2),
    );
  }
}
