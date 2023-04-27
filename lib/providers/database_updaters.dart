import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/providers/database_providers.dart';
import 'package:app_0byte/providers/update_riverpod.dart';

final collectionsUpdater = Updater<List<Collection>>((ref) {
  ref.watch(collectionsProvider);
});

final collectionEditionUpdater = FamilyUpdater.family<Collection>(
  (ref, element) {
    ref.watch(collectionEditionEventProvider(element));
  },
);

final entryEditionUpdater =
    FamilyUpdater.family<NumberConversionEntry>((ref, element) {
  ref.watch(entryEditionEventProvider(element));
});
