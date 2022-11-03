import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

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

  final String number;

  const NumberWidget(this.number);

  @override
  Widget build(BuildContext context) {
    Tuple2<ConversionType, String>? parsedNumber = parseInput(number);

    if (parsedNumber == null) {
      return Text(
        number,
        style: _displayTitleStyle.apply(
          color: ColorTheme.danger,
        ),
      );
    }

    ConversionType numberType = parsedNumber.item1;
    String numberData = parsedNumber.item2;

    return Row(
      children: [
        Text(
          numberType.prefix,
          style: _displayTitleStyle.apply(
            color: ColorTheme.textPrefix,
          ),
        ),
        Text(
          numberData,
          style: _displayTitleStyle,
        ),
      ],
    );
  }
}
