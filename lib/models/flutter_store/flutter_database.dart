import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_entry.dart';
import 'package:app_0byte/models/number_entry.dart';

class FlutterDatabase extends Database {
  FlutterDatabase() {
    createUserEntry(
      type: ConversionType.unsignedDecimal,
      input: "1",
      label: "x",
    );
    createUserEntry(
      type: ConversionType.unsignedDecimal,
      input: "4",
      label: "y",
    );
    createUserEntry(
      type: ConversionType.unsignedDecimal,
      input: "8",
      label: "z",
    );
    createUserEntry(
      type: ConversionType.unsignedDecimal,
      input: "11",
      label: "zz",
    );
    createUserEntry(
      type: ConversionType.ascii,
      input: "aa",
      label: "zz",
    );
    createUserEntry(
      type: ConversionType.hexadecimal,
      input: "30",
      label: "zz",
    );
    createUserEntry(
      type: ConversionType.signedDecimal,
      input: "-02",
      label: "zz",
    );
  }

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
