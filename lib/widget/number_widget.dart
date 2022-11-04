import 'package:flutter/material.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/utils/input_parsing.dart';

class NumberWidget extends StatelessWidget {
  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily2,
    fontSize: FontTheme.fontSize2,
    color: ColorTheme.text1,
    fontWeight: FontWeight.w500,
  );

  final ConversionType type;
  final String input;

  final void Function(String newInput)? onChanged;

  const NumberWidget({
    super.key,
    required this.type,
    required this.input,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String? number = parseInput(type, input);

    String text = number ?? input;
    TextStyle textStyle = _displayTitleStyle.apply(
      color: number == null ? ColorTheme.danger : null,
    );

    return Row(
      children: [
        Text(
          type.prefix,
          style: _displayTitleStyle.apply(
            color: ColorTheme.textPrefix,
          ),
        ),
        if (onChanged != null)
          IntrinsicWidth(
            child: TextField(
              controller: TextEditingController(text: text),
              cursorColor: ColorTheme.text1,
              keyboardType: TextInputType.number,
              style: textStyle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
              onSubmitted: (value) {
                onChanged!(value);
              },
            ),
          )
        else
          Text(
            text,
            style: textStyle,
          ),
      ],
    );
  }
}
