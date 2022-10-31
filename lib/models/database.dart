import 'package:app_0byte/models/number_entry.dart';

abstract class Database {
  UserEntry createUserEntry({
    required String input,
    required String label,
  });

  void deleteUserEntry(UserEntry entry);

  List<UserEntry> getEntries();

  Stream<EntryEvent> watchEntries();
}

class EntryEvent {}
