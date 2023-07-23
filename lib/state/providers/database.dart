import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/settings.dart';

final database = HiveDatabase();

final container = ProviderContainer();

final collectionEditionEventProvider = StreamProvider.autoDispose.family<Event<Collection>, String>(
  (ref, collectionKey) async* {
    yield* database.watchCollections().where(
          (event) => event.type == EventType.edit && event.object.key == collectionKey,
        );
  },
);
final collectionProvider = Provider.autoDispose.family<Collection?, String>((ref, collectionKey) {
  ref.watch(collectionEditionEventProvider(collectionKey));
  return database.getCollection(collectionKey);
});
final collectionsEventProvider = StreamProvider.autoDispose<Event<Collection>>(
  (ref) async* {
    yield* database.watchCollections();
  },
);
final collectionsProvider = Provider.autoDispose<List<Collection>>(
  (ref) {
    ref.watch(collectionsEventProvider);
    return database.getCollections();
  },
);

final entryEditionEventProvider =
    StreamProvider.autoDispose.family<Event<NumberConversionEntry>, String>(
  (ref, entryKey) async* {
    yield* database
        .watchEntries()
        .where((event) => event.object.key == entryKey && event.type == EventType.edit);
  },
);
final entryProvider = Provider.autoDispose.family<NumberConversionEntry, String>((ref, entryKey) {
  ref.watch(entryEditionEventProvider(entryKey));
  return database.getEntry(entryKey)!;
});

final settingsEventProvider = StreamProvider.autoDispose<Event<ApplicationSettings>>(
  (ref) async* {
    yield* database.watchSettings().where((event) => event.type == EventType.edit);
  },
);
final settingsProvider = Provider.autoDispose<ApplicationSettings>(
  (ref) {
    ref.watch(settingsEventProvider);
    return database.getSettings();
  },
);
