import 'package:flutter/material.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';

abstract class NumberEntry extends DatabaseObject {
  NumberEntry({required super.database});

  @protected
  abstract final int typeIndex;
  late final ConversionType type = ConversionType.values[typeIndex];

  abstract final Collection collection;

  abstract String input;
  abstract String label;
  abstract int position;

  void move(int newPosition) {
    final entries = collection.sortedEntries;

    for (int i = newPosition; i < position; i++) {
      entries[i].position++;
    }
    for (int i = position + 1; i <= newPosition; i++) {
      entries[i].position--;
    }
    position = newPosition;

    collection.notify();
  }

  void notify() => database.entryEventsController.add(EntryEvent(entry: this));

  @override
  void delete() {
    for (final entry in collection.entries) {
      entry.position--;
    }
  }
}
