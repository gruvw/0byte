import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterNumberEntry extends NumberEntry {
  @override
  final FlutterDatabase database;

  @override
  final int typeIndex;

  @override
  final Collection collection;

  @override
  int position;

  String flutterInput;
  @override
  String get input => flutterInput;
  @override
  set input(String newInput) {
    flutterInput = newInput;
    database.entryEventsController.add(EntryEvent(entry: this));
  }

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    database.entryEventsController.add(EntryEvent(entry: this));
  }

  FlutterNumberEntry({
    required this.database,
    required this.collection,
    required this.position,
    required this.typeIndex,
    required this.flutterInput,
    required this.flutterLabel,
  });

  @override
  void delete() {
    super.delete();
    database.deleteNumberEntry(entry: this);
  }
}
