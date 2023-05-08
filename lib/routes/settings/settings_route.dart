import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/widgets/components/label_switch_button.dart';

// TODO fix text overflow on narrow screens

class SettingsRoute extends ConsumerWidget {
  static final _categoryStyle = GoogleFonts.getFont(
    FontTheme.firaSans,
    color: ColorTheme.text1,
    fontSize: FontTheme.settingsCategorySize,
  );

  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.background3,
        title: Text(
          ValuesTheme.settingsTitle,
          style: GoogleFonts.getFont(FontTheme.firaSans),
        ),
      ),
      body: Padding(
        padding: PaddingTheme.settings,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ValuesTheme.settingsUITitle,
              style: _categoryStyle,
            ),
            Padding(
              padding: PaddingTheme.settingsCategoryIndentation,
              child: Column(
                children: [
                  LabelSwitchButton(
                    enabled: settings.displaySeparators,
                    label: ValuesTheme.displaySeparatorSettingsLabel,
                    onChanged: (newEnabled) => settings.displaySeparators = newEnabled,
                  ),
                  LabelSwitchButton(
                    enabled: settings.displayTrimConvertedLeadingZeros,
                    label: ValuesTheme.displayTrimConvertedLeadingZerosSettingsLabel,
                    onChanged: (newEnabled) =>
                        settings.displayTrimConvertedLeadingZeros = newEnabled,
                  ),
                ],
              ),
            ),
            const SizedBox(height: DimensionsTheme.settingsCategorySpacing),
            Text(
              ValuesTheme.settingsExportTitle,
              style: _categoryStyle,
            ),
            Padding(
              padding: PaddingTheme.settingsCategoryIndentation,
              child: Column(
                children: [
                  LabelSwitchButton(
                    enabled: settings.exportSeparators,
                    label: ValuesTheme.exportSeparatorsSettingsLabel,
                    onChanged: (newEnabled) => settings.exportSeparators = newEnabled,
                  ),
                  LabelSwitchButton(
                    enabled: settings.exportTrimConvertedLeadingZeros,
                    label: ValuesTheme.exportTrimConvertedLeadingZerosSettingsLabel,
                    onChanged: (newEnabled) =>
                        settings.exportTrimConvertedLeadingZeros = newEnabled,
                  ),
                  LabelSwitchButton(
                    enabled: settings.exportUseASCIIControl,
                    label: ValuesTheme.exportUseASCIIControlSettingsLabel,
                    onChanged: (newEnabled) => settings.exportUseASCIIControl = newEnabled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
