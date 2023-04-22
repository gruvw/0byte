import 'dart:math';

import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/utils/conversion.dart';

abstract class Collection extends DatabaseObject {
  abstract String label;
  abstract final List<NumberConversionEntry> entries;

  Collection({required super.database});

  List<NumberConversionEntry> get sortedEntries =>
      entries..sort((a, b) => a.position.compareTo(b.position));

  void deleteEntries([bool broadcast = true]) {
    for (final entry in List.of(entries)) {
      entry.delete(broadcast);
    }
  }

  void notify(EventType type) =>
      database.collectionEventsController.add(Event(object: this, type: type));

  @override
  void delete([bool broadcast = true]) {
    deleteEntries(broadcast);
  }

  @override
  String toString() {
    // TODO collection to string
    String res = label;
    if (entries.isEmpty) {
      // Prevent reduce on empty list error
      return res;
    }
    List<String> labels = List.empty(growable: true);
    List<String> texts = List.empty(growable: true);
    List<Converted<Number>?> converts = List.empty(growable: true);
    for (final entry in sortedEntries) {
      labels.add(entry.label);
      texts.add(entry.text);
      // converts.add(entry.convertTo(
      //   ConversionTarget(
      //     type: targetType,
      //     digits: Digits.fromInt(targetSize)!,
      //   ),
      // ));
    }
    int maxLabelLength = labels.map((e) => e.length).reduce(max);
    int maxTextLength = texts.map((e) => e.length).reduce(max);
    int maxConvertLength =
        converts.map((e) => e?.toString().length ?? 0).reduce(max);
    for (var i = 0; i < texts.length; i++) {
      res +=
          "\n${entries[i].label.padRight(maxLabelLength)}: ${(entries[i].type.prefix + texts[i]).padLeft(maxTextLength + entries[i].type.prefix.length)}";
      if (converts[i] != null) {
        // res +=
        // " ${converts[i]!.wasSymmetric ? SettingsTheme.symmetricArrow : SettingsTheme.nonSymmetricArrow} ${targetType.prefix}${converts[i]!.toString().padRight(maxConvertLength)}";
      }
    }
    return res;
  }

  Map<String, dynamic> toJson() => {
        CollectionFields.label: label,
        CollectionFields.entries: [for (final e in entries) e.toJson()],
      };
}
