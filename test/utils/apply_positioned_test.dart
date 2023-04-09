import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void testApplyPositioned(
  ConversionType type,
  PositionedText oldValue,
  PositionedText newValue,
  PositionedText expected,
) {
  PositionedText actual = applyPositionedText(
    oldValue,
    newValue,
    applyInputFromType(type),
  );
  expect(actual, expected);
}

// TODO names
// TODO add signed decimal tests
// TODO add ASCII tests
// TODO add more valid to invalid input tests

void main() {
  test("Test 1", () {
    testApplyPositioned(
      ConversionType.binary,
      PositionedText("01", 1),
      PositionedText("0b1", 2),
      PositionedText("1", 0),
    );
  });
  test("Test 2", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 5),
      PositionedText("00_1", 4),
      PositionedText("0_01", 3),
    );
  });
  test("Test 3", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 3),
      PositionedText("0011", 2),
      PositionedText("00_11", 2),
    );
  });
  test("Test 4", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 2),
      PositionedText("0011", 2),
      PositionedText("00_11", 3),
    );
  });
  test("Test 5", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("01_11", 2),
      PositionedText("011_11", 3),
      PositionedText("0_11_11", 4),
    );
  });
  test("Test 6", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 2),
      PositionedText("0_11", 1),
      PositionedText("0_11", 1),
    );
  });
  test("Test 7", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 1),
      PositionedText("0_11", 0),
      PositionedText("0_11", 0),
    );
  });
  test("Test 8", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("0_11", 1),
      PositionedText("_11", 0),
      PositionedText("11", 0),
    );
  });
  test("Test 9", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 2),
      PositionedText("00z_11", 3),
      PositionedText("00z11", 3),
    );
  });
  test("Test 10", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("", 0),
      PositionedText("0xff_00", 7),
      PositionedText("FF_00", 5),
    );
  });
  test("Test 11", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("ff0", 0),
      PositionedText("0xff00", 2),
      PositionedText("FF_00", 0),
    );
  });
  test("Test 12", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 1),
      PositionedText("0_0_11", 2),
      PositionedText("00_11", 1),
    );
  });
  test("Test 13", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("0011", 0),
      PositionedText("_0011", 1),
      PositionedText("00_11", 0),
    );
  });
  test("Test 14", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 3),
      PositionedText("00__11", 4),
      PositionedText("00_11", 3),
    );
  });
  test("Test 15", () {
    testApplyPositioned(
      ConversionType.hexadecimal,
      PositionedText("00_11", 1),
      PositionedText("0_11", 1),
      PositionedText("0_11", 1),
    );
  });
}
