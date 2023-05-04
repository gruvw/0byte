import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';

class LabelSwitchButton extends StatelessWidget {
  final bool enabled;
  final String? label;

  final void Function(bool newEnabled)? onChanged;

  const LabelSwitchButton({
    super.key,
    required this.enabled,
    this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Row(
      children: [
        Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: ColorTheme.accent,
          inactiveTrackColor: ColorTheme.background3,
        ),
        if (label != null)
          Text(
            label,
            style: GoogleFonts.getFont(
              FontTheme.firaSans,
              color: ColorTheme.text1,
              fontSize: FontTheme.switchLabelSize,
            ),
          ),
      ],
    );
  }
}

class ProvidedLabelSwitchButton extends ConsumerWidget {
  final StateProvider<bool> provider;
  final String? label;

  const ProvidedLabelSwitchButton(
    this.provider, {
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(provider);

    return LabelSwitchButton(
      enabled: enabled,
      label: label,
      onChanged: (newEnabled) => ref.read(provider.notifier).state = newEnabled,
    );
  }
}
