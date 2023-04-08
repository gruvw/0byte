import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widget/conversion/conversion_chip.dart';
import 'package:app_0byte/widget/utils/border_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO extract constants

class EntryPage extends ConsumerWidget {
  final NumberEntry entry;
  final bool deleteOnCancel;

  late final DartNumber initialEntry =
      DartNumber(type: entry.type, text: entry.text, label: entry.label);
  late final ConversionTarget initialTarget = entry.target;

  EntryPage({
    required this.entry,
    this.deleteOnCancel = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(entryEditionUpdater(entry));

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
            child: Column(), // LEFT HERE
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
