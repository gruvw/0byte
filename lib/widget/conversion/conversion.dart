import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widget/number_widget.dart';
import 'package:app_0byte/widget/utils/editable_field.dart';

class Conversion extends HookWidget {
  final EditableField<String, Number> numberTextField;
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
