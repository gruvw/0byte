import 'package:app_0byte/utils/validation.dart';
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
  final Editable<Number> number;
  final ConversionTarget target;

  const ConversionWidget({
    required this.number,
    required this.target,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO go to tripple row layout (move conversion chip on first row) when input close to overflow
    final number = this.number.object;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ConversionLabel(number: this.number),
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
        _ConvertedNumberWidget(number: number, target: target),
      ],
    );
  }
}

class _ConversionLabel extends StatelessWidget {
  final Editable<Number> number;

  const _ConversionLabel({required this.number});

  @override
  Widget build(BuildContext context) {
    final label = number.object.label;

    if (label == null) {
      return const SizedBox();
    }

    return Text(
      label,
      style: GoogleFonts.getFont(
        FontTheme.firaSans,
        fontSize: FontTheme.numberLabelSize,
      ).apply(color: ColorTheme.text2),
    );
  }
}

class _ConvertedNumberWidget extends StatelessWidget {
  final Number number;
  final ConversionTarget target;
  final Converted<Number>? converted;

  _ConvertedNumberWidget({
    required this.number,
    required this.target,
  }) : converted = number.convertTo(target);

  @override
  Widget build(BuildContext context) {
    final converted = this.converted; // null detection

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
