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

  late final Box<HiveStoreCollection> collectionsBox;
  late final Box<HiveStoreNumberConversionEntry> entriesBox;

  HiveDatabase();

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(HiveStoreCollectionAdapter());
    Hive.registerAdapter(HiveStoreNumberConversionEntryAdapter());

    collectionsBox = await Hive.openBox<HiveStoreCollection>(
        HiveDatabase._collectionsBoxName);
    entriesBox = await Hive.openBox<HiveStoreNumberConversionEntry>(
        HiveDatabase._entriesBoxName);
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
}
