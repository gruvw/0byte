import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final database = FlutterDatabase();

final container = ProviderContainer();
final targetConversionTypeProvider =
    StateProvider((ref) => ConversionType.hexadecimal);
final targetSizeProvider =
    StateProvider((ref) => ConversionType.hexadecimal.defaultTargetSize);

final entriesProvider = Provider<List<NumberEntry>>(
  (ref) {
    ref.watch(_entryEventStreamProvider);
    return database.getEntries();
  },
);
final _entryEventStreamProvider = StreamProvider<EntryEvent>(
  (ref) async* {
    yield* database.watchEntries();
  },
);
