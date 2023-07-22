import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_database.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:nanoid/non_secure.dart';

class FlutterNumberConversionEntry extends NumberConversionEntry {
  @override
  final String key;

  @override
  final Collection collection;

  int flutterPosition;
  @override
  int get position => flutterPosition;
  @override
  set position(int newPosition) {
    flutterPosition = newPosition;
    notify(EventType.edit);
  }

  String flutterLabel;
  @override
  String get label => flutterLabel;
  @override
  set label(String newLabel) {
    flutterLabel = newLabel;
    notify(EventType.edit);
  }

  Number flutterNumber;

  @override
  ConversionType get type => flutterNumber.type;
  @override
  set type(ConversionType newType) {
    flutterNumber.type = newType;
    notify(EventType.edit);
  }

  @override
  String get text => flutterNumber.text;
  @override
  set text(String newText) {
    flutterNumber.text = newText;
    notify(EventType.edit);
  }

  ConversionTarget flutterTarget;
  @override
  ConversionTarget get target => flutterTarget;
  @override
  set target(ConversionTarget newTarget) {
    flutterTarget = newTarget;
    notify(EventType.edit);
  }

  FlutterNumberConversionEntry({
    required super.database,
    required this.collection,
    required this.flutterPosition,
    required this.flutterLabel,
    required this.flutterNumber,
    required this.flutterTarget,
  }) : key = nanoid();

  @override
  void delete([bool broadcast = true]) {
    super.delete(broadcast);
    (database as FlutterDatabase).deleteNumberEntry(entry: this);
  }
}
