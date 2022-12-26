import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_collection.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterDatabase extends Database {
  final List<FlutterCollection> _collections = [];

  FlutterDatabase();

  @override
  NumberEntry createNumberEntry({
    required Collection collection,
    required int position,
    required ConversionType type,
    required String input,
    required String label,
  }) {
    FlutterNumberEntry entry = FlutterNumberEntry(
      database: this,
      collection: collection,
      position: position,
      typeIndex: type.index,
      flutterInput: input,
      flutterLabel: label,
    );
    collection.entries.add(entry);
    collection.notify(EventType.edit);
    return entry;
  }

  @override
  Collection createCollection({
    required String label,
    required ConversionType targetType,
    required int targetSize,
  }) {
    FlutterCollection collection = FlutterCollection(
      database: this,
      flutterLabel: label,
      flutterTargetTypeIndex: targetType.index,
      flutterTargetSize: targetSize,
    );
    _collections.add(collection);
    collection.notify(EventType.create);
    return collection;
  }

  void deleteNumberEntry({required NumberEntry entry}) {
    entry.collection.entries.remove(entry);
    entry.collection.notify(EventType.delete);
  }

  void deleteCollection({required FlutterCollection collection}) {
    _collections.remove(collection);
    collection.notify(EventType.delete);
  }

  @override
  List<Collection> getCollections() {
    return List.unmodifiable(
        _collections..sort((a, b) => a.label.compareTo(b.label)));
  }
}
