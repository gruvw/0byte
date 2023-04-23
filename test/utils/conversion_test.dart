import 'dart:math';

import 'package:app_0byte/utils/parser.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';

void testConvert({
  required ConversionType inputType,
  required String text,
  required ConversionType targetType,
  required int targetSize,
  required String expectedOutput,
  bool shouldBeSymmetric = true,
}) {
  String number = parseText(inputType, text)!;
  String res = converted(
    inputType: inputType,
    number: number,
    targetType: targetType,
    targetSize: targetSize,
  );

  String reason =
      "value:${inputType.prefix}$text, targetType:${targetType.label}, targetSize:$targetSize";
  expect(res, equals(expectedOutput), reason: reason);
  expect(
    isSymmetric(
      inputType: inputType,
      number: number,
      targetType: targetType,
      result: res,
    ),
    shouldBeSymmetric,
    reason: reason,
  );
}

void main() {
  test("Binary to signed", () {
    testConvert(
      inputType: ConversionType.binary,
      text: "100110",
      targetType: ConversionType.signedDecimal,
      targetSize: 10,
      expectedOutput: "-26",
    );
  });
  test("Large signed negative identity", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-9999990",
      targetType: ConversionType.signedDecimal,
      targetSize: 10,
      expectedOutput: "-9999990",
    );
  });
  test("Binary to ASCII", () {
    testConvert(
      inputType: ConversionType.binary,
      text: "11111101111101",
      targetType: ConversionType.ascii,
      targetSize: 3,
      expectedOutput: "~}",
    );
  });
  test("Hexadecimal to ASCII", () {
    testConvert(
      inputType: ConversionType.hexadecimal,
      text: "7D",
      targetType: ConversionType.ascii,
      targetSize: 3,
      expectedOutput: "}",
    );
  });
  test("ASCII as signed", () {
    testConvert(
      inputType: ConversionType.ascii,
      text: "~",
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
      expectedOutput: "-2",
    );
  });
  test("Small hexadecimal from signed", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "10",
      targetType: ConversionType.hexadecimal,
      targetSize: 2,
      expectedOutput: "0A",
    );
  });
  test("Signed to binary", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-10",
      targetType: ConversionType.binary,
      targetSize: 10,
      expectedOutput: "1111110110",
    );
  });
  test("Signed to hexadecimal", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-10",
      targetType: ConversionType.hexadecimal,
      targetSize: 8,
      expectedOutput: "FFFFFFF6",
    );
  });
  test("-1 to hexadecimal", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-1",
      targetType: ConversionType.hexadecimal,
      targetSize: 8,
      expectedOutput: "FFFFFFFF",
    );
  });
  test("Hexadecimal to unsigned", () {
    testConvert(
      inputType: ConversionType.hexadecimal,
      text: "25",
      targetType: ConversionType.unsignedDecimal,
      targetSize: 3,
      expectedOutput: "37",
    );
  });
  test("Hexadecimal to signed", () {
    testConvert(
      inputType: ConversionType.hexadecimal,
      text: "25",
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
      expectedOutput: "37",
    );
  });
  test("Signed to hexadecimal padded", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "37",
      targetType: ConversionType.hexadecimal,
      targetSize: 3,
      expectedOutput: "025",
    );
  });
  test("Unsigned to hexadecimal padded", () {
    testConvert(
      inputType: ConversionType.unsignedDecimal,
      text: "37",
      targetType: ConversionType.hexadecimal,
      targetSize: 3,
      expectedOutput: "025",
    );
  });
  test("Signed negative to hexadecimal", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-37",
      targetType: ConversionType.hexadecimal,
      targetSize: 4,
      expectedOutput: "FFDB",
    );
  });
  test("Signed identity", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "9",
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
      expectedOutput: "9",
    );
  });
  test("Unsigned to signed ?", () {
    testConvert(
      inputType: ConversionType.unsignedDecimal,
      text: "9",
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
      expectedOutput: "-7",
    );
  });
  test("Signed to unsigned ?", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-7",
      targetType: ConversionType.unsignedDecimal,
      targetSize: 1,
      expectedOutput: "9",
    );
  });
  test("Large signed to hexadecimal", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "9999999999",
      targetType: ConversionType.hexadecimal,
      targetSize: 8,
      expectedOutput: "540BE3FF",
      shouldBeSymmetric: false,
    );
  });
  test("Padded signed identity", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "0001",
      targetType: ConversionType.signedDecimal,
      targetSize: 8,
      expectedOutput: "1",
    );
  });
  test("-1 to unsigned", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-1",
      targetType: ConversionType.unsignedDecimal,
      targetSize: 2,
      expectedOutput: "27",
      shouldBeSymmetric: false,
    );
  });
  test("Padded -1 to unsigned", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-00001",
      targetType: ConversionType.unsignedDecimal,
      targetSize: 2,
      expectedOutput: "27",
      shouldBeSymmetric: false,
    );
  });
  test("ASCII not using sign", () {
    testConvert(
      inputType: ConversionType.ascii,
      text: "-0",
      targetType: ConversionType.binary,
      targetSize: 14,
      expectedOutput: "01011010110000",
    );
  });
  test("-8 to bin", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-8",
      targetType: ConversionType.binary,
      targetSize: 6,
      expectedOutput: "111000",
    );
  });
  test("-64 to bin", () {
    testConvert(
      inputType: ConversionType.signedDecimal,
      text: "-64",
      targetType: ConversionType.binary,
      targetSize: 8,
      expectedOutput: "11000000",
    );
  });

  group("Random identity conversion", () {
    final Random random = Random();
    const int maxSize = 100;
    const int minSize = 1;
    const int iterations = 20000;
    for (final conversionType in ConversionType.values) {
      test("on ${conversionType.name}", () {
        for (var i = 0; i < iterations; i++) {
          int length = random.nextInt(maxSize - minSize + 1) + minSize;
          String text = "";
          for (int i = 0; i < length; i++) {
            text += conversionType
                .alphabet[random.nextInt(conversionType.alphabet.length)];
          }
          String number = parseText(conversionType, text)!;
          testConvert(
            inputType: conversionType,
            text: text,
            targetType: conversionType,
            targetSize: length,
            expectedOutput: number,
          );
        }
      });
    }
  });
}
