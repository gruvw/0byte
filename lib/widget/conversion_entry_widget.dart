import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final entry = ref.watch(entryProvider(this.entry));

    final targetType = ref.watch(targetConversionTypeProvider);
    final targetSize = ref.watch(targetSizeProvider);

    String? number = parseInput(entry.type, entry.input);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberWidget(
                  type: entry.type,
                  input: number ?? entry.input,
                ),
                TextField(
                  controller: TextEditingController(text: entry.label),
                  cursorColor: ColorTheme.text2,
                  style: const TextStyle(
                      fontFamily: FontTheme.fontFamily1,
                      color: ColorTheme.text2),
                  decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  ),
                  onSubmitted: (value) {
                    entry.label = value;
                  },
                ),
              ],
            ),
          ),
          if (number != null)
            _ConvertedWidget(
              number: number,
              inputType: entry.type,
              targetSize: targetSize,
              targetType: targetType,
            ),
        ],
      ),
    );
  }
}

class _ConvertedWidget extends StatelessWidget {
  final ConversionType inputType;
  final String number;
  final int targetSize;
  final ConversionType targetType;

  const _ConvertedWidget({
    required this.inputType,
    required this.number,
    required this.targetSize,
    required this.targetType,
  });

  @override
  Widget build(BuildContext context) {
    // FIXME Maybe dont call in build ?
    String result = converted(
      inputType: inputType,
      number: number,
      targetType: targetType,
      targetSize: targetSize,
    );
    bool symmetric = isSymmetric(
      inputType: inputType,
      number: number,
      targetType: targetType,
      result: result,
    );

    return IntrinsicWidth(
      child: Column(
        children: [
          NumberWidget(
            type: targetType,
            input: result,
          ),
          if (!symmetric)
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
