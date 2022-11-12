import 'package:flutter/material.dart';

import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/models/database.dart';

abstract class NumberEntry extends DatabaseObject {
  @protected
  abstract final int typeIndex;
  late final ConversionType type = ConversionType.values[typeIndex];

  abstract final Collection collection;

  abstract String input;
  abstract String label;
  abstract int position;

  void delete();
}
