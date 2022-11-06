import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterDatabase extends Database {
  FlutterDatabase();

  final List<FlutterUserEntry> _entries = [];

  @override
  UserEntry createUserEntry({
    required ConversionType type,
    required String input,
    required String label,
  }) {
    FlutterUserEntry entry = FlutterUserEntry(
      database: this,
      typeIndex: type.index,
      flutterInput: input,
      flutterLabel: label,
    );
    _entries.add(entry);
    entryEventsController.add(EntryEvent(entry: entry));
    return entry;
  }

  void deleteUserEntry({required UserEntry entry}) {
    _entries.remove(entry);
  }

  @override
  List<UserEntry> getEntries() {
    return List.unmodifiable(_entries);
  }
}
