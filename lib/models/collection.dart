import 'dart:math';
import 'package:tuple/tuple.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/styles/settings.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/utils.dart';

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
    String res = "$label (to ${targetType.label} $targetSize\n)";
    List<String> labels = List.empty();
    List<String> inputs = List.empty();
    List<Tuple2<String, bool>?> converts = List.empty();
    for (final entry in entries) {
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
          "${pad(entries[i].label, maxLabelLength, left: false)}: ${pad(entries[i].type.prefix + inputs[i], maxInputLength + entries[i].type.prefix.length)}";
      if (converts[i] != null) {
        res +=
            " ${converts[i]!.item2 ? SettingsTheme.symmetricArrow : SettingsTheme.nonSymmetricArrow} ${targetType.prefix}${pad(converts[i]!.item1, maxConvertLength, left: false)}";
      }
      res += i < inputs.length - 1 ? "\n" : "";
    }
    return res;
  }
}
