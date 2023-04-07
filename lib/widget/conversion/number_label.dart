import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widget/utils/potentially_mutable_field.dart';
import 'package:app_0byte/widget/utils/focus_submitted_text_field.dart';

class NumberLabel extends StatelessWidget {
  late final PotentiallyMutableField<String, String>? labelField;

  NumberLabel({required PotentiallyMutable<Number> number, super.key}) {
    final numberLabel = number.object.label;

    if (numberLabel != null) {
      labelField = PotentiallyMutableField(
        numberLabel,
        getValue: (value) => value,
        isMutable: number.isMutable,
        onSubmitted: (newValue) {
          if (newValue.isEmpty) {
            newValue = SettingsTheme.defaultValueLabel;
          }
          number.object.label = newValue;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelField = this.labelField;

    if (labelField == null) {
      return const SizedBox();
    }

    return FocusSubmittedTextField(
      controller: TextEditingController(text: labelField.getValue()),
      readOnly: !labelField.isMutable,
      onSubmitted: labelField.onSubmitted,
      onChanged: labelField.onChanged,
      cursorColor: ColorTheme.text2,
      style: GoogleFonts.getFont(
        FontTheme.firaSans,
        fontSize: FontTheme.numberLabelSize,
      ).apply(color: ColorTheme.text2),
    );
  }
}
