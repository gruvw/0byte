import 'package:flutter/services.dart';

class ApplyTextFormatter extends TextInputFormatter {
  final String Function(String value) applyValue;

  ApplyTextFormatter(this.applyValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: applyValue(newValue.text),
      selection: newValue.selection,
    );
  }
}
