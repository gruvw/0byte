import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/providers/entry.dart';
import 'package:app_0byte/state/updaters/database.dart';
import 'package:app_0byte/state/updaters/update_riverpod.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/border_button.dart';
import 'package:app_0byte/widgets/components/secondary_bar.dart';
import 'package:app_0byte/widgets/conversion/conversion_chip.dart';
import 'package:app_0byte/widgets/conversion/number_conversion_view.dart';
import 'package:app_0byte/widgets/conversion/number_label.dart';
import 'package:app_0byte/widgets/conversion/selectors/conversion_types_selectors.dart';
import 'package:app_0byte/widgets/conversion/selectors/digits_selector.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class EntryRoute extends HookConsumerWidget {
  static Widget _barFromText(String text) => SecondaryBar(
        padding: PaddingTheme.targetSecondaryBars,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: ColorTheme.text1,
              fontFamily: FontTheme.firaCode,
              fontSize: FontTheme.entryBarSize,
            ),
          ),
        ),
      );

  final NumberConversion initial;
  final NumberConversionEntry entry;
  final PotentiallyMutableField<String> titleLabelField;
  final bool deleteOnCancel;

  EntryRoute({
    super.key,
    required this.entry,
    this.deleteOnCancel = false,
  })  : initial = DartNumberConversion.clone(entry),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SecondaryBar(
                padding: PaddingTheme.targetSecondaryBars,
                child: Center(
                  child: NumberLabel.fromLabelField(
                    titleLabelField,
                    style: NumberLabel.defaultStyle.copyWith(
                      color: ColorTheme.text1,
                      fontSize: FontTheme.labelTitleSize,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: PaddingTheme.entryPagePreview,
                child: NumberConversionEntryView(
                  entry: Mutable(entry),
                  chipEnabled: false,
                  label: NumberLabel.fromLabelField(titleLabelField),
                ),
              ),
              _barFromText(ValuesTheme.inputTitle),
              ConversionTypesSelectors(
                selected: entry.type,
                onSelected: (selectedType) => entry.type = selectedType,
              ),
              _barFromText(ValuesTheme.targetTitle),
              ConversionTypesSelectors(
                selected: entry.target.type,
                onSelected: (selectedType) => entry.target = selectedType.defaultTarget,
              ),
              DigitsSelector(
                digitsField: ListenableField.familyProvided(
                  entry,
                  provider: entryDigitsProvider,
                ),
                onSelected: (selectedDigits) =>
                    entry.target = entry.target.withDigits(selectedDigits),
              ),
            ],
          ),
          Padding(
            padding: PaddingTheme.entryPageSubmit,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BorderButton(
                  text: ValuesTheme.cancelLabel,
                  color: ColorTheme.text2,
                  onPressed: onCancel,
                ),
                BorderButton(
                  text: ValuesTheme.confirmLabel,
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
