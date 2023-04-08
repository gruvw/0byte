import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widget/conversion/conversion.dart';
import 'package:app_0byte/widget/conversion/conversion_chip.dart';
import 'package:app_0byte/widget/conversion/number_label.dart';
import 'package:app_0byte/widget/conversion/number_text_view.dart';

class EntryNumberConversion extends HookConsumerWidget {
  final PotentiallyMutable<NumberEntry> entry;
  final bool chipEnabled;

  const EntryNumberConversion({
    required this.entry,
    this.chipEnabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = this.entry.object;
    ref.subscribe(entryEditionUpdater(entry));

    return NumberConversion(
      key: UniqueKey(), // Fixes non-updating number value
      number: this.entry,
      target: entry.target,
      onChipPressed: () {
        if (!chipEnabled) {
          return;
        }

        Navigator.of(context).pushNamed(
          "/entry",
          arguments: entry,
        );
      },
    );
  }
}

class NumberConversion extends StatelessWidget {
  final PotentiallyMutable<Number> number;
  final ConversionTarget target;
  final VoidCallback? onChipPressed;

  const NumberConversion({
    required this.number,
    required this.target,
    this.onChipPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO go to tripple row layout (move conversion chip on first row) when input close to overflow

    // PotentiallyMutableField holder
    final numberView = PotentiallyMutableNumberText(number: number);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberLabel(number: number),
                if (number.object.label != null)
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
                  target: target,
                  onPressed: onChipPressed,
                ),
              ],
            ),
          ],
        ),
        Conversion(
          numberTextField: numberView.numberTextField,
          target: target,
        ),
      ],
    );
  }
}
