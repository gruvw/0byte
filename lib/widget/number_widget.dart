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

  const NumberWidget({
    super.key,
    required this.type,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    String? number = parseInput(type, input);

    if (number == null) {
      return Text(
        input,
        style: _displayTitleStyle.apply(
          color: ColorTheme.danger,
        ),
      );
    }

    return Row(
      children: [
        Text(
          type.prefix,
          style: _displayTitleStyle.apply(
            color: ColorTheme.textPrefix,
          ),
        ),
        Text(
          number,
          style: _displayTitleStyle,
        ),
      ],
    );
  }
}
