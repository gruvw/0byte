import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_entry.dart';

abstract class Collection extends DatabaseObject {
  abstract final List<NumberEntry> entries;
  abstract String label;
  abstract int targetTypeIndex;
  abstract int targetSize;

  Collection({required super.database});

  ConversionType get targetType => ConversionType.values[targetTypeIndex];

  set targetType(ConversionType newType) => targetTypeIndex = newType.index;

  List<NumberEntry> get sortedEntries =>
      entries..sort((a, b) => a.position.compareTo(b.position));

  void deleteEntries() {
    entries.map((e) => e.delete());
  }

  void notify() => database.collectionEventsController
      .add(CollectionEvent(collection: this));

  @override
  void delete() {
    deleteEntries();
  }
}
