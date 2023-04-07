import 'package:flutter/material.dart';

import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widget/conversion/conversion.dart';
import 'package:app_0byte/widget/conversion/number_label.dart';
import 'package:app_0byte/widget/conversion/number_text_view.dart';
import 'package:app_0byte/widget/conversion_chip.dart';

// TODO exctract magic numbers and clean constants
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
    final numberView = NumberTextView(initialNumber: number);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberLabel(number: number),
                if (number.object.label != null) const SizedBox(height: 2),
                numberView
              ],
            ),
            Column(
              children: [
                ConversionChip(
                  inputType: number.object.type,
                  outputType: target.type,
                  digits: target.digits,
                )
              ],
            ),
          ],
        ),
        Conversion(numberTextField: numberView.numberTextField, target: target),
      ],
    );
  }
}
