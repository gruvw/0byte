import 'dart:math';

import 'package:tuple/tuple.dart';

import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/utils/conversion.dart';

abstract class Collection extends DatabaseObject {
  abstract final List<NumberEntry> entries;
  abstract String label;
  abstract int targetTypeIndex;
  abstract int targetSize;

  Collection({required super.database});

  ConversionType get targetType => ConversionType.values[targetTypeIndex];

  set targetType(ConversionType newType) => targetTypeIndex = newType.index;

  List<NumberEntry> get sortedEntries =>
      entries..sort((a, b) => a.position.compareTo(b.position));

  void deleteEntries([bool broadcast = true]) {
    for (final entry in List.of(entries)) {
      entry.delete(broadcast);
    }
  }

  void notify(EventType type) => database.collectionEventsController
      .add(CollectionEvent(collection: this, type: type));

  @override
  void delete([bool broadcast = true]) {
    deleteEntries(broadcast);
  }

  @override
  String toString() {
    String res = "$label (to ${targetType.label} $targetSize)";
    if (entries.isEmpty) {
      // Prevent reduce on empty list error
      return res;
    }
    List<String> labels = List.empty(growable: true);
    List<String> inputs = List.empty(growable: true);
    List<Tuple2<String, bool>?> converts = List.empty(growable: true);
    for (final entry in sortedEntries) {
      labels.add(entry.label);
      inputs.add(entry.input);
      converts
          .add(convertEntry(entry.type, entry.input, targetType, targetSize));
    }
    int maxLabelLength = labels.map((e) => e.length).reduce(max);
    int maxInputLength = inputs.map((e) => e.length).reduce(max);
    int maxConvertLength =
        converts.map((e) => e?.item1.length ?? 0).reduce(max);
    for (var i = 0; i < inputs.length; i++) {
      res +=
          "\n${entries[i].label.padRight(maxLabelLength)}: ${(entries[i].type.prefix + inputs[i]).padLeft(maxInputLength + entries[i].type.prefix.length)}";
      if (converts[i] != null) {
        res +=
            " ${converts[i]!.item2 ? SettingsTheme.symmetricArrow : SettingsTheme.nonSymmetricArrow} ${targetType.prefix}${converts[i]!.item1.padRight(maxConvertLength)}";
      }
    }
    return res;
  }

  Map<String, dynamic> toJson() => {
        CollectionFields.label: label,
        CollectionFields.targetTypeIndex: targetTypeIndex,
        CollectionFields.targetSize: targetSize,
        CollectionFields.entries: [for (final e in entries) e.toJson()],
      };
}
