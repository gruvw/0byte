import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/number_entry.dart';

abstract class Database {
  final StreamController<EntryEvent> entryEventsController =
      StreamController<EntryEvent>.broadcast();

  UserEntry createUserEntry({
    required ConversionType type,
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
