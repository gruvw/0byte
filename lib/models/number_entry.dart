import 'package:app_0byte/models/database.dart';

abstract class UserEntry extends DatabaseObject {
  abstract String input;
  abstract String label;

  void delete();
}
