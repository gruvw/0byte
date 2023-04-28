import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widgets/conversion/number_text.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class TextFieldNumberConversion extends HookWidget {
  final ListenableField<Number?> textNumberField;
  final ConversionTarget target;
  late final ListenableFieldTransform<Number?, ConvertedNumber?> convertedField;
  late final ListenableFieldTransform<ConvertedNumber?, Number?>
      convertedNumberField;

  TextFieldNumberConversion({
    super.key,
    required this.textNumberField,
    required this.target,
  }) {
    convertedField = ListenableFieldTransform(
      textNumberField,
      transform: (number) {
        return number?.convertTo(target);
      },
    );
    convertedNumberField = ListenableFieldTransform(
      convertedField,
      transform: (input) => input?.result,
    );
  }

  @override
  Widget build(BuildContext context) {
    final convertedNumber = useValueListenable(convertedField.notifier);
    final wasSymmetric = convertedNumber?.wasSymmetric;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IntrinsicWidth(
          child: Column(
            children: [
              NumberTextView.fromNumberField(
                numberField: convertedNumberField,
              ),
              if (wasSymmetric != null && !wasSymmetric)
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
