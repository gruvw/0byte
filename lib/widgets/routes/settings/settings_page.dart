import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/widgets/components/label_switch_button.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColors.background3,
        title: Text(
          UIValues.settingsTitle,
          style: UITexts.large,
        ),
      ),
      body: Padding(
        padding: PaddingTheme.settings,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                UIValues.settingsUITitle,
                style: UITexts.normal,
              ),
              Padding(
                padding: PaddingTheme.settingsCategoryIndentation,
                child: Column(
                  children: [
                    LabelSwitchButton(
                      enabled: settings.displaySeparators,
                      label: SettingsValues.displaySeparatorLabel,
                      onChanged: (newEnabled) =>
                          settings.displaySeparators = newEnabled,
                    ),
                    LabelSwitchButton(
                      enabled: settings.displayTrimConvertedLeadingZeros,
                      label:
                          SettingsValues.displayTrimConvertedLeadingZerosLabel,
                      onChanged: (newEnabled) => settings
                          .displayTrimConvertedLeadingZeros = newEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DimensionsTheme.settingsCategorySpacing),
              Text(
                UIValues.settingsExportTitle,
                style: UITexts.normal,
              ),
              Padding(
                padding: PaddingTheme.settingsCategoryIndentation,
                child: Column(
                  children: [
                    LabelSwitchButton(
                      enabled: settings.exportSeparators,
                      label: SettingsValues.exportSeparatorsLabel,
                      onChanged: (newEnabled) =>
                          settings.exportSeparators = newEnabled,
                    ),
                    LabelSwitchButton(
                      enabled: settings.exportTrimConvertedLeadingZeros,
                      label:
                          SettingsValues.exportTrimConvertedLeadingZerosLabel,
                      onChanged: (newEnabled) =>
                          settings.exportTrimConvertedLeadingZeros = newEnabled,
                    ),
                    LabelSwitchButton(
                      enabled: settings.exportUseASCIIControl,
                      label: SettingsValues.exportUseASCIIControlLabel,
                      onChanged: (newEnabled) =>
                          settings.exportUseASCIIControl = newEnabled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
