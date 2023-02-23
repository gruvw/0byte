import 'dart:async';

import 'package:app_0byte/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/utils/import_export.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/settings.dart';

class CollectionsListDrawer extends HookConsumerWidget {
  static const drawerTextStyle = TextStyle(
    fontFamily: FontTheme.fontFamily1,
    fontSize: FontTheme.fontSize4,
    color: ColorTheme.text2,
  );

  const CollectionsListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.subscribe(collectionsUpdater);

    final collections = database.getCollections();
    final selectedCollection = ref.read(selectedCollectionProvider);

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
              style: drawerTextStyle,
            ),
            onTap: () {
              changeSelectedCollection(
                database.createCollection(
                  label: uniqueLabel(SettingsTheme.defaultCollectionLabel),
                  targetType: SettingsTheme.defaultTargetType,
                  targetSize: SettingsTheme.defaultTargetType.defaultTargetSize,
                ),
              );
            },
          );
        }

        // "Import collection" button
        if (index == collections.length + 1) {
          return ListTile(
            leading: const Icon(
              Icons.download,
              color: ColorTheme.text2,
            ),
            title: const Text(
              SettingsTheme.importButtonLabel,
              style: drawerTextStyle,
            ),
            onTap: () async {
              bool? success = await import();
              if (success == null) {
                return;
              }
              // FIXME pop to show snackbar message but still on previous collection (bad ux, either show newly imported collection or message in front of drawer)
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? "Successfully imported."
                        : "An error occurred while importing.",
                  ),
                ),
              );
            },
          );
        }

        final collection = collections[index];

        return ListTile(
          tileColor: collection == selectedCollection
              ? ColorTheme.background2
              : Colors.transparent,
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
                    // Workaround, fixes #3
                    Future.delayed(const Duration(seconds: 0), () {
                      collection.delete();
                    });
                    if (selectedCollection == collection) {
                      ref.read(selectedCollectionProvider.notifier).state =
                          database.getCollections().first;
                    }
                  },
                ),
          onTap: () => changeSelectedCollection(collection),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: ColorTheme.text2,
      ),
      // One more for the "new collection" button, One more for the "import collection"
      itemCount: collections.length + 2,
    );
  }
}
