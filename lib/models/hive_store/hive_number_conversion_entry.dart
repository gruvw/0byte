import 'package:hive/hive.dart' hide HiveCollection;

import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_collection.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/conversion.dart';

part 'hive_number_conversion_entry.g.dart';

@HiveType(typeId: 1)
class HiveStoreNumberConversionEntry with HiveObjectMixin {
  @HiveField(0)
  final String hiveCollectionKey;

  @HiveField(1)
  int hivePosition;

  @HiveField(2)
  String hiveLabel;

  @HiveField(3)
  int hiveTypeIndex;

  @HiveField(4)
  String hiveText;

  @HiveField(5)
  int hiveTargetTypeIndex;

  @HiveField(6)
  int hiveTargetDigitsAmount;

  HiveStoreNumberConversionEntry({
    required this.hiveCollectionKey,
    required this.hivePosition,
    required this.hiveLabel,
    required this.hiveTypeIndex,
    required this.hiveText,
    required this.hiveTargetTypeIndex,
    required this.hiveTargetDigitsAmount,
  });
}

class HiveNumberConversionEntry extends NumberConversionEntry {
  final HiveStoreNumberConversionEntry hiveStoreNumberEntry;

  HiveNumberConversionEntry({
    required super.database,
    required this.hiveStoreNumberEntry,
  });

  @override
  HiveCollection get collection => HiveCollection(
        database: database,
        hiveStoreCollection: (database as HiveDatabase)
            .collectionsBox
            .get(hiveStoreNumberEntry.hiveCollectionKey)!,
      );

  @override
  int get position => hiveStoreNumberEntry.hivePosition;
  @override
  set position(int newPosition) {
    hiveStoreNumberEntry.hivePosition = newPosition;
    hiveStoreNumberEntry.save();
    notify(EventType.edit);
  }

  @override
  String get label => hiveStoreNumberEntry.hiveLabel;
  @override
  set label(String newEntryLabel) {
    hiveStoreNumberEntry.hiveLabel = newEntryLabel;
    hiveStoreNumberEntry.save();
    notify(EventType.edit);
  }

  @override
  ConversionType get type =>
      ConversionType.values[hiveStoreNumberEntry.hiveTypeIndex];
  @override
  set type(ConversionType newType) {
    hiveStoreNumberEntry.hiveTypeIndex = newType.index;
    hiveStoreNumberEntry.save();
    notify(EventType.edit);
  }

  @override
  String get text => hiveStoreNumberEntry.hiveText;
  @override
  set text(String newText) {
    hiveStoreNumberEntry.hiveText = newText;
    hiveStoreNumberEntry.save();
    notify(EventType.edit);
  }

  @override
  ConversionTarget get target => ConversionTarget(
        type: ConversionType.values[hiveStoreNumberEntry.hiveTargetTypeIndex],
        digits: Digits.fromInt(hiveStoreNumberEntry.hiveTargetDigitsAmount)!,
      );
  @override
  set target(ConversionTarget newTarget) {
    hiveStoreNumberEntry.hiveTargetTypeIndex = newTarget.type.index;
    hiveStoreNumberEntry.hiveTargetDigitsAmount = newTarget.digits.amount;
    hiveStoreNumberEntry.save();
    notify(EventType.edit);
  }

  @override
  void delete([bool broadcast = true]) {
    super.delete();
    collection.hiveStoreCollection.entriesKeys.remove(hiveStoreNumberEntry.key);
    collection.hiveStoreCollection.save();
    hiveStoreNumberEntry.delete();
    if (broadcast) {
      collection.notify(EventType.edit);
    }
  }

  @override
  bool operator ==(covariant HiveNumberConversionEntry other) =>
      database == other.database &&
      hiveStoreNumberEntry.key == other.hiveStoreNumberEntry.key;

  @override
  int get hashCode => Object.hash(database, hiveStoreNumberEntry.key);
}
