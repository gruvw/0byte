import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/settings.dart';

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
    StreamProvider.autoDispose.family<Event<NumberConversionEntry>, NumberConversionEntry>(
  (ref, entry) async* {
    yield* database
        .watchEntries()
        .where((event) => event.object == entry && event.type == EventType.edit);
  },
);

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
