import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/state/providers/database.dart';

final selectedCollectionProvider = StateProvider.autoDispose<Collection>(
  (ref) {
    final collections = ref.read(collectionsProvider);

    return collections.isEmpty
        ? database.createCollection(label: ValuesTheme.defaultCollectionLabel)
        : collections.first;
  },
);
