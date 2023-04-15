import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/conversion/number_text.dart';
import 'package:app_0byte/widgets/utils/potentially_mutable_field.dart';

class Conversion extends HookWidget {
  final PotentiallyMutableField<String, Number> numberTextField;
  final ConversionTarget target;

  const Conversion({
    required this.numberTextField,
    required this.target,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final number = useValueListenable(numberTextField.notifier);
    final converted = number.convertTo(target);
    print("${number.text} ${converted?.convertedNumber.text}");

    if (converted == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IntrinsicWidth(
          child: Column(
            children: [
              NumberText(
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
