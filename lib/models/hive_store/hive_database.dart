import 'package:app_0byte/models/hive_store/hive_application_settings.dart';
import 'package:hive_flutter/hive_flutter.dart' hide HiveCollection;
import 'package:nanoid/nanoid.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_collection.dart';
import 'package:app_0byte/models/hive_store/hive_number_conversion_entry.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';

class HiveDatabase extends Database {
  static const String _collectionsBoxName = "collections";
  static const String _entriesBoxName = "entries";
  static const String _settingsBoxName = "settings";

  late final Box<HiveStoreCollection> collectionsBox;
  late final Box<HiveStoreNumberConversionEntry> entriesBox;
  late final Box<HiveStoreApplicationSettings> settingsBox;

  HiveDatabase();

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(HiveStoreCollectionAdapter());
    Hive.registerAdapter(HiveStoreNumberConversionEntryAdapter());
    Hive.registerAdapter(HiveStoreApplicationSettingsAdapter());

    collectionsBox = await Hive.openBox<HiveStoreCollection>(
        HiveDatabase._collectionsBoxName);
    entriesBox = await Hive.openBox<HiveStoreNumberConversionEntry>(
        HiveDatabase._entriesBoxName);
    settingsBox = await Hive.openBox<HiveStoreApplicationSettings>(
        HiveDatabase._settingsBoxName);

    // One and only one application settings stored
    if (settingsBox.isEmpty) {
      settingsBox.add(
        HiveStoreApplicationSettings(
            hiveDisplaySeparators: true,
            hiveDisplayTrimConvertedLeadingZeros: false,
            hiveExportSeparators: true,
            hiveExportTrimConvertedLeadingZeros: false,
            hiveExportUseASCIIControl: true),
      );
    }
    settingsBox.values.skip(1).forEach((e) => e.delete());
  }

  @override
  NumberConversionEntry createNumberConversionEntry({
    required Collection collection,
    required int position,
    required String label,
    required Number number,
    required ConversionTarget target,
  }) {
    HiveStoreNumberConversionEntry hiveStoreNumberEntry =
        HiveStoreNumberConversionEntry(
      hiveCollectionKey: (collection as HiveCollection).hiveStoreCollection.key,
      hivePosition: position,
      hiveLabel: label,
      hiveTypeIndex: number.type.index,
      hiveText: number.text,
      hiveTargetTypeIndex: target.type.index,
      hiveTargetDigitsAmount: target.digits.amount,
    );
    HiveNumberConversionEntry hiveEntry = HiveNumberConversionEntry(
      database: this,
      hiveStoreNumberEntry: hiveStoreNumberEntry,
    );
    entriesBox.put(nanoid(), hiveStoreNumberEntry);
    collection.hiveStoreCollection.entriesKeys.add(hiveStoreNumberEntry.key);
    collection.hiveStoreCollection.save();
    collection.notify(EventType.edit);
    return hiveEntry;
  }

  @override
  Collection createCollection({
    required String label,
  }) {
    HiveStoreCollection hiveStoreCollection = HiveStoreCollection(
      entriesKeys: [],
      hiveLabel: label,
    );
    HiveCollection hiveCollection = HiveCollection(
      database: this,
      hiveStoreCollection: hiveStoreCollection,
    );
    collectionsBox.put(nanoid(), hiveStoreCollection);
    hiveCollection.notify(EventType.create);
    return hiveCollection;
  }

  @override
  List<Collection> getCollections() {
    return List.unmodifiable(collectionsBox.values
        .map((c) => HiveCollection(
              database: this,
              hiveStoreCollection: c,
            ))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label)));
  }

  @override
  HiveApplicationSettings getSettings() => HiveApplicationSettings(
        database: this,
        hiveStoreApplicationSettings: settingsBox.getAt(0)!,
      );
}
