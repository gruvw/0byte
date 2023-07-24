import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/settings.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/state/updaters/update_riverpod.dart';

final collectionsUpdater = Updater<List<Collection>>(
  (ref) => ref.watch(collectionsProvider),
);

final entryEditionUpdater = FamilyUpdater.family<NumberConversionEntry>(
  (ref, element) => ref.watch(entryEditionEventProvider(element)),
);

final settingsEditionUpdater = Updater<ApplicationSettings>(
  (ref) => ref.watch(settingsProvider),
);
