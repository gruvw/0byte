import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/routes/route_generator.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/state/updaters/database.dart';
import 'package:app_0byte/state/updaters/update_riverpod.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/conversion/conversion_chip.dart';
import 'package:app_0byte/widgets/conversion/converted_number.dart';
import 'package:app_0byte/widgets/conversion/number_label.dart';
import 'package:app_0byte/widgets/conversion/number_text.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class NumberConversionView extends StatelessWidget {
  final PotentiallyMutable<NumberConversion> number;
  final VoidCallback? onChipPressed;
  final NumberLabel? label;

  const NumberConversionView({
    super.key,
    required this.number,
    this.label,
    this.onChipPressed,
  });

  @override
  Widget build(BuildContext context) {
    // ListenableField<Number?> holder (used for live conversion)
    final numberView = NumberTextView(
      number: number,
      settings: ListenableField.provided(settingsProvider),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label ?? NumberLabel(number: number),
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
        ConvertedNumberView(
          numberField: numberView.numberField,
          target: number.object.target,
        ),
      ],
    );
  }
}

class NumberConversionEntryView extends ConsumerWidget {
  final PotentiallyMutable<NumberConversionEntry> entry;
  final NumberLabel? label;
  final bool chipEnabled;

  const NumberConversionEntryView({
    super.key,
    required this.entry,
    this.chipEnabled = true,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(entryEditionUpdater(entry.object));

    return NumberConversionView(
      number: entry,
      label: label,
      onChipPressed: chipEnabled
          ? () {
              Navigator.of(context).pushNamed(
                Routes.entry.name,
                arguments: [entry.object],
              );
            }
          : null,
    );
  }
}
