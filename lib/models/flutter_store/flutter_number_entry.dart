import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/providers/providers.dart';

class FlutterUserEntry extends UserEntry {
  @override
  String input;
  @override
  String? label;

  FlutterUserEntry({required this.input, required this.label});

  @override
  void delete() {
    database.deleteUserEntry(entry: this);
  }
}
