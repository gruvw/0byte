import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/transforms.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

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

  final PotentiallyMutable<NumberConversion>? number;
  final StringField labelField;
  final StringField? subscribedLabelField;
  final TextStyle style;

  NumberLabel({
    super.key,
    required PotentiallyMutable<NumberConversion> this.number,
    this.subscribedLabelField,
    TextStyle? style,
  })  : style = style ?? defaultStyle,
        labelField = labelFieldFromNumber(number);

  NumberLabel.fromLabelField({
    super.key,
    required this.labelField,
    this.subscribedLabelField,
    TextStyle? style,
  })  : style = style ?? defaultStyle,
        number = null;

  @override
  Widget build(BuildContext context) {
    final subscribedLabelField = this.subscribedLabelField;
    final number = this.number;

    final value = subscribedLabelField == null
        ? labelField.value
        : useValueListenable(subscribedLabelField.notifier);

    final controller = useTextEditingController(text: value);

    if (number != null && number.object is NumberConversionEntry) {}

    return FocusSubmittedTextField(
      // Must not use hook to rebuild on change
      controller: controller,
      readOnly: !labelField.isMutable,
      onSubmitted: labelField.submit,
      onChanged: labelField.set,
      cursorColor: ColorTheme.text2,
      style: style,
    );
  }
}
