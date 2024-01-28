import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
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

class EntryPage extends HookConsumerWidget {
  static Widget _barFromText(String text) => SecondaryBar(
        padding: PaddingTheme.targetSecondaryBars,
        child: Center(
          child: Text(
            text,
            style: UITexts.number,
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: UIColors.background3,
        leading: IconButton(
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(
            Icons.arrow_back,
            color: UIColors.text1,
          ),
          onPressed: onCancel,
        ),
        title: Text(
          entry.collection.label,
          style: UITexts.large,
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
                    style: UITexts.large,
                  ),
                ),
              ),
              Padding(
                padding: PaddingTheme.entry,
                child: NumberConversionEntryView(
                  entry: Mutable(entry),
                  chipEnabled: false,
                  label: NumberLabel.fromLabelField(titleLabelField),
                ),
              ),
              _barFromText(UIValues.inputTitle),
              ConversionTypesSelectors(
                selected: entry.type,
                onSelected: (selectedType) => entry.type = selectedType,
              ),
              _barFromText(UIValues.targetTitle),
              ConversionTypesSelectors(
                selected: entry.target.type,
                onSelected: (selectedType) =>
                    entry.target = selectedType.defaultTarget,
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
                  text: UIValues.cancelLabel,
                  color: UIColors.text2,
                  onPressed: onCancel,
                ),
                BorderButton(
                  text: UIValues.confirmLabel,
                  textColor: UIColors.accent,
                  color: UIColors.accent,
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
