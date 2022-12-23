import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/styles/settings.dart';

class CollectionsList extends HookConsumerWidget {
  const CollectionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(collectionsUpdater);

    final collections = database.getCollections();

    void changeSelectedCollection(Collection collection) {
      ref.read(selectedCollectionProvider.notifier).state = collection;
      Navigator.pop(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      itemBuilder: (context, index) {
        // "New Collection" button
        if (index == collections.length) {
          return ListTile(
            leading: const Icon(
              Icons.add,
              color: ColorTheme.text2,
            ),
            title: const Text(
              SettingsTheme.newCollectionButtonLabel,
              style: TextStyle(
                fontFamily: FontTheme.fontFamily1,
                fontSize: FontTheme.fontSize4,
                color: ColorTheme.text2,
              ),
            ),
            onTap: () {
              changeSelectedCollection(
                database.createCollection(
                  label:
                      "${SettingsTheme.defaultCollectionLabel} ${collections.length + 1}",
                  targetType: SettingsTheme.defaultTargetType,
                  targetSize: SettingsTheme.defaultTargetType.defaultTargetSize,
                ),
              );
            },
          );
        }

        final collection = collections[index];

        return ListTile(
          title: Text(
            collection.label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: FontTheme.fontFamily1,
              fontSize: FontTheme.fontSize4,
              color: ColorTheme.text1,
            ),
          ),
          trailing: collections.length <= 1
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: ColorTheme.danger,
                  ),
                  onPressed: () {
                    if (ref.read(selectedCollectionProvider) == collection) {
                      ref.read(selectedCollectionProvider.notifier).state =
                          collections.firstWhere((c) => c != collection);
                    }
                    collection.delete();
                  },
                ),
          onTap: () => changeSelectedCollection(collection),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: ColorTheme.text2,
      ),
      // One more for the "new collection" button
      itemCount: collections.length + 1,
    );
  }
}
