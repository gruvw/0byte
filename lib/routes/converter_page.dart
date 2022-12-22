import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/widget/collections_list_widget.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/widget/forms/text_form.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/styles/settings.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/widget/conversion_entry_widget.dart';
import 'package:app_0byte/widget/utils/slidable_delete.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';

class ConverterPage extends HookConsumerWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(selectedCollectionProvider);

    return Scaffold(
      backgroundColor: ColorTheme.background1,
      appBar: AppBar(
        backgroundColor: ColorTheme.background3,
        title: HookConsumer(
          builder: (context, ref, child) {
            ref.subscribe(collectionUpdater(collection));
            return Text(
              collection.label,
              style: GoogleFonts.getFont(FontTheme.fontFamily1),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => TextForm(
                title: "Collection title",
                initialText: collection.label,
                callback: (newTitle) => collection.label = newTitle,
              ),
            ),
            icon: const Icon(
              Icons.edit,
              color: ColorTheme.text1,
            ),
          ),
        ],
      ),
      drawer: const SafeArea(
        child: Drawer(
          backgroundColor: ColorTheme.background1,
          child: CollectionsList(),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const ConversionTitleWidget(),
          Expanded(
            child: _NumberEntries(
              collection: collection,
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: ColorTheme.textPrefix,
        icon: Icons.add,
        activeIcon: Icons.close,
        foregroundColor: ColorTheme.text1,
        useRotationAnimation: false,
        renderOverlay: false,
        childrenButtonSize: const Size(
          SettingsTheme.floatingActionChildrenSize,
          SettingsTheme.floatingActionChildrenSize,
        ),
        spacing: 8,
        children: [
          for (final conversionType in ConversionType.values)
            SpeedDialChild(
              backgroundColor: ColorTheme.background2,
              labelBackgroundColor: ColorTheme.background2,
              labelShadow: [],
              labelStyle: const TextStyle(
                color: ColorTheme.text1,
              ),
              label: conversionType.label,
              child: Text(
                conversionType.prefix,
                style: const TextStyle(
                  color: ColorTheme.textPrefix,
                  fontFamily: FontTheme.fontFamily2,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                final nbEntries = collection.entries.length;

                database.createNumberEntry(
                  collection: collection,
                  position: nbEntries,
                  type: conversionType,
                  input: "",
                  label: "Value ${nbEntries + 1}",
                );
              },
            ),
        ],
      ),
    );
  }
}

class _NumberEntries extends ConsumerWidget {
  final Collection collection;

  const _NumberEntries({required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(collectionUpdater(collection));
    final entries = collection.sortedEntries;

    return ReorderableListView(
      dragStartBehavior: DragStartBehavior.down,
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        entries[oldIndex].move(newIndex);
      },
      children: [
        for (final entry in entries)
          ReorderableDelayedDragStartListener(
            key: UniqueKey(),
            index: entry.position,
            child: SlidableDelete(
              onDelete: (_) => entry.delete(),
              child: ConversionEntryWidget(entry: entry),
            ),
          ),
      ],
    );
  }
}
