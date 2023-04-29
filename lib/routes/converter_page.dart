import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/time.dart';
import 'package:app_0byte/global/styles/values.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/routes/route_generator.dart';
import 'package:app_0byte/state/providers/application.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/state/updaters/database.dart';
import 'package:app_0byte/state/updaters/update_riverpod.dart';
import 'package:app_0byte/utils/import_export.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/collections_list_drawer_widget.dart';
import 'package:app_0byte/widgets/components/slidable_delete.dart';
import 'package:app_0byte/widgets/components/text_icon.dart';
import 'package:app_0byte/widgets/conversion/number_conversion_view.dart';
import 'package:app_0byte/widgets/conversion_title_widget.dart';
import 'package:app_0byte/widgets/forms/text_form.dart';

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
                    ValuesTheme.exportCollectionButtonLabel,
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
                      onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
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
                    ValuesTheme.copyCollectionButtonLabel,
                    style: menuTextStyle,
                  ),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(
                          // FIXME should display separator from settings
                          text: collection.display(true)))
                      .then((_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme.textPrefix,
        foregroundColor: ColorTheme.text1,
        onPressed: () {
          final nbEntries = collection.entries.length;
          final entry = database.createNumberConversionEntry(
            collection: collection,
            position: nbEntries,
            label: "${ValuesTheme.defaultNumberLabel} ${nbEntries + 1}",
            number: ValuesTheme.defaultNumber,
            target: ValuesTheme.defaultTarget,
          );
          Navigator.pushNamed(
            context,
            Routes.entry.name,
            arguments: [entry, true],
          );
        },
        child: const Icon(Icons.add),
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
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          entries[oldIndex].move(newIndex);
        },
        footer: const SizedBox(
          height: DimensionsTheme.converterPageEndScrollingSpacing,
        ),
        itemCount: entries.length,
        itemBuilder: (context, index) => _NumberEntry(
          key: ValueKey(index),
          index: index,
          entry: entries[index],
        ),
      ),
    );
  }
}

// TODO 1 split in other files ?
class _NumberEntry extends StatelessWidget {
  final int index;
  final NumberConversionEntry entry;

  const _NumberEntry({
    super.key,
    required this.entry,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableDelayedDragStartListener(
      index: index,
      child: Column(
        children: [
          SlidableDelete(
            groupTag: entry.collection,
            onDelete: (_) => entry.delete(),
            child: Padding(
              padding: PaddingTheme.entry,
              child: NumberConversionEntryView(entry: Mutable(entry)),
            ),
          ),
          const Divider(
            height: DimensionsTheme.entryDividerHeight,
            thickness: DimensionsTheme.entryDividerThickness,
            color: ColorTheme.background2,
          ),
        ],
      ),
    );
  }
}
