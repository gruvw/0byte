import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:flutter/material.dart';

// TODO color/grey out prefix
// TODO indicate overflow
// TODO copyable values

class ConversionEntryWidget extends StatelessWidget {
  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily2,
    fontSize: FontTheme.fontSize2,
    color: ColorTheme.text1,
    fontWeight: FontWeight.w500,
  );

  final String input;
  final ConversionType targetType;
  final String? label;

  const ConversionEntryWidget({
    required this.input,
    required this.targetType,
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

    // TODO add alphabet verification (hex in maj)
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

    String prefix = input.substring(0, 2);
    String data = input.substring(2);

    return ListTile(
      subtitle: subtitle,
      title: Text(
        input,
        style: _displayTitleStyle,
      ),
      trailing: Text(
        converted(
            data: data,
            targetSize: 100,
            inputType: typeFromPrefix[prefix]!,
            targetType: targetType),
        style: _displayTitleStyle,
      ),
    );
  }
}
