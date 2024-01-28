import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/widgets/routes/converter/collection_entries.dart';
import 'package:app_0byte/widgets/routes/converter/collection_menu.dart';
import 'package:app_0byte/widgets/routes/converter/conversion_title.dart';
import 'package:app_0byte/widgets/routes/converter/drawer/collections_list.dart';
import 'package:app_0byte/widgets/routes/converter/drawer/footer.dart';
import 'package:app_0byte/widgets/routes/route_generator.dart';
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
      backgroundColor: UIColors.background1,
      appBar: AppBar(
        backgroundColor: UIColors.background3,
        title: Text(
          collection.label,
          style: UITexts.large,
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(
              Icons.edit,
              color: UIColors.text1,
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
      drawer: const SafeArea(
        child: Drawer(
          backgroundColor: UIColors.background1,
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
            child: CollectionEntries(collection: collection),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UIColors.textPrefix,
        foregroundColor: UIColors.text1,
        onPressed: () {
          final nbEntries = collection.entries.length;
          final entry = database.createNumberConversionEntry(
            collection: collection,
            position: nbEntries,
            label: uniqueLabel(
              collection.entries.map((c) => c.label),
              DefaultValues.numberLabel,
            ),
            number: DefaultValues.number,
            target: DefaultValues.target,
          );
          Navigator.pushNamed(
            context,
            Routes.entry.name,
            arguments: [entry, true],
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
