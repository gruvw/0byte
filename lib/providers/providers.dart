import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/styles/settings.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
// import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/number_entry.dart';

final database = HiveDatabase();

final container = ProviderContainer();

final collectionEventProvider =
    StreamProvider.family<CollectionEvent, Collection>(
  (ref, collection) async* {
    yield* database
        .watchCollections()
        .where((event) => event.collection == collection);
  },
);

final collectionsProvider = Provider(
  (ref) {
    ref.watch(collectionsEventProvider);
    return database.getCollections();
  },
);
final collectionsEventProvider = StreamProvider<CollectionEvent>(
  (ref) async* {
    yield* database.watchCollections();
  },
);

final entryEventProvider = StreamProvider.family<EntryEvent, NumberEntry>(
  (ref, entry) async* {
    yield* database.watchEntries().where((event) => event.entry == entry);
  },
);

final selectedCollectionProvider = StateProvider<Collection>(
  (ref) {
    final collections = ref.read(collectionsProvider);

    if (collections.isEmpty) {
      return database.createCollection(
        label: "My Collection",
        targetType: SettingsTheme.defaultTargetType,
        targetSize: SettingsTheme.defaultTargetType.defaultTargetSize,
      );
    }

    return collections.first;
  },
);
