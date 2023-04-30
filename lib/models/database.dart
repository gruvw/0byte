import 'dart:async';

import 'package:flutter/material.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';

abstract class Database {
  final StreamController<Event<NumberConversionEntry>> entryEventsController =
      StreamController<Event<NumberConversionEntry>>.broadcast();

  final StreamController<Event<Collection>> collectionEventsController =
      StreamController<Event<Collection>>.broadcast();

  Future<void> init() async {}

  NumberConversionEntry createNumberConversionEntry({
    required Collection collection,
    required int position,
    required String label,
    required Number number,
    required ConversionTarget target,
  });

  Collection createCollection({
    required String label,
  });

  List<Collection> getCollections();

  Stream<Event<NumberConversionEntry>> watchEntries() => entryEventsController.stream;
  Stream<Event<Collection>> watchCollections() => collectionEventsController.stream;
}

abstract class DatabaseObject {
  @protected
  final Database database;

  DatabaseObject({required this.database});

  void delete([bool broadcast = true]);
}

enum EventType { delete, edit, create }

class Event<T> {
  final EventType type;
  final T object;

  Event({required this.object, required this.type});
}
