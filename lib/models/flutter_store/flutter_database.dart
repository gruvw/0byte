import 'dart:async';

import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterDatabase extends Database {
  final List<FlutterUserEntry> _entries = [];

  // ASK: should I factorize notifier logic to Database ?
  final StreamController<EntryEvent> entryEventsController =
      StreamController<EntryEvent>.broadcast();

  @override
  UserEntry createUserEntry({
    required String input,
    required String label,
  }) {
    FlutterUserEntry entry = FlutterUserEntry(input: input, label: label);
    _entries.add(entry);
    entryEventsController.add(EntryEvent());
    return entry;
  }

  @override
  void deleteUserEntry(UserEntry entry) {
    _entries.remove(entry);
    entryEventsController.add(EntryEvent());
  }

  @override
  List<UserEntry> getEntries() {
    return List.unmodifiable(_entries);
  }

  @override
  Stream<EntryEvent> watchEntries() => entryEventsController.stream;
}
