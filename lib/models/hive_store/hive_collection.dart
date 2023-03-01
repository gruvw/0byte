import 'package:hive/hive.dart' hide HiveCollection;

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/hive_store/hive_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/utils/reorderable_list.dart';

part 'hive_collection.g.dart';

@HiveType(typeId: 0)
class HiveStoreCollection with HiveObjectMixin {
  @HiveField(0)
  final List<String> entriesKeys;

  @HiveField(1)
  String hiveLabel;

  @HiveField(2)
  int hiveTypeIndex;

  @HiveField(3)
  int hiveTargetSize;

  HiveStoreCollection({
    required this.entriesKeys,
    required this.hiveLabel,
    required this.hiveTypeIndex,
    required this.hiveTargetSize,
  });
}

class HiveCollection extends Collection {
  final HiveStoreCollection hiveStoreCollection;

  HiveCollection({
    required super.database,
    required this.hiveStoreCollection,
  });

  @override
  List<NumberEntry> get entries =>
      ReorderableListView(hiveStoreCollection.entriesKeys
          .map((k) => HiveNumberEntry(
                database: database,
                hiveStoreNumberEntry:
                    (database as HiveDatabase).entriesBox.get(k)!,
              ))
          .toList());

  @override
  String get label => hiveStoreCollection.hiveLabel;
  @override
  set label(String newLabel) {
    hiveStoreCollection.hiveLabel = newLabel;
    hiveStoreCollection.save();
    notify(EventType.edit);
  }

  @override
  int get targetTypeIndex => hiveStoreCollection.hiveTypeIndex;
  @override
  set targetTypeIndex(int newTypeIndex) {
    hiveStoreCollection.hiveTypeIndex = newTypeIndex;
    hiveStoreCollection.save();
    notify(EventType.edit);
  }

  @override
  int get targetSize => hiveStoreCollection.hiveTargetSize;
  @override
  set targetSize(int newTargetSize) {
    hiveStoreCollection.hiveTargetSize = newTargetSize;
    hiveStoreCollection.save();
    notify(EventType.edit);
  }

  @override
  void delete([bool broadcast = true]) {
    super.delete(false);
    hiveStoreCollection.delete();
    if (broadcast) {
      notify(EventType.delete);
    }
  }

  @override
  bool operator ==(covariant HiveCollection other) =>
      database == other.database &&
      hiveStoreCollection.key == other.hiveStoreCollection.key;

  @override
  int get hashCode => Object.hash(database, hiveStoreCollection.key);
}
