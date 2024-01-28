import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/updaters/database.dart';
import 'package:app_0byte/state/updaters/update_riverpod.dart';
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
        side: const BorderSide(color: UIColors.accent),
        backgroundColor: UIColors.accent,
        foregroundColor: UIColors.accent,
        disabledBackgroundColor: UIColors.accent,
        disabledForegroundColor: UIColors.accent,
        padding: PaddingTheme.conversionChip,
        shape: DimensionsTheme.conversionChipBorder,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        "${inputType.prefix} -> ${target.type.prefix} ${target.digits.amount}",
        style: UITexts.numberNormal.copyWith(
          fontWeight: FontWeight.bold,
          color: UIColors.background3,
        ),
      ),
    );
  }
}

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
