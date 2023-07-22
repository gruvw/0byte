import 'package:app_0byte/models/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/state/providers/database.dart';

final selectedCollectionKeyProvider = StateProvider.autoDispose<String>(
  (ref) {
    final collections = ref.read(collectionsProvider);
    final selectedCollection = collections.isEmpty
        ? database.createCollection(label: ValuesTheme.defaultCollectionLabel)
        : collections.first;

    return selectedCollection.key;
  },
);
final selectedCollectionProvider = Provider.autoDispose<Collection>((ref) {
  final selectedCollectionKey = ref.watch(selectedCollectionKeyProvider);
  return ref.watch(collectionProvider(selectedCollectionKey))!;
});
