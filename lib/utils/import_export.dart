import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

import 'package:app_0byte/global/data_fields.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/utils/validation.dart';

Future<String?> exportCollections() => _saveJson(jsonEncode(
    [for (final c in container.read(collectionsProvider)) c.toJson()]));

Future<String?> exportCollection(Collection collection) async =>
    _saveJson(jsonEncode([collection.toJson()]));

Future<String?> _saveJson(String json) async {
  String fileName =
      "0byte_export_${DateTime.now().millisecondsSinceEpoch}.json";

  if (kIsWeb) {
    String content = base64Encode(utf8.encode(json));
    html.AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", fileName)
      ..click();
    return "downloading (web)";
  }

  if (Platform.isAndroid) {
    await Permission.manageExternalStorage.request();
    PermissionStatus permissionStatus =
        await Permission.manageExternalStorage.status;
    if (!permissionStatus.isGranted) {
      return null;
    }
  }

  String? directory = await FilePicker.platform.getDirectoryPath();
  if (directory == null || directory == "/") {
    return null;
  }
  File file = File("$directory/$fileName")..createSync(recursive: true);
  file.writeAsStringSync(json);

  return file.path;
}

Future<bool?> import() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result == null) {
    return null;
  }

  String content;
  if (kIsWeb) {
    content = utf8.decode(result.files.single.bytes!);
  } else {
    File file = File(result.files.single.path!);
    content = file.readAsStringSync();
  }

  final data = jsonDecode(content); // FIXME try catch
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
    label: uniqueLabel(
        container.read(collectionsProvider).map((c) => c.label).toList(),
        collectionData[CollectionFields.label]),
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
