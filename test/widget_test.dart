// TODO TEST conversion

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_0byte/main.dart';

void main() {
  print(converted(
    data: "100110",
    inputType: ConversionType.binary,
    targetSize: 10,
    targetType: ConversionType.signedDecimal,
  )); // 0s-26
  print(converted(
    data: "-9999990",
    inputType: ConversionType.signedDecimal,
    targetSize: 10,
    targetType: ConversionType.signedDecimal,
  )); // 0s-9999990
  print(converted(
    data: "11111101111101",
    inputType: ConversionType.binary,
    targetSize: 3,
    targetType: ConversionType.ascii,
  )); // 0a~}
  print(converted(
    data: "7D",
    inputType: ConversionType.hexadecimal,
    targetSize: 3,
    targetType: ConversionType.ascii,
  )); // 0a}
  print(converted(
    data: "~",
    inputType: ConversionType.ascii,
    targetSize: 3,
    targetType: ConversionType.signedDecimal,
  )); // 0s-2
}
