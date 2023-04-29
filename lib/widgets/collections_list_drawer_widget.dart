import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/time.dart';
import 'package:app_0byte/global/styles/values.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/state/providers/database_providers.dart';
import 'package:app_0byte/utils/import_export.dart';
import 'package:app_0byte/utils/validation.dart';

class CollectionsListDrawer extends HookConsumerWidget {
  static const drawerTextStyle = TextStyle(
    fontFamily: FontTheme.firaSans,
    fontSize: FontTheme.drawerSize,
    color: ColorTheme.text2,
  );

  const CollectionsListDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.read(collectionsProvider);
    final selectedCollection = ref.read(selectedCollectionProvider);

    void changeSelectedCollection(Collection collection) {
      ref.read(selectedCollectionProvider.notifier).state = collection;
      Navigator.pop(context);
    }

    return ListView.separated(
      padding: PaddingTheme.drawer,
      itemCount: collections.length + 3,
      separatorBuilder: (context, index) => const Divider(
        color: ColorTheme.text2,
      ),
      // One more for the "new collection" button, One more for the "import collection"
      itemBuilder: (context, index) {
        // "New Collection" button
        if (index == collections.length) {
          return ListTile(
            leading: const Icon(
              Icons.add,
              color: ColorTheme.text2,
            ),
            title: const Text(
              ValuesTheme.newCollectionButtonLabel,
              style: drawerTextStyle,
            ),
            onTap: () {
              changeSelectedCollection(
                database.createCollection(
                  label: uniqueLabel(
                    ref.read(collectionsProvider).map((c) => c.label).toList(),
                    ValuesTheme.defaultCollectionLabel,
                  ),
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
              ValuesTheme.importButtonLabel,
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
                    success ? "Successfully imported." : "An error occurred while importing.",
                  ),
                ),
              );
            },
          );
        }

        // "Export collections" button
        if (index == collections.length + 2) {
          return ListTile(
            leading: const Icon(
              Icons.file_upload,
              color: ColorTheme.text2,
            ),
            title: const Text(
              ValuesTheme.exportCollectionsButtonLabel,
              style: drawerTextStyle,
            ),
            onTap: () async {
              String? path = await exportCollections();
              if (path == null) {
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: TimeTheme.exportMessageDuration,
                action: SnackBarAction(
                  label: "Ok",
                  onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                ),
                content: Text("Exported collections: $path."),
              ));
            },
          );
        }

        final collection = collections[index];

        return ListTile(
          tileColor: collection == selectedCollection ? ColorTheme.background2 : Colors.transparent,
          title: Text(
            collection.label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: FontTheme.firaSans,
              fontSize: FontTheme.drawerSize,
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
                    final deletedSelected = selectedCollection == collection;
                    collection.delete();
                    if (deletedSelected) {
                      ref.read(selectedCollectionProvider.notifier).state =
                          database.getCollections().first;
                    }
                  },
                ),
          onTap: () => changeSelectedCollection(collection),
        );
      },
    );
  }
}
