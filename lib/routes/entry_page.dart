import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/border_button.dart';
import 'package:app_0byte/widgets/components/secondary_bar.dart';
import 'package:app_0byte/widgets/conversion/conversion_chip.dart';
import 'package:app_0byte/widgets/conversion/number_conversion.dart';
import 'package:app_0byte/widgets/conversion/number_label.dart';

// TODO extract constants

class EntryPage extends ConsumerWidget {
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

  final NumberEntry entry;
  final bool deleteOnCancel;

  final DartNumber initialEntry;
  final ConversionTarget initialTarget;

  EntryPage({
    required this.entry,
    this.deleteOnCancel = false,
    super.key,
  })  : initialEntry =
            DartNumber(type: entry.type, text: entry.text, label: entry.label),
        initialTarget = entry.target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(entryEditionUpdater(entry));

    // Cross subscribed label fields (between title and preview)
    final entryPreviewLabelField =
        NumberLabel.labelFieldFromNumber(Mutable(entry));
    final mutableEntry = Mutable(entry);
    final entryLabelTitle = NumberLabel(
      number: mutableEntry,
      subscribedLabelField: entryPreviewLabelField,
      style: NumberLabel.defaultStyle.copyWith(
        color: ColorTheme.text1,
        fontSize: 24,
      ),
    );
    final entryPreviewLabel = NumberLabel.fromLabelField(
      labelField: entryPreviewLabelField,
      subscribedLabelField: entryLabelTitle.labelField,
    );

    void onCancel() {
      // FIXME set entry type and target
      // entry.type = initialEntry.type;
      entry.text = initialEntry.text;
      entry.label = initialEntry.label;
      // entry.target = initialTarget;

      if (deleteOnCancel) {
        entry.delete();
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
                    child: Center(child: entryLabelTitle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: PaddingTheme.entryHorizontal,
                  ),
                  child: EntryNumberConversion(
                    entry: Mutable(entry),
                    chipEnabled: false,
                    label: entryPreviewLabel,
                  ),
                ),
                _barFromText("Input"),
                // LEFT HERE 1
                _barFromText("Output"),
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
