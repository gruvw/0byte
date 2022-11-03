import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterDatabase extends Database {
  FlutterDatabase() {
    createUserEntry(input: "0d1", label: "x");
    createUserEntry(input: "0d4", label: "y");
    createUserEntry(input: "0d8", label: "z");
    createUserEntry(input: "0d11", label: "zz");
    createUserEntry(input: "0aaa", label: "zz");
    createUserEntry(input: "0x30", label: "zz");
  }

  final List<FlutterUserEntry> _entries = [];

  @override
  UserEntry createUserEntry({
    required String input,
    required String label,
  }) {
    FlutterUserEntry entry = FlutterUserEntry(
      database: this,
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
