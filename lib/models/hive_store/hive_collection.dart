import 'package:hive/hive.dart' hide HiveCollection;

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/hive_store/hive_number_conversion_entry.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/utils/reorderable_list.dart';

part 'hive_collection.g.dart';

@HiveType(typeId: 0)
class HiveStoreCollection with HiveObjectMixin {
  @HiveField(0)
  final List<String> entriesKeys;

  @HiveField(1)
  String hiveLabel;

  HiveStoreCollection({
    required this.entriesKeys,
    required this.hiveLabel,
  });
}

class HiveCollection extends Collection {
  final HiveStoreCollection hiveStoreCollection;

  HiveCollection({
    required super.database,
    required this.hiveStoreCollection,
  });

  @override
  List<NumberConversionEntry> get entries =>
      SortableList(hiveStoreCollection.entriesKeys
          .map((k) => HiveNumberConversionEntry(
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
