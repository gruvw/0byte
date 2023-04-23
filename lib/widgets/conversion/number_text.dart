import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/transforms.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/number_input_formatter.dart';
import 'package:app_0byte/widgets/utils/potentially_mutable_field.dart';

class NumberText extends HookWidget {
// TODO wrap number on new line (allign with prefix); maybe on sigle line (number, converted) when very small ?

  static const bool displaySeparator =
      true; // TODO use app/collection based setting

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
  final PotentiallyMutableField<String, Number> numberTextField;

  NumberText({
    required this.number,
    super.key,
  }) : numberTextField = PotentiallyMutableField(
          applyNumberText(number.object, displaySeparator),
          view: (text) => number.object.withText(text),
          isMutable: number.isMutable,
          onSubmitted: onSubmitNumber(number.object),
        );

  @override
  Widget build(BuildContext context) {
    final number = numberTextField.view();

    // Use hook only when text is modified (otherwise controller.text won't be updated on rebuild)
    final controller = numberTextField.isMutable
        ? useTextEditingController(text: number.text)
        : TextEditingController(text: number.text);

    final style = useState(styleFrom(number));

    void valueToClipboard() {
      final number = this.number.object;

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
              NumberInputFormatter(
                type: number.type,
                displaySeparator: displaySeparator,
              )
            ],
            onSubmitted: numberTextField.submit,
            onChanged: (value) {
              numberTextField.set(value);
              style.value = styleFrom(numberTextField.view());
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
