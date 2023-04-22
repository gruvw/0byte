import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/utils/reorderable_list.dart';

class FlutterCollection extends Collection {
  final List<FlutterNumberConversionEntry> flutterEntries = [];
  @override
  List<FlutterNumberConversionEntry> get entries =>
      ReorderableListView(flutterEntries);

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    notify(EventType.edit);
  }

  FlutterCollection({
    required super.database,
    required this.flutterLabel,
  });

  @override
  void delete([bool broadcast = true]) {
    super.delete(false);
    (database as FlutterDatabase).deleteCollection(collection: this);
  }
}
