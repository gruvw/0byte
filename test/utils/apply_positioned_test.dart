import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void testApplyPositioned(
  ConversionType type,
  PositionedText oldValue,
  PositionedText newValue,
  PositionedText expected,
  bool displaySeparator,
) {
  PositionedText actual = applyPositionedText(
    oldValue,
    newValue,
    applyInputFromType(type, displaySeparator),
  );
  expect(actual, expected);
}

void main() {
  group("Display separator enabled", () {
    const displaySeparator = true;
    test("Remove binary prefix", () {
      testApplyPositioned(
        ConversionType.binary,
        PositionedText("01", 1),
        PositionedText("0b1", 2),
        PositionedText("1", 0),
        displaySeparator,
      );
    });
    test("Digit deletion moves separator before position", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 5),
        PositionedText("00_1", 4),
        PositionedText("0_01", 4),
        displaySeparator,
      );
    });
    test("Separator deletion just moves position (after separator)", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 3),
        PositionedText("0011", 2),
        PositionedText("00_11", 2),
        displaySeparator,
      );
    });
    test("Separator deletion just moves position (before separator)", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 2),
        PositionedText("0011", 2),
        PositionedText("00_11", 3),
        displaySeparator,
      );
    });
    test("Digit addition creates correct separator before position", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("01_11", 2),
        PositionedText("011_11", 3),
        PositionedText("0_11_11", 4),
        displaySeparator,
      );
    });
    test("Digit deletion before separator (after digit)", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 2),
        PositionedText("0_11", 1),
        PositionedText("0_11", 1),
        displaySeparator,
      );
    });
    test("Digit deletion before separator (before digit)", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 1),
        PositionedText("0_11", 1),
        PositionedText("0_11", 1),
        displaySeparator,
      );
    });
    test("Digit deletion at start of word", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 1),
        PositionedText("0_11", 0),
        PositionedText("0_11", 0),
        displaySeparator,
      );
    });
    test("Digit deletion at start of word removes separator after cursor", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("0_11", 1),
        PositionedText("_11", 0),
        PositionedText("11", 0),
        displaySeparator,
      );
    });
    test("Text made invalid removes separator after cursor", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 2),
        PositionedText("00z_11", 3),
        PositionedText("00z11", 3),
        displaySeparator,
      );
    });
    test("Text made invalid removes every separator", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11_22", 5),
        PositionedText("00_11z_22", 6),
        PositionedText("0011z22", 5),
        displaySeparator,
      );
    });
    test("Text made invalid removes every separator (binary)", () {
      testApplyPositioned(
        ConversionType.binary,
        PositionedText("10_10_10_11_00", 8),
        PositionedText("10_10_10a_11_00", 9),
        PositionedText("101010a1100", 7),
        displaySeparator,
      );
    });
    test("Paste full hex number", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("", 0),
        PositionedText("0xff_00", 7),
        PositionedText("FF_00", 5),
        displaySeparator,
      );
    });
    test("Add hex prefix at start", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("ff0", 0),
        PositionedText("0xff00", 2),
        PositionedText("FF_00", 0),
        displaySeparator,
      );
    });
    test("Input separator in middle of word", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 1),
        PositionedText("0_0_11", 2),
        PositionedText("00_11", 1),
        displaySeparator,
      );
    });
    test("Input separator at start of word", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 0),
        PositionedText("_00_11", 1),
        PositionedText("00_11", 0),
        displaySeparator,
      );
    });
    test("Input separator next to separator", () {
      testApplyPositioned(
        ConversionType.hexadecimal,
        PositionedText("00_11", 3),
        PositionedText("00__11", 4),
        PositionedText("00_11", 3),
        displaySeparator,
      );
    });
    test("ASCII don't separate", () {
      testApplyPositioned(
        ConversionType.ascii,
        PositionedText("abcdefghijklmnop...", 3),
        PositionedText("abczdefghijklmnop...", 4),
        PositionedText("abczdefghijklmnop...", 4),
        displaySeparator,
      );
    });
    test("Decimal separation (unsigned)", () {
      testApplyPositioned(
        ConversionType.unsignedDecimal,
        PositionedText("12346789", 4),
        PositionedText("123456789", 5),
        PositionedText("123_456_789", 6),
        displaySeparator,
      );
    });
    test("Decimal separation (signed)", () {
      testApplyPositioned(
        ConversionType.signedDecimal,
        PositionedText("-12346789", 5),
        PositionedText("-123456789", 6),
        PositionedText("-123_456_789", 7),
        displaySeparator,
      );
    });
    test("Small signed decimal", () {
      testApplyPositioned(
        ConversionType.signedDecimal,
        PositionedText("-1", 2),
        PositionedText("-12", 3),
        PositionedText("-12", 3),
        displaySeparator,
      );
    });
    test("Medium signed decimal", () {
      testApplyPositioned(
        ConversionType.signedDecimal,
        PositionedText("-12", 2),
        PositionedText("-112", 3),
        PositionedText("-112", 3),
        displaySeparator,
      );
    });
    test("Separated first signed decimal", () {
      testApplyPositioned(
        ConversionType.signedDecimal,
        PositionedText("-112", 2),
        PositionedText("-1112", 3),
        PositionedText("-1_112", 4),
        displaySeparator,
      );
    });
  });

  group("Display Separator disabled", () {
    const displaySeparator = false;
    test("Binary identity", () {
      testApplyPositioned(
        ConversionType.binary,
        PositionedText("0011", 2),
        PositionedText("0011", 2),
        PositionedText("0011", 2),
        displaySeparator,
      );
    });
    test("Remove unused separator", () {
      testApplyPositioned(
        ConversionType.binary,
        PositionedText("00_11", 3),
        PositionedText("00_11", 3),
        PositionedText("0011", 2),
        displaySeparator,
      );
    });
    test("Full binary paste", () {
      testApplyPositioned(
        ConversionType.binary,
        PositionedText("", 0),
        PositionedText("0b00_11", 7),
        PositionedText("0011", 4),
        displaySeparator,
      );
    });
  });
}
