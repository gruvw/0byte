import 'dart:io';

import 'package:app_0byte/utils/import_export.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/widget/utils/text_icon.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/widget/collections_list_drawer_widget.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/widget/forms/text_form.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/widget/conversion_entry_widget.dart';
import 'package:app_0byte/widget/utils/slidable_delete.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';

class ConverterPage extends HookConsumerWidget {
  static const menuTextStyle = TextStyle(
    fontFamily: FontTheme.fontFamily1,
    fontSize: FontTheme.fontSize5,
    color: ColorTheme.text1,
  );

  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(selectedCollectionProvider);
    ref.subscribe(collectionEditionUpdater(collection));

    return Scaffold(
      backgroundColor: ColorTheme.background1,
      appBar: AppBar(
        backgroundColor: ColorTheme.background3,
        title: Text(
          collection.label,
          style: GoogleFonts.getFont(FontTheme.fontFamily1),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: ColorTheme.text1,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => TextForm(
                title: "Collection title",
                initialText: collection.label,
                callback: (newTitle) => collection.label = newTitle,
              ),
            ),
          ),
          PopupMenuButton(
            color: ColorTheme.background3,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const TextIcon(
                  leading: Icon(
                    Icons.file_upload,
                    color: ColorTheme.text1,
                  ),
                  text: Text(
                    SettingsTheme.exportCollectionButtonLabel,
                    style: menuTextStyle,
                  ),
                ),
                onTap: () async {
                  File? file = await exportCollection(collection);
                  if (file == null) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 10),
                    action: SnackBarAction(
                      label: "Ok",
                      onPressed: () =>
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    ),
                    content: Text("Exported collection to ${file.path}."),
                  ));
                },
              ),
              PopupMenuItem(
                child: const TextIcon(
                  leading: Icon(
                    Icons.content_copy,
                    color: ColorTheme.text1,
                  ),
                  text: Text(
                    SettingsTheme.copyCollectionButtonLabel,
                    style: menuTextStyle,
                  ),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: collection.toString()))
                      .then(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: "Copied "),
                              TextSpan(
                                text: collection.label,
                                style: const TextStyle(
                                  color: ColorTheme.textPrefix,
                                ),
                              ),
                              const TextSpan(text: " to clipboard."),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
      drawer: const SafeArea(
        child: Drawer(
          backgroundColor: ColorTheme.background1,
          child: CollectionsListDrawer(),
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
                fontFamily: FontTheme.fontFamily2,
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

class _NumberEntries extends StatelessWidget {
  final Collection collection;

  const _NumberEntries({required this.collection});

  @override
  Widget build(BuildContext context) {
    final entries = collection.sortedEntries;

    return Theme(
      data: ThemeData(canvasColor: ColorTheme.background2),
      child: ReorderableListView(
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
      ),
    );
  }
}
