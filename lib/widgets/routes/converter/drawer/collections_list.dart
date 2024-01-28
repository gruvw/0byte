import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/time.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/state/providers/application.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/utils/import_export.dart';
import 'package:app_0byte/utils/validation.dart';

class CollectionsList extends HookConsumerWidget {
  const CollectionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    final selectedCollection = ref.watch(selectedCollectionProvider);

    void changeSelectedCollection(Collection collection) {
      ref.read(selectedCollectionProvider.notifier).state = collection;
      Navigator.pop(context);
    }

    return Expanded(
      child: ListView.separated(
        padding: PaddingTheme.drawer,
        itemCount: collections.length + 3,
        separatorBuilder: (context, index) => const Divider(
          color: UIColors.text2,
        ),
        // One more for the "new collection" button, One more for the "import collection"
        itemBuilder: (context, index) {
          // "New Collection" button
          if (index == collections.length) {
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.add,
                color: UIColors.text2,
              ),
              title: Text(
                UIValues.newCollectionButtonLabel,
                style: UITexts.sub,
              ),
              onTap: () {
                changeSelectedCollection(
                  database.createCollection(
                    label: uniqueLabel(
                      ref.read(collectionsProvider).map((c) => c.label),
                      DefaultValues.collectionLabel,
                      enclosingLeft: "(",
                      enclosingRight: ")",
                    ),
                  ),
                );
              },
            );
          }

          // "Import collection" button
          if (index == collections.length + 1) {
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.download,
                color: UIColors.text2,
              ),
              title: Text(
                UIValues.importButtonLabel,
                style: UITexts.sub,
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
                    backgroundColor: UIColors.background2,
                    content: Text(
                      success
                          ? "Successfully imported."
                          : "An error occurred while importing.",
                      style: UITexts.sub,
                    ),
                  ),
                );
              },
            );
          }

          // "Export collections" button
          if (index == collections.length + 2) {
            return ListTile(
              dense: true,
              leading: const Icon(
                Icons.file_upload,
                color: UIColors.text2,
              ),
              title: Text(
                UIValues.exportCollectionsButtonLabel,
                style: UITexts.sub,
              ),
              onTap: () async {
                String? path = await exportCollections();
                if (path == null) {
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: UIColors.background2,
                  duration: TimeTheme.exportMessageDuration,
                  action: SnackBarAction(
                    label: "Ok",
                    textColor: UIColors.accent,
                    onPressed: () =>
                        ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  ),
                  content: Text(
                    "Exported collections: $path.",
                    style: UITexts.normal,
                  ),
                ));
              },
            );
          }

          // Collection
          final collection = collections[index];

          return ListTile(
            dense: true,
            tileColor: collection == selectedCollection
                ? UIColors.background2
                : Colors.transparent,
            title: Text(
              collection.label,
              overflow: TextOverflow.ellipsis,
              style: UITexts.sub,
            ),
            trailing: collections.length <= 1
                ? const SizedBox()
                : IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(
                      Icons.delete,
                      color: UIColors.danger,
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
      ),
    );
  }
}
