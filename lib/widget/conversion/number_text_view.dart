import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widget/utils/apply_text_formatter.dart';
import 'package:app_0byte/widget/utils/potentially_mutable_field.dart';
import 'package:app_0byte/widget/utils/focus_submitted_text_field.dart';

class PotentiallyMutableNumberText extends HookWidget {
// TODO wrap number on new line (allign with prefix), maybe on sigle line (number, converted) when very small ?

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

  final PotentiallyMutable<Number> number;

  late final PotentiallyMutableField<String, Number> numberTextField =
      PotentiallyMutableField(
    number.object.text,
    getValue: (input) => number.object.withText(input),
    isMutable: number.isMutable,
    applyInput: applyInputFromType(number.object.type),
    onSubmitted: (newValue) {
      if (newValue.isEmpty) {
        newValue = number.object.text; // take previous value instead
      }
      number.object.text = newValue;
    },
  );

  PotentiallyMutableNumberText({
    required this.number,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final number = this.number.object;

    // Use hook only when text is modified (otherwise controller.text won't be updated on rebuild)
    final controller = numberTextField.isMutable
        ? useTextEditingController(text: numberTextField.getValue().text)
        : TextEditingController(text: number.text);

    final style = useState(styleFrom(number));

    void valueToClipboard() {
      FocusScope.of(context).unfocus();
      String copy = number.type.prefix + number.text;
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
            number.type.prefix,
            style: _displayTitleStyle.apply(color: ColorTheme.textPrefix),
          ),
          FocusSubmittedTextField(
            controller: controller,
            readOnly: !numberTextField.isMutable,
            autofocus: number.text.isEmpty && numberTextField.isMutable,
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
