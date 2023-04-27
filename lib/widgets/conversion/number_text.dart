import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/transforms.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/number_input_formatter.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class NumberTextView extends HookWidget {
  // TODO wrap number on new line (allign with prefix); maybe on sigle line (number, converted) when very small ?

  static const bool displaySeparator =
      true; // TODO use app/collection based setting

  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.firaCode,
    fontSize: FontTheme.numberSize,
    fontWeight: FontWeight.w500,
    color: ColorTheme.text1,
  );

  static TextStyle _styleFrom(Number number) {
    return _displayTitleStyle.apply(
      color: number.parsed() == null ? ColorTheme.danger : null,
    );
  }

  final PotentiallyMutable<Number> number;
  final PotentiallyMutableField<String, Number> textNumberField;

  NumberTextView({
    super.key,
    required this.number,
  }) : textNumberField = PotentiallyMutableField(
          applyNumberTextDisplay(number.object, displaySeparator),
          view: (text) => number.object.withText(text),
          isMutable: number.isMutable,
          onSubmitted: onSubmitNumber(number.object),
        );

  @override
  Widget build(BuildContext context) {
    final numberView = textNumberField.value;

    // Use hook only when text is modified (otherwise controller.text won't be updated on rebuild, must create new TextEditingController)
    final controller = textNumberField.isMutable
        ? useTextEditingController(text: numberView.text)
        : TextEditingController(text: numberView.text);

    final style = useState(_styleFrom(numberView));

    void valueToClipboard() {
      FocusScope.of(context).unfocus();
      String copy = number.object.display(displaySeparator);
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
            numberView.type.prefix,
            style: _displayTitleStyle.apply(color: ColorTheme.textPrefix),
          ),
          FocusSubmittedTextField(
            controller: controller,
            readOnly: !textNumberField.isMutable,
            autofocus: numberView.text.isEmpty && textNumberField.isMutable,
            inputFormatters: [
              NumberInputFormatter(
                type: numberView.type,
                displaySeparator: displaySeparator,
              )
            ],
            onChanged: (newText) {
              textNumberField.set(newText);
              style.value = _styleFrom(textNumberField.value);
            },
            onSubmitted: textNumberField.submit,
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
