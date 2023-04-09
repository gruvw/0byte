import 'package:flutter/services.dart';

import 'package:app_0byte/utils/validation.dart';

class ApplyTextFormatter extends TextInputFormatter {
  final String Function(String value)? applyValue;

  ApplyTextFormatter(this.applyValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newBase = applyPositionedText(
      PositionedText(oldValue.text, oldValue.selection.baseOffset),
      PositionedText(newValue.text, newValue.selection.baseOffset),
      applyValue,
    );
    final newExtend = applyPositionedText(
      PositionedText(oldValue.text, oldValue.selection.extentOffset),
      PositionedText(newValue.text, newValue.selection.extentOffset),
      applyValue,
    );

    return TextEditingValue(
      text: newBase.text,
      selection: TextSelection(
        baseOffset: newBase.position,
        extentOffset: newExtend.position,
      ),
    );
  }
}
