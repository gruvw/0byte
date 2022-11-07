import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/utils/input_parsing.dart';

class NumberWidget extends StatelessWidget {
  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily2,
    fontSize: FontTheme.fontSize2,
    fontWeight: FontWeight.w500,
    color: ColorTheme.text1,
  );

  static TextStyle styleFromInput(ConversionType type, String input) {
    String? number = parseInput(type, input);

    return _displayTitleStyle.apply(
      color: number == null ? ColorTheme.danger : null,
    );
  }

  final ConversionType type;
  final String input;

  final void Function(String newInput)? onSubmitted;

  const NumberWidget({
    super.key,
    required this.type,
    required this.input,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    String? number = parseInput(type, input);
    String text = number ?? input;

    void valueToClipboard() {
      FocusScope.of(context).unfocus();
      String copy = type.prefix + text;
      Clipboard.setData(ClipboardData(text: copy)).then(
        (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: "Copied "),
                TextSpan(
                  text: "$copy",
                  style: const TextStyle(
                    fontFamily: FontTheme.fontFamily2,
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

    return GestureDetector(
      onSecondaryLongPress: valueToClipboard,
      onLongPress: valueToClipboard,
      child: Row(
        children: [
          // Prefix
          Text(
            type.prefix,
            style: _displayTitleStyle.apply(
              color: ColorTheme.textPrefix,
            ),
          ),
          // Number
          if (onSubmitted != null)
            // Editable
            IntrinsicWidth(
              child: _NumberField(
                type: type,
                text: text,
                onSubmitted: onSubmitted!,
              ),
            )
          else
            // Non-editable
            Text(
              text,
              style: styleFromInput(type, input),
            ),
        ],
      ),
    );
  }
}

class _NumberField extends HookWidget {
  final ConversionType type;
  final String text;
  final void Function(String newInput) onSubmitted;

  const _NumberField({
    required this.type,
    required this.text,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: text);
    final style = useState(NumberWidget.styleFromInput(type, text));

    // Entry Input
    return TextField(
      autofocus: text.isEmpty,
      controller: controller,
      cursorColor: ColorTheme.text1,
      keyboardType: TextInputType.number,
      style: style.value,
      decoration: const InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      onSubmitted: (value) => onSubmitted(value),
      onChanged: (value) {
        style.value = NumberWidget.styleFromInput(type, controller.text);
      },
    );
  }
}
