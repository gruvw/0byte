import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/utils/reorderable_list.dart';

class FlutterCollection extends Collection {
  final List<FlutterNumberEntry> flutterEntries = [];
  @override
  List<FlutterNumberEntry> get entries => ReorderableListView(flutterEntries);

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    notify(EventType.edit);
  }

  int flutterTargetTypeIndex;
  @override
  int get targetTypeIndex => flutterTargetTypeIndex;
  @override
  set targetTypeIndex(int newTypeIndex) {
    flutterTargetTypeIndex = newTypeIndex;
    notify(EventType.edit);
  }

  int flutterTargetSize;
  @override
  int get targetSize => flutterTargetSize;
  @override
  set targetSize(int newN) {
    flutterTargetSize = newN;
    notify(EventType.edit);
  }

  FlutterCollection({
    required super.database,
    required this.flutterLabel,
    required this.flutterTargetTypeIndex,
    required this.flutterTargetSize,
  });

  @override
  void delete([bool broadcast = true]) {
    super.delete(false);
    (database as FlutterDatabase).deleteCollection(collection: this);
  }
}
