import 'package:hive/hive.dart' hide HiveCollection;

import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_collection.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/number_entry.dart';

part 'hive_number_entry.g.dart';

@HiveType(typeId: 1)
class HiveStoreNumberEntry with HiveObjectMixin {
  @HiveField(0)
  String hiveLabel;

  @HiveField(1)
  final int hiveTypeIndex;

  @HiveField(2)
  String hiveText;

  @HiveField(3)
  int hivePosition;

  @HiveField(4)
  final String hiveCollectionKey;

  HiveStoreNumberEntry({
    required this.hiveLabel,
    required this.hiveTypeIndex,
    required this.hiveText,
    required this.hivePosition,
    required this.hiveCollectionKey,
  });
}

class HiveNumberEntry extends NumberEntry {
  final HiveStoreNumberEntry hiveStoreNumberEntry;

  HiveNumberEntry({
    required super.database,
    required this.hiveStoreNumberEntry,
  });

  @override
  int get typeIndex => hiveStoreNumberEntry.hiveTypeIndex;

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
  String get entryLabel => hiveStoreNumberEntry.hiveLabel;
  @override
  set entryLabel(String newEntryLabel) {
    hiveStoreNumberEntry.hiveLabel = newEntryLabel;
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
  bool operator ==(covariant HiveNumberEntry other) =>
      database == other.database &&
      hiveStoreNumberEntry.key == other.hiveStoreNumberEntry.key;

  @override
  int get hashCode => Object.hash(database, hiveStoreNumberEntry.key);
}
