import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/database.dart';
import 'package:app_0byte/models/flutter_store/flutter_collection.dart';
import 'package:app_0byte/models/flutter_store/flutter_number_conversion_entry.dart';
import 'package:app_0byte/models/flutter_store/flutter_application_settings.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';

class FlutterDatabase extends Database {
  final List<FlutterCollection> _collections = [];
  late final FlutterApplicationSettings settings = FlutterApplicationSettings(
    database: this,
    flutterDisplaySeparators: true,
    flutterDisplayTrimConvertedLeadingZeros: true,
    flutterExportSeparators: true,
    flutterExportTrimConvertedLeadingZeros: true,
    flutterExportUseASCIIControl: true,
  );

  FlutterDatabase();

  @override
  NumberConversionEntry createNumberConversionEntry({
    required Collection collection,
    required int position,
    required String label,
    required Number number,
    required ConversionTarget target,
  }) {
    FlutterNumberConversionEntry entry = FlutterNumberConversionEntry(
      database: this,
      collection: collection,
      flutterPosition: position,
      flutterLabel: label,
      flutterNumber: number,
      flutterTarget: target,
    );
    collection.entries.add(entry);
    collection.notify(EventType.edit);
    return entry;
  }

  @override
  Collection createCollection({
    required String label,
  }) {
    FlutterCollection collection = FlutterCollection(
      database: this,
      flutterLabel: label,
    );
    _collections.add(collection);
    collection.notify(EventType.create);
    return collection;
  }

  void deleteNumberEntry({required NumberConversionEntry entry}) {
    entry.collection.entries.remove(entry);
    entry.collection.notify(EventType.delete);
  }

  void deleteCollection({required FlutterCollection collection}) {
    _collections.remove(collection);
    collection.notify(EventType.delete);
  }

  @override
  List<Collection> getCollections() {
    return List.unmodifiable(_collections..sort((a, b) => a.label.compareTo(b.label)));
  }

  @override
  FlutterApplicationSettings getSettings() => settings;
}
