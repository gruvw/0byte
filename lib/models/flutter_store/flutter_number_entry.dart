import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
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
  String get text => flutterInput;
  @override
  set text(String newInput) {
    flutterInput = newInput;
    notify(EventType.edit);
  }

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    notify(EventType.edit);
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
  void delete([bool broadcast = true]) {
    super.delete(broadcast);
    (database as FlutterDatabase).deleteNumberEntry(entry: this);
  }
}
