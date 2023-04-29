import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';

final database = HiveDatabase();

final container = ProviderContainer();

final collectionEditionEventProvider =
    StreamProvider.autoDispose.family<Event<Collection>, Collection>(
  (ref, collection) async* {
    yield* database.watchCollections().where(
          (event) => event.type == EventType.edit && event.object == collection,
        );
  },
);

final collectionsProvider = Provider.autoDispose(
  (ref) {
    ref.watch(collectionsEventProvider);
    return database.getCollections();
  },
);
final collectionsEventProvider = StreamProvider.autoDispose<Event<Collection>>(
  (ref) async* {
    yield* database.watchCollections();
  },
);

final entryEditionEventProvider =
    StreamProvider.autoDispose.family<Event<NumberConversionEntry>, NumberConversionEntry>(
  (ref, entry) async* {
    yield* database
        .watchEntries()
        .where((event) => event.object == entry && event.type == EventType.edit);
  },
);

final selectedCollectionProvider = StateProvider.autoDispose<Collection>(
  (ref) {
    final collections = ref.read(collectionsProvider);

    return collections.isEmpty
        ? database.createCollection(label: "My Collection")
        : collections.first;
  },
);
