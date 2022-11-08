import 'package:flutter/material.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';

abstract class UserEntry extends DatabaseObject {
  @protected
  abstract final int typeIndex;
  late final ConversionType type = ConversionType.values[typeIndex];

  abstract String input;
  abstract String label;

  void delete();
}
