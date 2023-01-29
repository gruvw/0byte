import 'package:flutter/services.dart';

class ApplyTextFormatter extends TextInputFormatter {
  final String Function(String value) applyValue;

  ApplyTextFormatter(this.applyValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String updatedText = applyValue(newValue.text);
    int sizeDiff = newValue.text.length - updatedText.length;
    return TextEditingValue(
      text: updatedText,
      selection: TextSelection(
        baseOffset: newValue.selection.baseOffset - sizeDiff,
        extentOffset: newValue.selection.extentOffset - sizeDiff,
      ),
    );
  }
}
