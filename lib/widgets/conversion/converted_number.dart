import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/providers/settings.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widgets/conversion/number_text.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class ConvertedNumberView extends HookConsumerWidget {
  final ListenableField<Number?> numberField;
  final ConversionTarget target;
  late final ListenableFieldTransform<Number?, ConvertedNumber?> convertedField;
  late final ListenableFieldTransform<ConvertedNumber?, Number?> resultField;

  ConvertedNumberView({
    super.key,
    required this.numberField,
    required this.target,
  }) {
    convertedField = ListenableFieldTransform(
      numberField,
      transform: (number) => number?.convertTo(target),
    );
    resultField = ListenableFieldTransform(
      convertedField,
      transform: (input) => input?.result,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final convertedNumber = useValueListenable(convertedField.notifier);
    final wasSymmetric = convertedNumber?.wasSymmetric;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IntrinsicWidth(
          child: Column(
            children: [
              NumberTextView.fromNumberField(
                numberField: resultField,
                displaySettings: ListenableField.provided(displayConvertedSettingsProvider),
              ),
              if (wasSymmetric != null && !wasSymmetric)
                const Divider(
                  color: ColorTheme.warning,
                  thickness: DimensionsTheme.conversionUnderlineWarningThickness,
                  height: DimensionsTheme.conversionUnderlineWarningHeight,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
