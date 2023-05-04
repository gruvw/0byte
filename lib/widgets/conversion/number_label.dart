import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/hooks/listener.dart';
import 'package:app_0byte/state/providers/entry.dart';
import 'package:app_0byte/utils/transforms.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class NumberLabel extends HookWidget {
  static final defaultStyle = GoogleFonts.getFont(
    FontTheme.firaSans,
    fontSize: FontTheme.numberLabelSize,
  ).apply(color: ColorTheme.text2);

  static PotentiallyMutableField<String> labelFieldFromNumber(
    PotentiallyMutable<NumberConversion> number,
  ) {
    final labelField = PotentiallyMutableField(
      number.object.label,
      isMutable: number.isMutable,
      onSubmitted: onSubmitNumberConversionLabel(number.object),
    );
    if (number is NumberConversionEntry) {
      labelField.subscribeTo(ListenableField.familyProvided(number, provider: entryLabelProvider));
    }
    return labelField;
  }

  final PotentiallyMutableField<String> labelField;
  final TextStyle style;

  NumberLabel({
    super.key,
    required PotentiallyMutable<NumberConversion> number,
    TextStyle? style,
  })  : style = style ?? defaultStyle,
        labelField = labelFieldFromNumber(number);

  NumberLabel.fromLabelField(
    this.labelField, {
    super.key,
    TextStyle? style,
  }) : style = style ?? defaultStyle;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: labelField.value);
    final focusNode = useFocusNode();

    useListener(labelField.notifier, (newLabel) {
      if (!focusNode.hasFocus) {
        controller.text = newLabel;
      }
    });

    return FocusSubmittedTextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: !labelField.isMutable,
      onSubmitted: labelField.submit,
      onChanged: labelField.set,
      cursorColor: ColorTheme.text2,
      style: style,
    );
  }
}
