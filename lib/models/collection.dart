import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/number_entry.dart';

abstract class Collection extends DatabaseObject {
  abstract final List<NumberEntry> entries;
  abstract String label;

  void delete() {
    for (final entry in entries) {
      entry.delete();
    }
  }
}
