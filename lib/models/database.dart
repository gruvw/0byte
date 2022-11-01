import 'dart:async';

import 'package:app_0byte/models/number_entry.dart';
import 'package:flutter/cupertino.dart';

abstract class Database {
  final StreamController<EntryEvent> _entryEventsController =
      StreamController<EntryEvent>.broadcast();

  @mustCallSuper
  UserEntry createUserEntry({
    UserEntry Function()? createUserEntry,
    required String input,
    required String label,
  }) {
    UserEntry entry = createUserEntry!();
    _entryEventsController.add(EntryEvent());
    return entry;
  }

  @mustCallSuper
  void deleteUserEntry({
    void Function()? deleteUserEntry,
    required UserEntry entry,
  }) {
    deleteUserEntry!();
    _entryEventsController.add(EntryEvent());
  }

  List<UserEntry> getEntries();

  Stream<EntryEvent> watchEntries() => _entryEventsController.stream;
}

class EntryEvent {}

abstract class Outer {
  @mustCallSuper
  String action(String data, [String Function()? innerAction]) {
    String acted = innerAction!();
    print(acted);
    return acted;
  }
}

class Concrete extends Outer {
  @override
  String action(String data, [String Function()? innerAction]) {
    return super.action("", () => data);
  }
}
