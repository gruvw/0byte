import 'dart:async';

import 'package:app_0byte/models/settings.dart';
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

  final StreamController<Event<ApplicationSettings>> settingsEventsController =
      StreamController<Event<ApplicationSettings>>.broadcast();

  Future<void> init() async {}

  Collection createCollection({
    required String label,
  });

  List<Collection> getCollections();
  List<NumberConversionEntry> getEntries();

  Collection? getCollection(String collectionKey) =>
      getCollections().where((c) => c.key == collectionKey).firstOrNull;

  NumberConversionEntry? getEntry(String entryKey) =>
      getEntries().where((e) => e.key == entryKey).firstOrNull;

  NumberConversionEntry createNumberConversionEntry({
    required Collection collection,
    required int position,
    required String label,
    required Number number,
    required ConversionTarget target,
  });

  ApplicationSettings getSettings();

  Stream<Event<Collection>> watchCollections() => collectionEventsController.stream;
  Stream<Event<NumberConversionEntry>> watchEntries() => entryEventsController.stream;
  Stream<Event<ApplicationSettings>> watchSettings() => settingsEventsController.stream;
}

abstract class DatabaseObject {
  @protected
  final Database database;

  String get key;

  DatabaseObject({required this.database});

  void delete([bool broadcast = true]);
}

enum EventType { delete, edit, create }

class Event<T> {
  final EventType type;
  final T object;

  Event({required this.object, required this.type});
}
