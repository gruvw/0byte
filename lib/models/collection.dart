import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_entry.dart';

abstract class Collection extends DatabaseObject {
  abstract final List<NumberEntry> entries;
  abstract String label;

  List<NumberEntry> get sortedEntries =>
      entries..sort((a, b) => a.position.compareTo(b.position));

  void delete() {
    for (final entry in entries) {
      entry.delete();
    }
  }
}
