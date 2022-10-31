import 'dart:async';

import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterDatabase extends Database {
  final List<FlutterNumberEntry> _entries = [];

  final StreamController<EntryEvent> entryEventsController =
      StreamController<EntryEvent>.broadcast();

  @override
  NumberEntry createNumberEntry({
    required String number,
    required String label,
  }) {
    FlutterNumberEntry entry = FlutterNumberEntry(number: number, label: label);
    _entries.add(entry);
    entryEventsController.add(EntryEvent());
    return entry;
  }

  @override
  List<NumberEntry> getEntries() {
    return List.unmodifiable(_entries);
  }

  @override
  Stream<EntryEvent> watchEntries() => entryEventsController.stream;
}
