import 'package:flutter/cupertino.dart';

import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_types.dart';

abstract class NumberConversionEntry extends DatabaseObject with Number, NumberConversion {
  NumberConversionEntry({required super.database});

  abstract final Collection collection;

  int get position;
  @protected
  set position(int newPosition);

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

  Map<String, dynamic> toJson() => {
        EntryFields.position: position,
        EntryFields.label: label,
        EntryFields.typeIndex: type.index,
        EntryFields.text: text,
        EntryFields.targetTypeIndex: target.type.index,
        EntryFields.targetDigitsAmount: target.digits.amount,
      };

  @protected
  void notify(EventType type) =>
      database.entryEventsController.add(Event(object: this, type: type));

  @override
  void delete([bool broadcast = true]) {
    for (final entry in collection.entries) {
      if (entry.position > position) {
        entry.position--;
      }
    }
  }
}
