import 'dart:math';

import 'package:app_0byte/models/conversion_types.dart';

double _log2(num x) => log(x) / log(2);

String converted({
  required String data,
  required ConversionType inputType,
  required int targetSize,
  required ConversionType targetType,
}) {
  bool negativeInput = data.startsWith("-");
  String absData = negativeInput ? data.substring(1) : data;

  // Absolute input to decimal
  num abs = 0;
  for (int i = 0; i < absData.length; ++i) {
    abs += inputType.alphabet.indexOf(absData[absData.length - i - 1]) *
        pow(inputType.base, i);
  }

  // Absolute input decimal to binary
  List<bool> number_bin =
      List.filled(_log2(abs).ceil() + (negativeInput ? 1 : 0), false);

  for (int i = 0; i < number_bin.length; ++i) {
    number_bin[number_bin.length - i - 1] = abs % 2 != 0;
    abs = abs ~/ 2;
  }

  // Negative input => transform binary using 2's complement
  if (negativeInput) {
    for (int i = 0; i < number_bin.length; ++i) {
      number_bin[i] = !number_bin[i];
    }
    bool carry = true;
    int i = number_bin.length - 1;
    while (carry || i > 0) {
      bool tmp = number_bin[i];
      number_bin[i] = tmp ^ carry;
      carry = tmp & carry;
      i--;
    }
  }

  // Base conversion
  bool negativeOutput = false;
  String converted = "";

  // Signed output & negative binary representation => reverse 2's complement
  if (targetType == ConversionType.signedDecimal && number_bin[0]) {
    negativeOutput = true;
    for (int i = 0; i < number_bin.length; ++i) {
      number_bin[i] = !number_bin[i];
    }
    bool carry = true;
    int i = number_bin.length - 1;
    while (carry || i > 0) {
      bool tmp = number_bin[i];
      number_bin[i] = tmp ^ carry;
      carry = tmp & carry;
      i--;
    }
  }

  // Unsigned binary output => decimal
  num number = 0;
  for (int i = 0; i < number_bin.length; ++i) {
    number += number_bin[number_bin.length - i - 1] ? pow(2, i) : 0;
  }

  // Decimal => final base
  for (int i = 0; i < targetSize; ++i) {
    converted =
        targetType.alphabet[(number % targetType.base) as int] + converted;
    number = number ~/ targetType.base;
  }

  // Left trim 0s for decimal and ascii
  if (targetType == ConversionType.signedDecimal ||
      targetType == ConversionType.unsignedDecimal ||
      targetType == ConversionType.ascii) {
    converted =
        converted.replaceFirst(RegExp("^${targetType.alphabet[0]}+"), "");
  }

  return targetType.prefix +
      (negativeOutput && targetType == ConversionType.signedDecimal
          ? "-"
          : "") +
      converted;
}
