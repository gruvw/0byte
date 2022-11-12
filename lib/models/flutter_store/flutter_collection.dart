import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';

class FlutterCollection extends Collection {
  @override
  final FlutterDatabase database;

  @override
  final List<FlutterNumberEntry> entries = [];

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    database.collectionEventsController.add(CollectionEvent(collection: this));
  }

  FlutterCollection({
    required this.database,
    required this.flutterLabel,
  });

  @override
  void delete() {
    super.delete();
    database.deleteCollection(collection: this);
  }
}
