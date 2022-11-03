import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterUserEntry extends UserEntry {
  @override
  final FlutterDatabase database;

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

  FlutterUserEntry({
    required this.database,
    required this.flutterInput,
    required this.flutterLabel,
  });

  @override
  void delete() {
    database.deleteUserEntry(entry: this);
    database.entryEventsController.add(EntryEvent(entry: this));
  }
}
