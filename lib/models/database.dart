import 'package:app_0byte/models/number_entry.dart';

abstract class Database {
  NumberEntry createNumberEntry({
    required String number,
    required String label,
  });

  List<NumberEntry> getEntries();

  Stream<EntryEvent> watchEntries();
}

class EntryEvent {}
