import 'package:flutter/services.dart';

import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/input_transforms.dart';

class NumberInputFormatter extends TextInputFormatter {
  final ConversionType type;
  final bool displaySeparator;

  NumberInputFormatter({
    required this.type,
    required this.displaySeparator,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newBase = applyNumberPositionedText(
      PositionedText(oldValue.text, oldValue.selection.baseOffset),
      PositionedText(newValue.text, newValue.selection.baseOffset),
      type,
      displaySeparator,
    );
    final newExtend = applyNumberPositionedText(
      PositionedText(oldValue.text, oldValue.selection.extentOffset),
      PositionedText(newValue.text, newValue.selection.extentOffset),
      type,
      displaySeparator,
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
