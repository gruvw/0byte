import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/providers/database_updaters.dart';
import 'package:app_0byte/providers/entry_providers.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/border_button.dart';
import 'package:app_0byte/widgets/components/secondary_bar.dart';
import 'package:app_0byte/widgets/conversion/conversion_chip.dart';
import 'package:app_0byte/widgets/conversion/number_conversion_view.dart';
import 'package:app_0byte/widgets/conversion/number_label.dart';
import 'package:app_0byte/widgets/conversion/selectors/conversion_types_selectors.dart';
import 'package:app_0byte/widgets/conversion/selectors/digits_selector.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

// TODO 0 extract constants

class EntryPage extends HookConsumerWidget {
  static Widget _barFromText(String text) => SecondaryBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: ColorTheme.text1,
                fontFamily: FontTheme.firaCode,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );

  final NumberConversion initial;
  final NumberConversionEntry entry;
  final PotentiallyMutableField<String> titleLabelField;
  final bool deleteOnCancel;

  EntryPage({
    super.key,
    required this.entry,
    this.deleteOnCancel = false,
  })  : initial = DartNumberConversion.from(entry),
        titleLabelField = NumberLabel.labelFieldFromNumber(Mutable(entry));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(entryEditionUpdater(entry));

    void onCancel() {
      if (deleteOnCancel) {
        entry.delete();
      } else {
        entry.setAllLike(initial);
      }

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.background3,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorTheme.text1,
          ),
          onPressed: onCancel,
        ),
        title: Text(
          entry.collection.label,
          style: GoogleFonts.getFont(FontTheme.firaSans),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SecondaryBar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: NumberLabel.fromLabelField(
                        titleLabelField,
                        style: NumberLabel.defaultStyle.copyWith(
                          color: ColorTheme.text1,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: PaddingTheme.entryHorizontal,
                  ),
                  child: NumberConversionEntryView(
                    entry: Mutable(entry),
                    chipEnabled: false,
                    label: NumberLabel.fromLabelField(titleLabelField),
                  ),
                ),
                _barFromText("Input"),
                ConversionTypesSelectors(
                  selected: entry.type,
                  onSelected: (selectedType) => entry.type = selectedType,
                ),
                _barFromText("Target"),
                ConversionTypesSelectors(
                  selected: entry.target.type,
                  onSelected: (selectedType) =>
                      entry.target = selectedType.defaultTarget,
                ),
                DigitsSelector(
                  digitsField: ListenableField.provided(
                    entry,
                    provider: entryDigitsProvider,
                  ),
                  onSelected: (selectedDigits) =>
                      entry.target = entry.target.withDigits(selectedDigits),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BorderButton(
                  text: "Cancel",
                  color: ColorTheme.text2,
                  onPressed: onCancel,
                ),
                BorderButton(
                  text: "Confirm",
                  color: ColorTheme.accent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: ConversionChip(
                    inputType: entry.type,
                    target: entry.target,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
