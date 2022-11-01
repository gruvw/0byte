import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterDatabase extends Database {
  final List<FlutterUserEntry> _entries = [
    FlutterUserEntry(input: "0d1", label: "x"),
    FlutterUserEntry(input: "0d4", label: "x"),
    FlutterUserEntry(input: "0d8", label: "x"),
    FlutterUserEntry(input: "0d11", label: "x"),
  ];

  @override
  UserEntry createUserEntry({
    UserEntry Function()? createUserEntry,
    required String input,
    required String label,
  }) =>
      super.createUserEntry(
          input: input,
          label: label,
          createUserEntry: () {
            FlutterUserEntry entry =
                FlutterUserEntry(input: input, label: label);
            _entries.add(entry);
            return entry;
          });

  @override
  void deleteUserEntry({
    void Function()? deleteUserEntry,
    required UserEntry entry,
  }) =>
      super.deleteUserEntry(
          entry: entry,
          deleteUserEntry: () {
            _entries.remove(entry);
          });

  @override
  List<UserEntry> getEntries() {
    return List.unmodifiable(_entries);
  }
}
