import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';

import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/utils/transforms.dart';

const _positionChar = "|";

Tuple2<ConversionType, PositionedText> _positionedFromReadable(
    String readable) {
  String positionText = readable.substring(2);
  return Tuple2(
      ConversionType.fromPrefix(readable.substring(0, 2))!,
      PositionedText(
        positionText.replaceAll(_positionChar, ""),
        positionText.indexOf(_positionChar),
      ));
}

void testApplyPositioned(
  bool displaySeparator,
  String oldReadable,
  String newReadable,
  String expectedReadable,
) {
  final oldValue = _positionedFromReadable(oldReadable);
  PositionedText actual = applyNumberPositionedText(
    oldValue.item2,
    _positionedFromReadable(newReadable).item2,
    oldValue.item1,
    displaySeparator,
  );
  expect(actual, _positionedFromReadable(expectedReadable).item2);
}

void main() {
  group("Display separator enabled", () {
    const displaySeparator = true;
    test("Remove binary prefix", () {
      testApplyPositioned(displaySeparator, "0b0|1", "0b0b|1", "0b|1");
    });
    test("Digit deletion moves separator before position", () {
      testApplyPositioned(displaySeparator, "0x00_11|", "0x00_1|", "0x0_01|");
    });
    test("Separator deletion just moves position (after separator)", () {
      testApplyPositioned(displaySeparator, "0x00_|11", "0x00|11", "0x00|_11");
    });
    test("Separator deletion just moves position (before separator)", () {
      testApplyPositioned(displaySeparator, "0x00|_11", "0x00|11", "0x00_|11");
    });
    test("Digit addition creates correct separator before position", () {
      testApplyPositioned(
          displaySeparator, "0x01|_11", "0x011|_11", "0x0_11|_11");
    });
    test("Digit deletion before separator (after digit)", () {
      testApplyPositioned(displaySeparator, "0x00|_11", "0x0|_11", "0x0|_11");
    });
    test("Digit deletion before separator (before digit)", () {
      testApplyPositioned(displaySeparator, "0x0|0_11", "0x0|_11", "0x0|_11");
    });
    test("Digit deletion at start of word", () {
      testApplyPositioned(displaySeparator, "0x0|0_11", "0x|0_11", "0x|0_11");
    });
    test("Digit deletion at start of word removes separator after cursor", () {
      testApplyPositioned(displaySeparator, "0x0|_11", "0x|_11", "0x|11");
    });
    test("Text made invalid removes separator after cursor", () {
      testApplyPositioned(
          displaySeparator, "0x00|_11", "0x00z|_11", "0x00z|11");
    });
    test("Text made invalid removes every separator", () {
      testApplyPositioned(
          displaySeparator, "0x00_11|_22", "0x00_11z|_22", "0x0011z|22");
    });
    test("Text made invalid removes every separator (binary)", () {
      testApplyPositioned(displaySeparator, "0b10_10_10|_11_00",
          "0b10_10_10a|_11_00", "0b101010a|1100");
    });
    test("Paste full hex number", () {
      testApplyPositioned(displaySeparator, "0x|", "0x0xff_00|", "0xFF_00|");
    });
    test("Add hex prefix at start", () {
      testApplyPositioned(displaySeparator, "0x|ff00", "0x0x|ff00", "0x|FF_00");
    });
    test("Input separator in middle of word", () {
      testApplyPositioned(
          displaySeparator, "0x0|0_11", "0x0_|0_11", "0x0|0_11");
    });
    test("Input separator at start of word", () {
      testApplyPositioned(
          displaySeparator, "0x|00_11", "0x_|00_11", "0x|00_11");
    });
    test("Input separator next to separator", () {
      testApplyPositioned(
          displaySeparator, "0x00_|11", "0x00__|11", "0x00_|11");
    });
    test("ASCII don't separate", () {
      testApplyPositioned(displaySeparator, "0aabc|defghijklmnop...",
          "0aabcz|defghijklmnop...", "0aabcz|defghijklmnop...");
    });
    test("ASCII don't use separator", () {
      testApplyPositioned(displaySeparator, "0a|", "0a_|", "0a_|");
    });
    test("Decimal separation (unsigned)", () {
      testApplyPositioned(
          displaySeparator, "0d1234|6789", "0d12345|6789", "0d123_45|6_789");
    });
    test("Decimal separation (signed)", () {
      testApplyPositioned(
          displaySeparator, "0s-1234|6789", "0s-12345|6789", "0s-123_45|6_789");
    });
    test("Small signed decimal", () {
      testApplyPositioned(displaySeparator, "0s-1|", "0s-12|", "0s-12|");
    });
    test("Medium signed decimal", () {
      testApplyPositioned(displaySeparator, "0s-1|2", "0s-11|2", "0s-11|2");
    });
    test("Separated first signed decimal", () {
      testApplyPositioned(displaySeparator, "0s-1|12", "0s-11|12", "0s-1_1|12");
    });
    test("Alone separator addition", () {
      testApplyPositioned(displaySeparator, "0s|", "0s_|", "0s_|");
    });
    test("Alone separator addition (signed)", () {
      testApplyPositioned(displaySeparator, "0s-|", "0s-_|", "0s-_|");
    });
  });

  group("Additional usage tests", () {
    const displaySeparator = true;
    test("Prepend moves position before separator", () {
      testApplyPositioned(displaySeparator, "0x|11", "0x0|11", "0x0|_11");
    });
    test("Middle word deletion should stay between separators", () {
      testApplyPositioned(
          displaySeparator, "0x01_11|_11", "0x01_1|_11", "0x0_11|_11");
    });
    test("Middle word deletion should respect separator groups reduction", () {
      testApplyPositioned(
          displaySeparator, "0x0_11|_11", "0x0_1|_11", "0x01|_11");
    });
    test("Invalid letter addition", () {
      testApplyPositioned(
          displaySeparator, "0x0z|FF1", "0x0zF|FF1", "0x0zF|FF1");
    });
    test("Invalid letter addition with separators after position", () {
      testApplyPositioned(
          displaySeparator, "0x0z|FF__1", "0x0zF|FF__1", "0x0zF|FF__1");
    });
    test("Invalid letter deletion", () {
      testApplyPositioned(
          displaySeparator, "0x0zF|FF1", "0x0z|FF1", "0x0z|FF1");
    });
    test("Made invalid at position 1", () {
      testApplyPositioned(
          displaySeparator, "0x0|0_FF_F1", "0x0z|0_FF_F1", "0x0z|0FFF1");
    });
    test("Made valid again (after)", () {
      testApplyPositioned(displaySeparator, "0x0z|FF1", "0x0|FF1", "0x0|F_F1");
    });
    test("Made valid again (before)", () {
      testApplyPositioned(displaySeparator, "0x0|zFF1", "0x0|FF1", "0x0|F_F1");
    });
    test("Added digit correct separator side (after)", () {
      testApplyPositioned(
          displaySeparator, "0x0|_FF_01", "0x0F|_FF_01", "0x0F|_FF_01");
    });
    test("Added digit correct separator side (after)", () {
      testApplyPositioned(
          displaySeparator, "0x0_|FF_01", "0x0_F|FF_01", "0x0F|_FF_01");
    });
    test("Added digit correct separator side (lower)", () {
      testApplyPositioned(displaySeparator, "0x0_11|_11_11", "0x0_11a|_11_11",
          "0x01_1A|_11_11");
    });
    test("Added digit correct separator side (lower)", () {
      testApplyPositioned(displaySeparator, "0x0_11|_11_11", "0x0_11a|_11_11",
          "0x01_1A|_11_11");
    });
    test("Added digit correct separator side (upper)", () {
      testApplyPositioned(displaySeparator, "0x0_11|_11_11", "0x0_11A|_11_11",
          "0x01_1A|_11_11");
    });
  });

  group("Display Separator disabled", () {
    const displaySeparator = false;
    test("Binary identity", () {
      testApplyPositioned(displaySeparator, "0b00|11", "0b00|11", "0b00|11");
    });
    test("Remove unused separator", () {
      testApplyPositioned(displaySeparator, "0b00_|11", "0b00_|11", "0b00|11");
    });
    test("Full binary paste", () {
      testApplyPositioned(displaySeparator, "0b|", "0b0b00_11|", "0b0011|");
    });
  });
}
