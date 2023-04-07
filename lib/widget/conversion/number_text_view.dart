import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widget/utils/apply_text_formatter.dart';
import 'package:app_0byte/widget/utils/editable_field.dart';
import 'package:app_0byte/widget/utils/focus_submitted_text_field.dart';

class NumberTextView extends HookWidget {
// TODO wrap number on new line (allign with prefix)

  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.firaCode,
    fontSize: FontTheme.numberSize,
    fontWeight: FontWeight.w500,
    color: ColorTheme.text1,
  );

  static TextStyle styleFrom(Number number) {
    return _displayTitleStyle.apply(
      color: number.parsed() == null ? ColorTheme.danger : null,
    );
  }

  final Editable<Number> initialNumber;

  late final EditableField<String, Number> numberTextField = EditableField(
    initialNumber.object.text,
    getValue: (input) => initialNumber.object.withText(input),
    isEditable: initialNumber.isEditable,
    applyInput: applyInputFromType(initialNumber.object.type),
    onSubmitted: (newValue) {
      if (newValue.isEmpty) {
        newValue = initialNumber.object.text; // take previous value instead
      }
      initialNumber.object.text = newValue;
    },
  );

  NumberTextView({
    required this.initialNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final initialNumber = this.initialNumber.object;

    // Use hook only when text is modified (otherwise controller.text won't be updated on rebuild)
    final controller = numberTextField.isEditable
        ? useTextEditingController(text: numberTextField.getValue().text)
        : TextEditingController(text: initialNumber.text);

    final style = useState(styleFrom(initialNumber));

    void valueToClipboard() {
      FocusScope.of(context).unfocus();
      String copy = initialNumber.type.prefix + initialNumber.text;
      Clipboard.setData(ClipboardData(text: copy)).then(
        (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: "Copied "),
                TextSpan(
                  text: copy,
                  style: const TextStyle(
                    fontFamily: FontTheme.firaCode,
                    color: ColorTheme.accent,
                  ),
                ),
                const TextSpan(text: " to clipboard."),
              ],
            ),
          ),
        )),
      );
    }

    // BUG long press temporarily focuses TextField
    return GestureDetector(
      onSecondaryTap: valueToClipboard,
      onLongPress: valueToClipboard,
      child: Row(
        children: [
          // Prefix
          Text(
            initialNumber.type.prefix,
            style: _displayTitleStyle.apply(color: ColorTheme.textPrefix),
          ),
          FocusSubmittedTextField(
            controller: controller,
            readOnly: !numberTextField.isEditable,
            autofocus: initialNumber.text.isEmpty && numberTextField.isEditable,
            inputFormatters: [
              ApplyTextFormatter(numberTextField.applyInput ?? (v) => v)
            ],
            onSubmitted: numberTextField.onSubmitted,
            onChanged: (value) {
              numberTextField.onChanged(value);
              style.value = styleFrom(numberTextField.getValue());
            },
            cursorColor: ColorTheme.text1,
            style: style.value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
