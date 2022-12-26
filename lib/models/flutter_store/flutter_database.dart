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
    collection.notify();
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
    collection.notify();
    return collection;
  }

  void deleteNumberEntry({required NumberEntry entry}) {
    entry.collection.entries.remove(entry);
    entry.collection.notify();
  }

  void deleteCollection({required FlutterCollection collection}) {
    _collections.remove(collection);
    collection.notify();
  }

  @override
  List<Collection> getCollections() {
    return List.of(_collections);
  }
}
