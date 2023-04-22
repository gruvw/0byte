import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/potentially_mutable_field.dart';

typedef LabelField = PotentiallyMutableField<String, String>;

class NumberLabel extends HookWidget {
  static final defaultStyle = GoogleFonts.getFont(
    FontTheme.firaSans,
    fontSize: FontTheme.numberLabelSize,
  ).apply(color: ColorTheme.text2);

  static LabelField labelFieldFromNumber(
    PotentiallyMutable<NumberConversion> number,
  ) {
    final numberLabel = number.object.label;

    return PotentiallyMutableField(
      numberLabel,
      getValue: (value) => value,
      isMutable: number.isMutable,
      onSubmitted: (newValue) {
        if (newValue.isEmpty) {
          newValue = SettingsTheme.defaultNumberLabel;
        }
        number.object.label = newValue;
      },
    );
  }

  final LabelField? labelField;
  final LabelField? subscribedLabelField;
  final TextStyle style;

  NumberLabel({
    required PotentiallyMutable<NumberConversion> number,
    this.subscribedLabelField,
    TextStyle? style,
    super.key,
  })  : style = style ?? defaultStyle,
        labelField = labelFieldFromNumber(number);

  NumberLabel.fromLabelField({
    required this.labelField,
    this.subscribedLabelField,
    TextStyle? style,
    super.key,
  }) : style = style ?? defaultStyle;

  @override
  Widget build(BuildContext context) {
    final labelField = this.labelField;
    final subscribedLabelField = this.subscribedLabelField;

    if (labelField == null) {
      return const SizedBox();
    }

    final value = subscribedLabelField == null
        ? labelField.getValue()
        : useValueListenable(subscribedLabelField.notifier);

    return FocusSubmittedTextField(
      controller: TextEditingController(text: value),
      readOnly: !labelField.isMutable,
      onSubmitted: labelField.onSubmitted,
      onChanged: labelField.onChanged,
      cursorColor: ColorTheme.text2,
      style: style,
    );
  }
}
