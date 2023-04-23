import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/transforms.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/potentially_mutable_field.dart';

typedef StringField = PotentiallyMutableField<String, String>;

class NumberLabel extends HookWidget {
  static final defaultStyle = GoogleFonts.getFont(
    FontTheme.firaSans,
    fontSize: FontTheme.numberLabelSize,
  ).apply(color: ColorTheme.text2);

  static StringField labelFieldFromNumber(
    PotentiallyMutable<NumberConversion> number,
  ) {
    return PotentiallyMutableField(
      number.object.label,
      view: (value) => value,
      isMutable: number.isMutable,
      onSubmitted: onSubmitNumberLabel(number.object),
    );
  }

  final StringField labelField;
  final StringField? subscribedLabelField;
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
    final subscribedLabelField = this.subscribedLabelField;

    final value = subscribedLabelField == null
        ? labelField.view()
        : useValueListenable(subscribedLabelField.notifier);

    return FocusSubmittedTextField(
      controller: TextEditingController(text: value),
      readOnly: !labelField.isMutable,
      onSubmitted: labelField.submit,
      onChanged: labelField.set,
      cursorColor: ColorTheme.text2,
      style: style,
    );
  }
}
