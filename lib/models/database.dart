import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/models/number_entry.dart';

abstract class Database {
  final StreamController<EntryEvent> entryEventsController =
      StreamController<EntryEvent>.broadcast();

  final StreamController<CollectionEvent> collectionEventsController =
      StreamController<CollectionEvent>.broadcast();

  Future<void> init() async {}

  NumberEntry createNumberEntry({
    required Collection collection,
    required int position,
    required ConversionType type,
    required String input,
    required String label,
  });

  Collection createCollection({
    required String label,
    required ConversionType targetType,
    required int targetSize,
  });

  List<Collection> getCollections();

  Stream<EntryEvent> watchEntries() => entryEventsController.stream;
  Stream<CollectionEvent> watchCollections() =>
      collectionEventsController.stream;
}

abstract class DatabaseObject {
  @protected
  final Database database;

  DatabaseObject({required this.database});

  void delete([bool broadcast = true]);
}

enum EventType { delete, edit, create }

class DatabaseEvent {
  final EventType type;

  DatabaseEvent({required this.type});
}

class EntryEvent extends DatabaseEvent {
  final NumberEntry entry;

  EntryEvent({
    required this.entry,
    required super.type,
  });
}

class CollectionEvent extends DatabaseEvent {
  final Collection collection;

  CollectionEvent({
    required this.collection,
    required super.type,
  });
}
