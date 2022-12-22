import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/number_entry.dart';

abstract class Database {
  final StreamController<EntryEvent> entryEventsController =
      StreamController<EntryEvent>.broadcast();

  final StreamController<CollectionEvent> collectionEventsController =
      StreamController<CollectionEvent>.broadcast();

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

class EntryEvent {
  final NumberEntry entry;

  EntryEvent({required this.entry});
}

class CollectionEvent {
  final Collection collection;

  CollectionEvent({required this.collection});
}

abstract class DatabaseObject {
  @protected
  Database get database;

  void delete();
}
