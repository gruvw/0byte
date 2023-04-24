import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';

abstract class Collection extends DatabaseObject implements SeparableDisplay {
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

  Map<String, dynamic> toJson() => {
        CollectionFields.label: label,
        CollectionFields.entries: [for (final e in entries) e.toJson()],
      };

  @override
  void delete([bool broadcast = true]) {
    deleteEntries(broadcast);
  }

  @override
  String display(bool displaySeparator) {
    final res = StringBuffer("$label\n");
    res.writeAll(entries.map((e) {
      final converted = e.converted;
      return "${e.label}: [${e.type.prefix}]${e.display(displaySeparator).substring(e.type.prefix.length)}${converted != null ? " ${converted.display(displaySeparator)}" : ""}\n";
    }));
    return res.toString();
  }
}
