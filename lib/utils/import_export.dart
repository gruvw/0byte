import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/utils/validation.dart';

Future<File?> exportCollections() => _saveJson(jsonEncode(
    [for (final c in container.read(collectionsProvider)) c.toJson()]));

Future<File?> exportCollection(Collection collection) async =>
    _saveJson(jsonEncode([collection.toJson()]));

Future<bool?> import() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result == null) {
    return null;
  }
  File file = File(result.files.single.path!); // TODO WEB
  String content = file.readAsStringSync();
  final data = jsonDecode(content);
  if (data is! Iterable) {
    return false;
  }
  bool success = true;
  for (final collectionData in data) {
    bool collectionSuccess = _importCollection(collectionData);
    success = success && collectionSuccess;
  }
  return success;
}

Future<File?> _saveJson(String json) async {
  if (Platform.isAndroid) {
    await Permission.manageExternalStorage.request();
    PermissionStatus permissionStatus =
        await Permission.manageExternalStorage.status;
    if (!permissionStatus.isGranted) {
      return null;
    }
  }
  String? directory =
      await FilePicker.platform.getDirectoryPath(); // TODO support web
  if (directory == null || directory == "/") {
    return null;
  }
  String path =
      "$directory/0byte_export_${DateTime.now().millisecondsSinceEpoch}.json";
  File file = File(path)..createSync(recursive: true);
  file.writeAsStringSync(json);
  return file;
}

bool _importCollection(Map<String, dynamic> collectionData) {
  if (!(collectionData.hasField<String>(CollectionFields.label) &&
      collectionData.hasField<int>(CollectionFields.targetTypeIndex) &&
      ConversionType.isValidTypeIndex(
          collectionData[CollectionFields.targetTypeIndex]) &&
      collectionData.hasField<int>(CollectionFields.targetSize) &&
      0 < collectionData[CollectionFields.targetSize])) {
    return false;
  }
  Collection collection = database.createCollection(
    label: uniqueLabel(collectionData[CollectionFields.label]),
    targetType:
        ConversionType.values[collectionData[CollectionFields.targetTypeIndex]],
    targetSize: collectionData[CollectionFields.targetSize],
  );
  if (!collectionData.hasField<Iterable>(CollectionFields.entries)) {
    return true;
  }
  bool success = true;
  for (final entryData in collectionData[CollectionFields.entries]) {
    bool entrySuccess = _importEntry(collection, entryData);
    success = success && entrySuccess;
  }
  return success;
}

bool _importEntry(Collection collection, Map<String, dynamic> entryData) {
  if (!(entryData.hasField<String>(EntryFields.input) &&
      entryData.hasField<String>(EntryFields.label) &&
      entryData.hasField<int>(EntryFields.typeIndex) &&
      ConversionType.isValidTypeIndex(entryData[EntryFields.typeIndex]) &&
      entryData.hasField<int>(EntryFields.position) &&
      entryData[EntryFields.position] >= 0)) {
    return false;
  }
  database.createNumberEntry(
      collection: collection,
      position: entryData[EntryFields.position],
      type: ConversionType.values[entryData[EntryFields.typeIndex]],
      input: entryData[EntryFields.input],
      label: entryData[EntryFields.label]);
  return true;
}
