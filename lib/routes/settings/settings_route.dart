import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/state/providers/settings.dart';
import 'package:app_0byte/widgets/components/label_switch_button.dart';

class SettingsRoute extends StatelessWidget {
  static final _categoryStyle = GoogleFonts.getFont(
    FontTheme.firaSans,
    color: ColorTheme.text1,
    fontSize: FontTheme.settingsCategorySize,
  );

  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
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
                  ProvidedLabelSwitchButton(
                    displaySeparatorsProvider,
                    label: ValuesTheme.displaySeparatorSettingsLabel,
                  ),
                  ProvidedLabelSwitchButton(
                    displayConvertedLeadingZerosProvider,
                    label: ValuesTheme.displayConvertedLeadingZerosSettingsLabel,
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
                  ProvidedLabelSwitchButton(
                    exportSeparatorsProvider,
                    label: ValuesTheme.exportSeparatorsSettingsLabel,
                  ),
                  ProvidedLabelSwitchButton(
                    exportConvertedLeadingZerosProvider,
                    label: ValuesTheme.exportConvertedLeadingZerosSettingsLabel,
                  ),
                  ProvidedLabelSwitchButton(
                    exportASCIIControlProvider,
                    label: ValuesTheme.exportASCIIControlSettingsLabel,
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
