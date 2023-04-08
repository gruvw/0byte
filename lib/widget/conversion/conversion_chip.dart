import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/utils/conversion.dart';

class EntryConversionChip extends HookConsumerWidget {
  final NumberEntry entry;

  const EntryConversionChip({
    required this.entry,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(entryEditionUpdater(entry));

    return ConversionChip(
      inputType: entry.type,
      target: entry.target,
    );
  }
}

class ConversionChip extends StatelessWidget {
  final ConversionType inputType;
  final ConversionTarget target;

  final VoidCallback? onPressed;

  const ConversionChip({
    required this.inputType,
    required this.target,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorTheme.accent),
          foregroundColor: MaterialStateProperty.all(ColorTheme.background3),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: PaddingTheme.conversionChipHorizontal,
          )),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(DimensionsTheme.conversionChipRadius),
              ),
            ),
          ),
        ),
        child: Text(
          "${inputType.prefix} -> ${target.type.prefix} ${target.digits.amount}",
          style: const TextStyle(
            fontFamily: FontTheme.firaCode,
            fontWeight: FontWeight.bold,
            fontSize: FontTheme.numberLabelSize,
          ),
        ));
  }
}
