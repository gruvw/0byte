import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/conversion/conversion.dart';
import 'package:app_0byte/widgets/conversion/conversion_chip.dart';
import 'package:app_0byte/widgets/conversion/number_label.dart';
import 'package:app_0byte/widgets/conversion/number_text.dart';

class NumberConversionEntryView extends HookConsumerWidget {
  final PotentiallyMutable<NumberConversionEntry> entry;
  final NumberLabel? label;
  final bool chipEnabled;

  const NumberConversionEntryView({
    required this.entry,
    this.chipEnabled = true,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = this.entry.object;
    ref.subscribe(entryEditionUpdater(entry));

    return NumberConversionView(
      key: UniqueKey(), // Fixes non-updating number value
      number: this.entry,
      label: label,
      onChipPressed: chipEnabled
          ? () {
              Navigator.of(context).pushNamed(
                "/entry",
                arguments: [entry],
              );
            }
          : null,
    );
  }
}

class NumberConversionView extends StatelessWidget {
  final PotentiallyMutable<NumberConversion> number;
  final VoidCallback? onChipPressed;
  final NumberLabel? label;

  const NumberConversionView({
    required this.number,
    this.label,
    this.onChipPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO go to triple row layout (move conversion chip on first row) when input close to overflow

    // PotentiallyMutableField holder (used for live conversion)
    final numberView = NumberText(number: number);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label ??
                    NumberLabel(
                      number: number,
                    ),
                const SizedBox(
                  height: DimensionsTheme.entryLabelNumberVerticalSpacing,
                ),
                numberView
              ],
            ),
            Column(
              children: [
                ConversionChip(
                  inputType: number.object.type,
                  target: number.object.target,
                  onPressed: onChipPressed,
                ),
              ],
            ),
          ],
        ),
        Conversion(
          numberTextField: numberView.numberTextField,
          target: number.object.target,
        ),
      ],
    );
  }
}