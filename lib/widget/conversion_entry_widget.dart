import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/widget/utils/focus_submitted_text_field.dart';
import 'package:app_0byte/widget/number_widget.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/utils/input_parsing.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/utils/conversion.dart';

class ConversionEntryWidget extends HookConsumerWidget {
  final NumberEntry entry;

  const ConversionEntryWidget({
    required this.entry,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(entryEventProvider(entry));

    String? number = parseInput(entry.type, entry.input);
    final textNotifier = useValueNotifier(number ?? entry.input);

    final targetType = ref.watch(targetConversionTypeProvider);
    final targetSize = ref.watch(targetSizeProvider);

    String applyInput(String input) {
      if (entry.type == ConversionType.hexadecimal) {
        return input.toUpperCase();
      }
      return input;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entry number
              NumberWidget(
                type: entry.type,
                input: textNotifier.value,
                applyInput: applyInput,
                onChanged: (newInput) =>
                    textNotifier.value = applyInput(newInput),
                onSubmitted: (newInput) {
                  if (newInput.isEmpty) {
                    return entry.delete();
                  }
                  entry.input = applyInput(newInput);
                },
              ),
              // Entry Label
              FocusSubmittedTextField(
                controller: TextEditingController(text: entry.label),
                onSubmitted: (String newLabel) {
                  if (newLabel.isEmpty) {
                    final position = entry.collection.entries.indexOf(entry);
                    newLabel = "Value ${position + 1}";
                  }
                  entry.label = newLabel;
                },
                cursorColor: ColorTheme.text2,
                style: const TextStyle(
                  fontFamily: FontTheme.fontFamily1,
                  color: ColorTheme.text2,
                ),
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                ),
              ),
            ],
          ),
          // Result
          _ConvertedWidget(
            textNotifier: textNotifier,
            inputType: entry.type,
            targetSize: targetSize,
            targetType: targetType,
          ),
        ],
      ),
    );
  }
}

class _ConvertedWidget extends HookWidget {
  final ConversionType inputType;
  final ValueNotifier<String> textNotifier;
  final int targetSize;
  final ConversionType targetType;

  const _ConvertedWidget({
    required this.inputType,
    required this.textNotifier,
    required this.targetSize,
    required this.targetType,
  });

  @override
  Widget build(BuildContext context) {
    final text = useValueListenable(textNotifier);

    String? number = parseInput(inputType, text);

    if (number == null) return Column();

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
