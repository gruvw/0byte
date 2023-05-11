import 'package:hive_flutter/hive_flutter.dart';

import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/settings.dart';

part 'hive_application_settings.g.dart';

@HiveType(typeId: 2)
class HiveStoreApplicationSettings with HiveObjectMixin {
  @HiveField(0)
  bool hiveDisplaySeparators;

  @HiveField(1)
  bool hiveDisplayTrimConvertedLeadingZeros;

  @HiveField(2)
  bool hiveExportSeparators;

  @HiveField(3)
  bool hiveExportTrimConvertedLeadingZeros;

  @HiveField(4)
  bool hiveExportUseASCIIControl;

  HiveStoreApplicationSettings({
    required this.hiveDisplaySeparators,
    required this.hiveDisplayTrimConvertedLeadingZeros,
    required this.hiveExportSeparators,
    required this.hiveExportTrimConvertedLeadingZeros,
    required this.hiveExportUseASCIIControl,
  });
}

class HiveApplicationSettings extends ApplicationSettings {
  final HiveStoreApplicationSettings hiveStoreApplicationSettings;

  HiveApplicationSettings({
    required super.database,
    required this.hiveStoreApplicationSettings,
  });

  @override
  bool get displaySeparators => hiveStoreApplicationSettings.hiveDisplaySeparators;
  @override
  set displaySeparators(bool newDisplaySeparators) {
    hiveStoreApplicationSettings.hiveDisplaySeparators = newDisplaySeparators;
    hiveStoreApplicationSettings.save();
    notify(EventType.edit);
  }

  @override
  bool get displayTrimConvertedLeadingZeros =>
      hiveStoreApplicationSettings.hiveDisplayTrimConvertedLeadingZeros;
  @override
  set displayTrimConvertedLeadingZeros(bool newDisplayTrimConvertedLeadingZeros) {
    hiveStoreApplicationSettings.hiveDisplayTrimConvertedLeadingZeros =
        newDisplayTrimConvertedLeadingZeros;
    hiveStoreApplicationSettings.save();
    notify(EventType.edit);
  }

  @override
  bool get exportSeparators => hiveStoreApplicationSettings.hiveExportSeparators;
  @override
  set exportSeparators(bool newExportSeparators) {
    hiveStoreApplicationSettings.hiveExportSeparators = newExportSeparators;
    hiveStoreApplicationSettings.save();
    notify(EventType.edit);
  }

  @override
  bool get exportTrimConvertedLeadingZeros =>
      hiveStoreApplicationSettings.hiveExportTrimConvertedLeadingZeros;
  @override
  set exportTrimConvertedLeadingZeros(bool newExportTrimConvertedLeadingZeros) {
    hiveStoreApplicationSettings.hiveExportTrimConvertedLeadingZeros =
        newExportTrimConvertedLeadingZeros;
    hiveStoreApplicationSettings.save();
    notify(EventType.edit);
  }

  @override
  bool get exportUseASCIIControl => hiveStoreApplicationSettings.hiveExportUseASCIIControl;
  @override
  set exportUseASCIIControl(bool newExportUseASCIIControl) {
    hiveStoreApplicationSettings.hiveExportUseASCIIControl = newExportUseASCIIControl;
    hiveStoreApplicationSettings.save();
    notify(EventType.edit);
  }
}
