import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/providers/update_riverpod.dart';

final collectionsUpdater = Updater<List<Collection>>((ref) {
  ref.watch(collectionsProvider);
});

final collectionUpdater = FamilyUpdater.family<Collection>(
  (ref, element) {
    ref.watch(collectionEventProvider(element));
  },
);

final entryUpdater = FamilyUpdater.family<NumberEntry>((ref, element) {
  ref.watch(entryEventProvider(element));
});
