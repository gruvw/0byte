import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/conversion/number_text.dart';
import 'package:app_0byte/widgets/utils/potentially_mutable_field.dart';

class TextFieldConversion extends HookWidget {
  final PotentiallyMutableField<String, Number> textNumberField;
  final ConversionTarget target;

  const TextFieldConversion({
    super.key,
    required this.textNumberField,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final number = useValueListenable(textNumberField.notifier);
    final converted = number.convertTo(target);

    if (converted == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IntrinsicWidth(
          child: Column(
            children: [
              NumberTextView(
                number: Immutable(converted.convertedNumber),
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
        ),
      ],
    );
  }
}
