import 'package:flutter/material.dart';

import 'package:app_0byte/models/database.dart';

abstract class ApplicationSettings extends DatabaseObject {
  abstract bool displaySeparators;
  abstract bool displayTrimConvertedLeadingZeros;
  abstract bool exportSeparators;
  abstract bool exportTrimConvertedLeadingZeros;
  abstract bool exportUseASCIIControl;

  ApplicationSettings({required super.database});

  @protected
  void notify(EventType type) =>
      database.settingsEventsController.add(Event(object: this, type: type));

  @override
  void delete([bool broadcast = true]) {
    throw UnsupportedError("Can't delete the application settings");
  }
}
