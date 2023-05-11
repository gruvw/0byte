import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/settings.dart';

class FlutterApplicationSettings extends ApplicationSettings {
  bool flutterDisplaySeparators;
  @override
  bool get displaySeparators => flutterDisplaySeparators;
  @override
  set displaySeparators(bool newDisplaySeparators) {
    flutterDisplaySeparators = newDisplaySeparators;
    notify(EventType.edit);
  }

  bool flutterDisplayTrimConvertedLeadingZeros;
  @override
  bool get displayTrimConvertedLeadingZeros => flutterDisplayTrimConvertedLeadingZeros;
  @override
  set displayTrimConvertedLeadingZeros(bool newDisplayTrimConvertedLeadingZeros) {
    flutterDisplaySeparators = newDisplayTrimConvertedLeadingZeros;
    notify(EventType.edit);
  }

  bool flutterExportSeparators;
  @override
  bool get exportSeparators => flutterExportSeparators;
  @override
  set exportSeparators(bool newExportSeparators) {
    flutterExportSeparators = newExportSeparators;
    notify(EventType.edit);
  }

  bool flutterExportTrimConvertedLeadingZeros;
  @override
  bool get exportTrimConvertedLeadingZeros => flutterExportTrimConvertedLeadingZeros;
  @override
  set exportTrimConvertedLeadingZeros(bool newExportTrimConvertedLeadingZeros) {
    flutterExportTrimConvertedLeadingZeros = newExportTrimConvertedLeadingZeros;
    notify(EventType.edit);
  }

  bool flutterExportUseASCIIControl;
  @override
  bool get exportUseASCIIControl => flutterExportUseASCIIControl;
  @override
  set exportUseASCIIControl(bool newExportUseASCIIControl) {
    flutterExportUseASCIIControl = newExportUseASCIIControl;
    notify(EventType.edit);
  }

  FlutterApplicationSettings({
    required super.database,
    required this.flutterDisplaySeparators,
    required this.flutterDisplayTrimConvertedLeadingZeros,
    required this.flutterExportSeparators,
    required this.flutterExportTrimConvertedLeadingZeros,
    required this.flutterExportUseASCIIControl,
  });
}
