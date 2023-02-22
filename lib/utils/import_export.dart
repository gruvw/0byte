import 'dart:convert';
import 'dart:io';

import 'package:app_0byte/models/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> exportCollection(Collection collection) async {
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
  String filePath =
      "$directory/0byte_export_${DateTime.now().millisecondsSinceEpoch}.json";
  String export = jsonEncode([collection.toJson()]);
  File file = File(filePath)..createSync(recursive: true);
  file.writeAsStringSync(export);
  return file;
}
