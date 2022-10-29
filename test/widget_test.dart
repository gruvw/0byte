import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_0byte/main.dart';

// TODO TEST conversion (write as test)
// TODO random number identity conversion testing for every type

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
  print(converted(
    data: "10",
    inputType: ConversionType.signedDecimal,
    targetSize: 2,
    targetType: ConversionType.hexadecimal,
  )); // 0A
  print(converted(
    data: "-10",
    inputType: ConversionType.signedDecimal,
    targetSize: 10,
    targetType: ConversionType.binary,
  )); // 0b1111110110
  print(converted(
    data: "-10",
    inputType: ConversionType.signedDecimal,
    targetSize: 8,
    targetType: ConversionType.hexadecimal,
  )); // 0xFFFFFFF6
  print(converted(
    data: "-1",
    inputType: ConversionType.signedDecimal,
    targetSize: 8,
    targetType: ConversionType.hexadecimal,
  )); // 0xFFFFFFFF
  print(converted(
    data: "25",
    inputType: ConversionType.hexadecimal,
    targetSize: 3,
    targetType: ConversionType.unsignedDecimal,
  )); // 0d37
  print(converted(
    data: "25",
    inputType: ConversionType.hexadecimal,
    targetSize: 3,
    targetType: ConversionType.signedDecimal,
  )); // 0s37
  print(converted(
    data: "37",
    inputType: ConversionType.signedDecimal,
    targetSize: 3,
    targetType: ConversionType.hexadecimal,
  )); // 0x025
  print(converted(
    data: "37",
    inputType: ConversionType.unsignedDecimal,
    targetSize: 3,
    targetType: ConversionType.hexadecimal,
  )); // 0x025
  print(converted(
    data: "-37",
    inputType: ConversionType.signedDecimal,
    targetSize: 4,
    targetType: ConversionType.hexadecimal,
  )); // 0xFFDB
  print(converted(
    data: "9",
    inputType: ConversionType.signedDecimal,
    targetSize: 3,
    targetType: ConversionType.signedDecimal,
  )); // 0s9
  print(converted(
    data: "9",
    inputType: ConversionType.unsignedDecimal,
    targetSize: 3,
    targetType: ConversionType.signedDecimal,
  )); // 0s-7
  print(converted(
    data: "-7",
    inputType: ConversionType.signedDecimal,
    targetSize: 1,
    targetType: ConversionType.unsignedDecimal,
  )); // 0d9
  print(converted(
    data: "9999999999",
    inputType: ConversionType.signedDecimal,
    targetSize: 8,
    targetType: ConversionType.hexadecimal,
  )); // 0x540BE3FF
  print(converted(
    data: "0001",
    inputType: ConversionType.signedDecimal,
    targetSize: 8,
    targetType: ConversionType.signedDecimal,
  )); // 0s1
}
