import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:flutter/material.dart';

class ConversionEntryWidget extends StatelessWidget {
  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily2,
    fontSize: FontTheme.fontSize2,
    color: ColorTheme.text1,
    fontWeight: FontWeight.w500,
  );

  final String input;
  final ConversionType targetType;
  final int targetSize;
  final String? label;

  const ConversionEntryWidget({
    required this.input,
    required this.targetType,
    required this.targetSize,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Text? subtitle = label != null
        ? Text(
            label!,
            style: const TextStyle(
                fontFamily: FontTheme.fontFamily1, color: ColorTheme.text2),
          )
        : null;

    // TODO validation in separate file

    if (input.length < 3 ||
        !typeFromPrefix.containsKey(input.substring(0, 2))) {
      return ListTile(
        subtitle: subtitle,
        title: Text(
          input,
          style: _displayTitleStyle.apply(
            color: ColorTheme.danger,
          ),
        ),
      );
    }

    String inputPrefix = input.substring(0, 2);
    ConversionType inputType = typeFromPrefix[inputPrefix]!;
    String inputVal = input.substring(2);

    String result = converted(
        data: inputVal,
        targetSize: targetSize,
        inputType: inputType,
        targetType: targetType);
    String symmetric = converted(
      data: result.substring(2),
      targetSize: inputVal.replaceFirst("-", "").length,
      inputType: targetType,
      targetType: inputType,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                input,
                style: _displayTitleStyle,
              ),
              if (subtitle != null) subtitle
            ],
          ),
          IntrinsicWidth(
            child: Column(
              children: [
                Text(
                  result,
                  style: _displayTitleStyle,
                ),
                if (symmetric != inputPrefix + leftTrimmed(inputVal, inputType))
                  const Divider(
                    color: ColorTheme.warning,
                    thickness: 4,
                    height: 6,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
