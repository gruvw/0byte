import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'package:app_0byte/widget/number_widget.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/utils/input_parsing.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/utils/conversion.dart';

class ConversionEntryWidget extends HookConsumerWidget {
  final UserEntry entry;

  const ConversionEntryWidget({
    required this.entry,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetType = ref.watch(targetConversionTypeProvider);
    final targetSize = ref.watch(targetSizeProvider);

    final entry = ref.watch(entryProvider(this.entry));

    final Widget subtitle = TextField(
      controller: TextEditingController(text: entry.label),
      cursorColor: ColorTheme.text2,
      style: const TextStyle(
          fontFamily: FontTheme.fontFamily1, color: ColorTheme.text2),
      decoration: const InputDecoration(
        counterText: "",
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(0, 2, 0, 0),
      ),
      onSubmitted: (value) {
        entry.label = value;
      },
    );

    Tuple2<ConversionType, String>? parsedInput = parseInput(entry.input);

    if (parsedInput == null) {
      return ListTile(
        title: NumberWidget(entry.input),
        subtitle: subtitle,
      );
    }

    ConversionType inputType = parsedInput.item1;
    String inputData = parsedInput.item2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberWidget(inputType.prefix + inputData),
                subtitle,
              ],
            ),
          ),
          _ConvertedWidget(
            inputData: inputData,
            inputType: inputType,
            targetSize: targetSize,
            targetType: targetType,
          ),
        ],
      ),
    );
  }
}

class _ConvertedWidget extends StatelessWidget {
  final String inputData;
  final ConversionType inputType;
  final int targetSize;
  final ConversionType targetType;

  const _ConvertedWidget({
    required this.inputData,
    required this.inputType,
    required this.targetSize,
    required this.targetType,
  });

  @override
  Widget build(BuildContext context) {
    // FIXME Maybe dont call in build ?
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

    return IntrinsicWidth(
      child: Column(
        children: [
          NumberWidget(result),
          if (symmetric != inputType.prefix + leftTrimmed(inputData, inputType))
            const Divider(
              color: ColorTheme.warning,
              thickness: 4,
              height: 6,
            ),
        ],
      ),
    );
  }
}
