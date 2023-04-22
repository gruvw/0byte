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
import 'package:app_0byte/utils/conversion.dart';
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
  if (!collectionData.hasField<String>(CollectionFields.label)) {
    return false;
  }

  Collection collection = database.createCollection(
    label: uniqueLabel(
        container.read(collectionsProvider).map((c) => c.label).toList(),
        collectionData[CollectionFields.label]),
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
  if (!(entryData.hasField<int>(EntryFields.position) &&
      entryData[EntryFields.position] >= 0 &&
      entryData.hasField<String>(EntryFields.label) &&
      entryData.hasField<int>(EntryFields.typeIndex) &&
      ConversionType.isValidTypeIndex(entryData[EntryFields.typeIndex]) &&
      entryData.hasField<String>(EntryFields.text) &&
      entryData.hasField<int>(EntryFields.targetTypeIndex) &&
      ConversionType.isValidTypeIndex(entryData[EntryFields.targetTypeIndex]) &&
      entryData.hasField<String>(EntryFields.targetDigitsAmount) &&
      Digits.isValidAmount(entryData[EntryFields.targetDigitsAmount]))) {
    return false;
  }

  database.createNumberConversionEntry(
    collection: collection,
    position: entryData[EntryFields.position],
    label: entryData[EntryFields.label],
    number: DartNumber(
      type: ConversionType.values[entryData[EntryFields.typeIndex]],
      text: entryData[EntryFields.text],
    ),
    target: ConversionTarget(
      type: ConversionType.values[entryData[EntryFields.targetTypeIndex]],
      digits: Digits.fromInt(entryData[EntryFields.targetDigitsAmount])!,
    ),
  );

  return true;
}
