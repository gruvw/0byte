import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterNumberEntry extends NumberEntry {
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
    notify();
  }

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    notify();
  }

  FlutterNumberEntry({
    required super.database,
    required this.collection,
    required this.position,
    required this.typeIndex,
    required this.flutterInput,
    required this.flutterLabel,
  });

  @override
  void delete() {
    super.delete();
    (database as FlutterDatabase).deleteNumberEntry(entry: this);
  }
}
