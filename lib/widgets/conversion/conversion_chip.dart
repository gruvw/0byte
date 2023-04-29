import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/providers/update_riverpod.dart';
import 'package:app_0byte/state/providers/database_updaters.dart';
import 'package:app_0byte/utils/conversion.dart';

class EntryConversionChip extends HookConsumerWidget {
  final NumberConversionEntry entry;

  const EntryConversionChip({
    super.key,
    required this.entry,
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
    super.key,
    required this.inputType,
    required this.target,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: ColorTheme.accent,
        foregroundColor: ColorTheme.background3,
        disabledBackgroundColor: ColorTheme.accent,
        disabledForegroundColor: ColorTheme.background3,
        padding: PaddingTheme.conversionChip,
        shape: DimensionsTheme.conversionChipBorder,
      ),
      child: Text(
        "${inputType.prefix} -> ${target.type.prefix} ${target.digits.amount}",
        style: const TextStyle(
          fontFamily: FontTheme.firaCode,
          fontWeight: FontWeight.bold,
          fontSize: FontTheme.numberLabelSize,
        ),
      ),
    );
  }
}
