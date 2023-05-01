import 'package:app_0byte/routes/converter/drawer/footer.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/routes/converter/collection_entries.dart';
import 'package:app_0byte/routes/converter/collection_menu.dart';
import 'package:app_0byte/routes/converter/drawer/collections_list.dart';
import 'package:app_0byte/routes/converter/conversion_title.dart';
import 'package:app_0byte/routes/route_generator.dart';
import 'package:app_0byte/state/providers/application.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/state/updaters/database.dart';
import 'package:app_0byte/state/updaters/update_riverpod.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/forms/text_form.dart';

class ConverterPage extends HookConsumerWidget {
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
          CollectionMenu(collection: collection),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: ColorTheme.background1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CollectionsList(),
              DrawerFooter(),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const ConversionTitleWidget(),
          Expanded(
            child: CollectionEntries(collection: collection),
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
            label: uniqueLabel(
              collection.entries.map((c) => c.label),
              ValuesTheme.defaultNumberLabel,
            ),
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
