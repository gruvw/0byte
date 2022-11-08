import 'dart:math';

import 'package:app_0byte/utils/input_parsing.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/utils/conversion.dart';

// TODO test with symmetric

void main() {
  test("Binary to signed", () {
    String res = converted(
      inputType: ConversionType.binary,
      number: parseInput(ConversionType.binary, "100110")!,
      targetType: ConversionType.signedDecimal,
      targetSize: 10,
    );
    expect(res, equals("-26"));
  });

  test("Large signed negative identity", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-9999990")!,
      targetType: ConversionType.signedDecimal,
      targetSize: 10,
    );
    expect(res, equals("-9999990"));
  });
  test("Binary to ASCII", () {
    String res = converted(
      inputType: ConversionType.binary,
      number: parseInput(ConversionType.binary, "11111101111101")!,
      targetType: ConversionType.ascii,
      targetSize: 3,
    );
    expect(res, "~}");
  });
  test("Hexadecimal to ASCII", () {
    String res = converted(
      inputType: ConversionType.hexadecimal,
      number: parseInput(ConversionType.hexadecimal, "7D")!,
      targetType: ConversionType.ascii,
      targetSize: 3,
    );
    expect(res, "}");
  });
  test("ASCII as signed", () {
    String res = converted(
      inputType: ConversionType.ascii,
      number: parseInput(ConversionType.ascii, "~")!,
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
    );
    expect(res, "-2");
  });
  test("Small hexadecimal from signed", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "10")!,
      targetSize: 2,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0A");
  });
  test("Signed to binary", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-10")!,
      targetType: ConversionType.binary,
      targetSize: 10,
    );
    expect(res, "1111110110");
  });
  test("Signed to hexadecimal", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-10")!,
      targetType: ConversionType.hexadecimal,
      targetSize: 8,
    );
    expect(res, "FFFFFFF6");
  });
  test("-1 to hexadecimal", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-1")!,
      targetType: ConversionType.hexadecimal,
      targetSize: 8,
    );
    expect(res, "FFFFFFFF");
  });
  test("Hexadecimal to unsigned", () {
    String res = converted(
      inputType: ConversionType.hexadecimal,
      number: parseInput(ConversionType.hexadecimal, "25")!,
      targetType: ConversionType.unsignedDecimal,
      targetSize: 3,
    );
    expect(res, "37");
  });
  test("Hexadecimal to signed", () {
    String res = converted(
      inputType: ConversionType.hexadecimal,
      number: parseInput(ConversionType.hexadecimal, "25")!,
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
    );
    expect(res, "37");
  });
  test("Signed to hexadecimal padded", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "37")!,
      targetType: ConversionType.hexadecimal,
      targetSize: 3,
    );
    expect(res, "025");
  });
  test("Unsigned to hexadecimal padded", () {
    String res = converted(
      inputType: ConversionType.unsignedDecimal,
      number: parseInput(ConversionType.unsignedDecimal, "37")!,
      targetType: ConversionType.hexadecimal,
      targetSize: 3,
    );
    expect(res, "025");
  });
  test("Signed negative to hexadecimal", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-37")!,
      targetType: ConversionType.hexadecimal,
      targetSize: 4,
    );
    expect(res, "FFDB");
  });
  test("Signed identity", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "9")!,
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
    );
    expect(res, "9");
  });
  test("Unsigned to signed ?", () {
    String res = converted(
      inputType: ConversionType.unsignedDecimal,
      number: parseInput(ConversionType.unsignedDecimal, "9")!,
      targetType: ConversionType.signedDecimal,
      targetSize: 3,
    );
    expect(res, "-7");
  });
  test("Signed to unsigned ?", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-7")!,
      targetType: ConversionType.unsignedDecimal,
      targetSize: 1,
    );
    expect(res, "9");
  });
  test("Large signed to hexadecimal", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "9999999999")!,
      targetType: ConversionType.hexadecimal,
      targetSize: 8,
    );
    expect(res, "540BE3FF");
  });
  test("Padded signed identity", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "0001")!,
      targetType: ConversionType.signedDecimal,
      targetSize: 8,
    );
    expect(res, "1");
  });
  test("-1 to unsigned", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-1")!,
      targetType: ConversionType.unsignedDecimal,
      targetSize: 2,
    );
    expect(res, "27");
  });
  test("Padded -1 to unsigned", () {
    String res = converted(
      inputType: ConversionType.signedDecimal,
      number: parseInput(ConversionType.signedDecimal, "-00001")!,
      targetType: ConversionType.unsignedDecimal,
      targetSize: 2,
    );
    expect(res, "27");
  });
  test("ASCII not using sign", () {
    String res = converted(
      inputType: ConversionType.ascii,
      number: parseInput(ConversionType.ascii, "-0")!,
      targetType: ConversionType.binary,
      targetSize: 14,
    );
    expect(res, "01011010110000");
  });

  group("Random identity conversion", () {
    final Random random = Random();
    const int maxSize = 100;
    const int minSize = 1;
    const int iterations = 10000;
    for (final conversionType in ConversionType.values) {
      test("on ${conversionType.name}", () {
        for (var i = 0; i < iterations; i++) {
          int length = random.nextInt(maxSize - minSize + 1) + minSize;
          String input = "";
          for (int i = 0; i < length; i++) {
            input += conversionType
                .alphabet[random.nextInt(conversionType.alphabet.length)];
          }
          String number = parseInput(conversionType, input)!;
          String res = converted(
            inputType: conversionType,
            number: number,
            targetType: conversionType,
            targetSize: number.length,
          );
          expect(res, number);
        }
      });
    }
  });
}
