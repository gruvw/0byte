import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/number_entry.dart';

final database = FlutterDatabase();

final container = ProviderContainer();
final targetConversionTypeProvider =
    StateProvider((ref) => ConversionType.hexadecimal);
final targetSizeProvider =
    StateProvider((ref) => ConversionType.hexadecimal.defaultTargetSize);

final entriesProvider = Provider<List<UserEntry>>(
  (ref) {
    ref.watch(_entriesEventStreamProvider);
    return database.getEntries();
  },
);
final _entriesEventStreamProvider = StreamProvider<EntryEvent>(
  (ref) async* {
    yield* database.watchEntries();
  },
);

final entryProvider = Provider.family<UserEntry, UserEntry>((ref, entry) {
  ref.watch(_entryEventStreamProvider(entry));
  return entry;
});
final _entryEventStreamProvider = StreamProvider.family<EntryEvent, UserEntry>(
  (ref, entry) async* {
    yield* database.watchEntries().where((event) => event.entry == entry);
  },
);
