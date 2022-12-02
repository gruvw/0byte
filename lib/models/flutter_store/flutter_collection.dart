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
    _notify();
  }

  int flutterTargetTypeIndex;
  @override
  int get targetTypeIndex => flutterTargetTypeIndex;
  @override
  set targetTypeIndex(int newTypeIndex) {
    flutterTargetTypeIndex = newTypeIndex;
    _notify();
  }

  int flutterTargetSize;
  @override
  int get targetSize => flutterTargetSize;
  @override
  set targetSize(int newN) {
    flutterTargetSize = newN;
    _notify();
  }

  FlutterCollection({
    required this.database,
    required this.flutterLabel,
    required this.flutterTargetTypeIndex,
    required this.flutterTargetSize,
  });

  @override
  void delete() {
    super.delete();
    database.deleteCollection(collection: this);
  }

  void _notify() => database.collectionEventsController
      .add(CollectionEvent(collection: this));
}
