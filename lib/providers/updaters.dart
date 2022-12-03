import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/providers/update_riverpod.dart';

final collectionUpdater = Updater.family<Collection>(
  (ref, element) {
    ref.watch(collectionEventProvider(element));
  },
);

final entryUpdater = Updater.family<NumberEntry>((ref, element) {
  ref.watch(entryEventProvider(element));
});
