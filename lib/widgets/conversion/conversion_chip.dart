import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/utils/conversion.dart';

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

class EntryConversionChip extends HookConsumerWidget {
  final String entryKey;

  const EntryConversionChip({
    super.key,
    required this.entryKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(entryProvider(entryKey));

    return ConversionChip(
      inputType: entry.type,
      target: entry.target,
    );
  }
}
