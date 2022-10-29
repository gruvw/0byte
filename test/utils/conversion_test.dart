import 'dart:math';

import 'package:app_0byte/utils/input_parsing.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/utils/conversion.dart';

// TODO name tests

void main() {
  test("", () {
    var parsed = parseInput("0b100110")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 10,
      targetType: ConversionType.signedDecimal,
    );
    expect(res, equals("0s-26"));
  });

  test("", () {
    var parsed = parseInput("0s-9999990")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 10,
      targetType: ConversionType.signedDecimal,
    );
    expect(res, equals("0s-9999990"));
  });
  test("", () {
    var parsed = parseInput("0b11111101111101")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.ascii,
    );
    expect(res, "0a~}");
  });
  test("", () {
    var parsed = parseInput("0x7D")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.ascii,
    );
    expect(res, "0a}");
  });
  test("", () {
    var parsed = parseInput("0a~")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.signedDecimal,
    );
    expect(res, "0s-2");
  });
  test("", () {
    var parsed = parseInput("0s10")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 2,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0x0A");
  });
  test("", () {
    var parsed = parseInput("0s-10")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 10,
      targetType: ConversionType.binary,
    );
    expect(res, "0b1111110110");
  });
  test("", () {
    var parsed = parseInput("0s-10")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 8,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0xFFFFFFF6");
  });
  test("", () {
    var parsed = parseInput("0s-1")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 8,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0xFFFFFFFF");
  });
  test("", () {
    var parsed = parseInput("0x25")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.unsignedDecimal,
    );
    expect(res, "0d37");
  });
  test("", () {
    var parsed = parseInput("0x25")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.signedDecimal,
    );
    expect(res, "0s37");
  });
  test("", () {
    var parsed = parseInput("0s37")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0x025");
  });
  test("", () {
    var parsed = parseInput("0d37")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0x025");
  });
  test("", () {
    var parsed = parseInput("0s-37")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 4,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0xFFDB");
  });
  test("", () {
    var parsed = parseInput("0s9")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.signedDecimal,
    );
    expect(res, "0s9");
  });
  test("", () {
    var parsed = parseInput("0d9")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 3,
      targetType: ConversionType.signedDecimal,
    );
    expect(res, "0s-7");
  });
  test("", () {
    var parsed = parseInput("0s-7")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 1,
      targetType: ConversionType.unsignedDecimal,
    );
    expect(res, "0d9");
  });
  test("", () {
    var parsed = parseInput("0s9999999999")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 8,
      targetType: ConversionType.hexadecimal,
    );
    expect(res, "0x540BE3FF");
  });
  test("", () {
    var parsed = parseInput("0s0001")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 8,
      targetType: ConversionType.signedDecimal,
    );
    expect(res, "0s1");
  });
  test("", () {
    var parsed = parseInput("0s-1")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 2,
      targetType: ConversionType.unsignedDecimal,
    );
    expect(res, "0d27");
  });
  test("", () {
    var parsed = parseInput("0s-00001")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 2,
      targetType: ConversionType.unsignedDecimal,
    );
    expect(res, "0d27");
  });
  test("ASCII not negative", () {
    var parsed = parseInput("0a-0")!;
    String res = converted(
      data: parsed.item2,
      inputType: parsed.item1,
      targetSize: 14,
      targetType: ConversionType.binary,
    );
    expect(res, "0b01011010110000");
  });

  group("Random identity conversion", () {
    final Random random = Random();
    const int maxSize = 9; // TODO fix more precision (num)
    const int minSize = 1;
    const int iterations = 10000;
    for (final conversionType in ConversionType.values) {
      test("on ${conversionType.name}", () {
        for (var i = 0; i < iterations; i++) {
          int length = random.nextInt(maxSize - minSize + 1) + minSize;
          String input = conversionType.prefix;
          for (int i = 0; i < length; i++) {
            input += conversionType
                .alphabet[random.nextInt(conversionType.alphabet.length)];
          }
          var parsed = parseInput(input)!;
          String res = converted(
            data: parsed.item2,
            inputType: parsed.item1,
            targetSize: parsed.item2.length,
            targetType: conversionType,
          );
          expect(res, parsed.item1.prefix + parsed.item2);
        }
      });
    }
  });
}
