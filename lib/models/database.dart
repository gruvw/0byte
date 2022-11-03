import 'dart:async';

import 'package:app_0byte/models/number_entry.dart';
import 'package:flutter/cupertino.dart';

abstract class Database {
  final StreamController<EntryEvent> entryEventsController =
      StreamController<EntryEvent>.broadcast();

  UserEntry createUserEntry({
    required String input,
    required String label,
  });

  List<UserEntry> getEntries();

  Stream<EntryEvent> watchEntries() => entryEventsController.stream;
}

class EntryEvent {
  final UserEntry entry;

  EntryEvent({required this.entry});
}

abstract class DatabaseObject {
  @protected
  Database get database;
}
