import 'package:hive_flutter/hive_flutter.dart' hide HiveCollection;
import 'package:nanoid/nanoid.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_collection.dart';
import 'package:app_0byte/models/hive_store/hive_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class HiveDatabase extends Database {
  static const String entriesBoxName = "entries";
  static const String collectionsBoxName = "collections";

  late final Box<HiveStoreNumberEntry> entriesBox;
  late final Box<HiveStoreCollection> collectionsBox;

  HiveDatabase();

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(HiveStoreNumberEntryAdapter());
    Hive.registerAdapter(HiveStoreCollectionAdapter());

    entriesBox =
        await Hive.openBox<HiveStoreNumberEntry>(HiveDatabase.entriesBoxName);
    collectionsBox = await Hive.openBox<HiveStoreCollection>(
        HiveDatabase.collectionsBoxName);
  }

  @override
  NumberEntry createNumberEntry({
    required Collection collection,
    required int position,
    required ConversionType type,
    required String input,
    required String label,
  }) {
    HiveStoreNumberEntry hiveStoreEntry = HiveStoreNumberEntry(
      hiveLabel: label,
      hiveTypeIndex: type.index,
      hiveInput: input,
      hivePosition: position,
      hiveCollectionKey: (collection as HiveCollection).hiveStoreCollection.key,
    );
    HiveNumberEntry hiveEntry = HiveNumberEntry(
      database: this,
      hiveStoreNumberEntry: hiveStoreEntry,
    );
    entriesBox.put(nanoid(), hiveStoreEntry);
    collection.hiveStoreCollection.entriesKeys.add(hiveStoreEntry.key);
    collection.hiveStoreCollection.save();
    collection.notify();
    return hiveEntry;
  }

  @override
  Collection createCollection({
    required String label,
    required ConversionType targetType,
    required int targetSize,
  }) {
    HiveStoreCollection hiveStoreCollection = HiveStoreCollection(
      entriesKeys: [],
      hiveLabel: label,
      hiveTypeIndex: targetType.index,
      hiveTargetSize: targetSize,
    );
    HiveCollection hiveCollection = HiveCollection(
      database: this,
      hiveStoreCollection: hiveStoreCollection,
    );
    collectionsBox.put(nanoid(), hiveStoreCollection);
    hiveCollection.notify();
    return hiveCollection;
  }

  @override
  List<Collection> getCollections() {
    return List.unmodifiable(
      collectionsBox.values.map((c) => HiveCollection(
            database: this,
            hiveStoreCollection: c,
          )),
    );
  }
}
