import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/utils/conversion.dart';
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

    collection.notify(EventType.edit);
  }

  void notify(EventType type) =>
      database.entryEventsController.add(EntryEvent(entry: this, type: type));

  @override
  void delete([bool broadcast = true]) {
    for (final entry in collection.entries) {
      if (entry.position > position) {
        entry.position--;
      }
    }
  }

  @override
  String toString() {
    String res = "$label: ${type.prefix}$input";
    final converted = convertEntry(
      type,
      input,
      collection.targetType,
      collection.targetSize,
    );
    if (converted != null) {
      res +=
          " ${converted.item2 ? SettingsTheme.symmetricArrow : SettingsTheme.nonSymmetricArrow} ${converted.item1}";
    }
    return res;
  }

  Map<String, dynamic> toJson() => {
        EntryFields.input: input,
        EntryFields.label: label,
        EntryFields.typeIndex: typeIndex,
        EntryFields.position: position,
      };
}
