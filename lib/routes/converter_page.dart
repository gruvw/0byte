import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/widget/conversion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/global/styles/time.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/utils/import_export.dart';
import 'package:app_0byte/widget/collections_list_drawer_widget.dart';
import 'package:app_0byte/widget/conversion_entry_widget.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';
import 'package:app_0byte/widget/forms/text_form.dart';
import 'package:app_0byte/widget/utils/slidable_delete.dart';
import 'package:app_0byte/widget/utils/text_icon.dart';

import '../widget/conversion_chip.dart';

class ConverterPage extends HookConsumerWidget {
  static const menuTextStyle = TextStyle(
    fontFamily: FontTheme.firaSans,
    fontSize: FontTheme.menuSize,
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
          style: GoogleFonts.getFont(FontTheme.firaSans),
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
                  String? path = await exportCollection(collection);
                  if (path == null) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: TimeTheme.exportMessageDuration,
                    action: SnackBarAction(
                      label: "Ok",
                      onPressed: () =>
                          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    ),
                    content: Text("Exported collection: $path."),
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
                      .then((_) =>
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                          )));
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
          DimensionsTheme.floatingActionChildrenSize,
          DimensionsTheme.floatingActionChildrenSize,
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
                fontFamily: FontTheme.firaCode,
              ),
              label: conversionType.label,
              child: Text(
                conversionType.prefix,
                style: const TextStyle(
                  color: ColorTheme.textPrefix,
                  fontFamily: FontTheme.firaCode,
                  fontWeight: FontWeight.w600,
                  fontSize: FontTheme.addEntryPrefixSize,
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
          // FIXME remove
          Center(
            key: UniqueKey(),
            child: ConversionChip(
              inputType: ConversionType.binary,
              outputType: ConversionType.hexadecimal,
              digits: Digits.fromInt(8)!,
            ),
          ),
          Center(
            key: UniqueKey(),
            child: ConversionWidget(
              number: Number.fromInput(
                type: ConversionType.binary,
                input: "0100100100011100101",
              )!,
              label: "My very cool label",
              target: ConversionTarget(
                type: ConversionType.hexadecimal,
                digits: Digits.fromInt(4)!,
              ),
            ),
          )
        ],
      ),
    );
  }
}
