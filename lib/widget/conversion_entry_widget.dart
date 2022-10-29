import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/utils/input_parsing.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:tuple/tuple.dart';

class ConversionEntryWidget extends ConsumerWidget {
  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.fontFamily2,
    fontSize: FontTheme.fontSize2,
    color: ColorTheme.text1,
    fontWeight: FontWeight.w500,
  );

  final String input;
  final String? label;

  const ConversionEntryWidget({
    required this.input,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetType = ref.watch(targetConversionTypeProvider);
    final targetSize = ref.watch(targetSizeProvider);

    final Text? subtitle = label != null
        ? Text(
            label!,
            style: const TextStyle(
                fontFamily: FontTheme.fontFamily1, color: ColorTheme.text2),
          )
        : null;

    Tuple2<ConversionType, String>? parsedInput = parseInput(input);

    if (parsedInput == null) {
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

    ConversionType inputType = parsedInput.item1;
    String inputData = parsedInput.item2;

    String result = converted(
      data: inputData,
      targetSize: targetSize,
      inputType: inputType,
      targetType: targetType,
    );
    String resultData = parseInput(result)!.item2;
    String symmetric = converted(
      data: resultData,
      targetSize: splitSign(inputData).item2.length,
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
                if (symmetric !=
                    inputType.prefix + leftTrimmed(inputData, inputType))
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
