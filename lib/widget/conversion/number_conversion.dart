import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  final NumberEntry entry;

  const EntryNumberConversion({
    required this.entry,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(entryEditionUpdater(entry));

    // FIXME target from entry
    return NumberConversion(
      number: entry.toPotentiallyMutable(true),
      target: ConversionTarget(
        type: entry.collection.targetType,
        digits: Digits.fromInt(entry.collection.targetSize)!,
      ),
    );
  }
}

class NumberConversion extends StatelessWidget {
  final PotentiallyMutable<Number> number;
  final ConversionTarget target;

  const NumberConversion({
    required this.number,
    required this.target,
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
                ConversionChip(inputType: number.object.type, target: target),
              ],
            ),
          ],
        ),
        Conversion(numberTextField: numberView.numberTextField, target: target),
      ],
    );
  }
}
