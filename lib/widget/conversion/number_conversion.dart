import 'package:flutter/material.dart';

import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widget/conversion/conversion.dart';
import 'package:app_0byte/widget/conversion/number_label.dart';
import 'package:app_0byte/widget/conversion_chip.dart';
import 'package:app_0byte/widget/number_widget.dart';

// TODO reactive NumberConversionEntry

class NumberConversion extends StatelessWidget {
  // TODO live conversion change using EditableField
  final Editable<Number> number;
  final ConversionTarget target;

  const NumberConversion({
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
            // LEFT HERE
            // TODO extract to NumberView
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberLabel(number: this.number),
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
        Conversion(number: number, target: target),
      ],
    );
  }
}
