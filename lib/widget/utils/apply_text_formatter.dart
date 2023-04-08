import 'package:flutter/services.dart';

class ApplyTextFormatter extends TextInputFormatter {
  final String Function(String value)? applyValue;

  ApplyTextFormatter(this.applyValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String updatedText = applyValue?.call(newValue.text) ?? newValue.text;
    int sizeDiff = updatedText.length - newValue.text.length;
    print(sizeDiff);
    if (newValue.selection.baseOffset + sizeDiff < 0) {
      sizeDiff = 0;
    }
    // LEFT HERE 1 find a way to make it work smoothly
    return TextEditingValue(
      text: updatedText,
      selection: TextSelection(
        baseOffset: newValue.selection.baseOffset + sizeDiff,
        extentOffset: newValue.selection.extentOffset + sizeDiff,
      ),
    );
  }
}
