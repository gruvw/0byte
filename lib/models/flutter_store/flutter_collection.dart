import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';

class FlutterCollection extends Collection {
  @override
  final List<FlutterNumberEntry> entries = [];

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    notify();
  }

  int flutterTargetTypeIndex;
  @override
  int get targetTypeIndex => flutterTargetTypeIndex;
  @override
  set targetTypeIndex(int newTypeIndex) {
    flutterTargetTypeIndex = newTypeIndex;
    notify();
  }

  int flutterTargetSize;
  @override
  int get targetSize => flutterTargetSize;
  @override
  set targetSize(int newN) {
    flutterTargetSize = newN;
    notify();
  }

  FlutterCollection({
    required super.database,
    required this.flutterLabel,
    required this.flutterTargetTypeIndex,
    required this.flutterTargetSize,
  });

  @override
  void delete() {
    super.delete();
    (database as FlutterDatabase).deleteCollection(collection: this);
  }
}
