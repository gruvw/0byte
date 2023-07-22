import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/widgets/routes/converter/collection_entries.dart';
import 'package:app_0byte/widgets/routes/converter/collection_menu.dart';
import 'package:app_0byte/widgets/routes/converter/conversion_title.dart';
import 'package:app_0byte/widgets/routes/converter/drawer/collections_list.dart';
import 'package:app_0byte/widgets/routes/converter/drawer/footer.dart';
import 'package:app_0byte/widgets/routes/route_generator.dart';
import 'package:app_0byte/state/providers/application.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/forms/text_form.dart';

class ConverterRoute extends HookConsumerWidget {
  const ConverterRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCollection = ref.watch(selectedCollectionProvider);

    return Scaffold(
      backgroundColor: ColorTheme.background1,
      appBar: AppBar(
        backgroundColor: ColorTheme.background3,
        title: Text(
          selectedCollection.label,
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
                initialText: selectedCollection.label,
                callback: (newTitle) => selectedCollection.label = newTitle,
              ),
            ),
          ),
          CollectionMenu(collection: selectedCollection),
        ],
      ),
      drawer: const SafeArea(
        child: Drawer(
          backgroundColor: ColorTheme.background1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            child: CollectionEntries(collection: selectedCollection),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme.textPrefix,
        foregroundColor: ColorTheme.text1,
        onPressed: () {
          final nbEntries = selectedCollection.entries.length;
          final entry = database.createNumberConversionEntry(
            collection: selectedCollection,
            position: nbEntries,
            label: uniqueLabel(
              selectedCollection.entries.map((c) => c.label),
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
