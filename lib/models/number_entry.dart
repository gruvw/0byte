import 'package:flutter/material.dart';

import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/utils/conversion.dart';

abstract class NumberEntry extends DatabaseObject with Number {
  NumberEntry({required super.database});

  @protected
  abstract final int typeIndex;
  @override
  late final ConversionType type = ConversionType.values[typeIndex];

  @override
  set type(ConversionType _) => throw UnimplementedError(); // TODO

  abstract final Collection collection;

  @protected
  abstract String entryLabel;

  // Non-nullable label for number entries
  @override
  String get label => entryLabel;
  @override
  set label(String? newLabel) {
    if (newLabel == null) {
      return;
    }

    entryLabel = newLabel;
  }

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

  ConversionTarget get target {
    // FIXME digits + type from entry
    final digits = Digits.fromInt(collection.targetSize)!;

    return ConversionTarget(
      type: collection.targetType,
      digits: digits,
    );
  }

  set target(ConversionTarget newTarget) {
    // Validate digits
    throw UnimplementedError(); // TODO
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
    String res = "$label: ${type.prefix}$text";
    final converted = convertEntry(
      type,
      text,
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
        EntryFields.input: text,
        EntryFields.label: label,
        EntryFields.typeIndex: typeIndex,
        EntryFields.position: position,
      };
}
