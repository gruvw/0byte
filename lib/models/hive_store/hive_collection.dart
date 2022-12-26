import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/hive_store/hive_database.dart';
import 'package:app_0byte/models/hive_store/hive_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:hive/hive.dart' hide HiveCollection;

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
  List<NumberEntry> get entries => hiveStoreCollection.entriesKeys
      .map((k) => HiveNumberEntry(
            database: database,
            hiveStoreNumberEntry: (database as HiveDatabase).entriesBox.get(k)!,
          ))
      .toList();

  @override
  String get label => hiveStoreCollection.hiveLabel;
  @override
  set label(String newLabel) {
    hiveStoreCollection.hiveLabel = newLabel;
    hiveStoreCollection.save();
    notify();
  }

  @override
  int get targetTypeIndex => hiveStoreCollection.hiveTypeIndex;
  @override
  set targetTypeIndex(int newTypeIndex) {
    hiveStoreCollection.hiveTypeIndex = newTypeIndex;
    hiveStoreCollection.save();
    notify();
  }

  @override
  int get targetSize => hiveStoreCollection.hiveTargetSize;
  @override
  set targetSize(int newN) {
    hiveStoreCollection.hiveTargetSize = newN;
    hiveStoreCollection.save();
    notify();
  }

  @override
  void delete() {
    super.delete();
    hiveStoreCollection.delete();
    notify();
  }

  @override
  bool operator ==(covariant HiveCollection other) =>
      database == other.database &&
      hiveStoreCollection.key == other.hiveStoreCollection.key;

  @override
  int get hashCode => Object.hash(database, hiveStoreCollection.key);
}
