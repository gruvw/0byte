import 'dart:math';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/utils/input_parsing.dart';

String converted({
  required String data,
  required ConversionType inputType,
  required int targetSize,
  required ConversionType targetType,
}) {
  bool negativeInput =
      data.startsWith(sign) && inputType == ConversionType.signedDecimal;
  String absData = negativeInput ? data.substring(1) : data;

  // Absolute input to decimal
  num abs = 0;
  for (int i = 0; i < absData.length; ++i) {
    abs += inputType.alphabet.indexOf(absData[absData.length - i - 1]) *
        pow(inputType.base, i);
  }

  // Absolute input decimal to binary
  List<bool> binary = List.filled(
      (absData.length * _log2(inputType.base)).ceil() +
          (inputType == ConversionType.signedDecimal &&
                  targetType == ConversionType.signedDecimal
              ? 1
              : 0),
      false,
      growable: true);

  for (int i = 0; i < binary.length; ++i) {
    binary[binary.length - i - 1] = abs % 2 != 0;
    abs = abs ~/ 2;
  }

  // Negative input => transform binary using 2's complement
  if (negativeInput) _twoComplement(binary);

  // Extend sign
  if (negativeInput) {
    int n_add = (targetSize * _log2(targetType.base)).ceil() - binary.length;
    if (n_add > 0) {
      binary.insertAll(0, List.filled(n_add, binary[0]));
    }
  }

  // Base conversion
  bool negativeOutput = targetType == ConversionType.signedDecimal && binary[0];
  String converted = "";

  // Signed output & negative binary representation => reverse 2's complement
  if (negativeOutput) _twoComplement(binary);

  // Unsigned binary output => decimal
  num number = 0;
  for (int i = 0; i < binary.length; ++i) {
    number += binary[binary.length - i - 1] ? pow(2, i) : 0;
  }

  // Decimal => final base
  for (int i = 0; i < targetSize; ++i) {
    converted =
        targetType.alphabet[(number % targetType.base) as int] + converted;
    number = number ~/ targetType.base;
  }

  converted = leftTrimmed(converted, targetType);

  return targetType.prefix + (negativeOutput ? sign : "") + converted;
}

double _log2(num x) => log(x) / log(2);

void _twoComplement(List<bool> binary) {
  for (int i = 0; i < binary.length; ++i) {
    binary[i] = !binary[i];
  }

  bool carry = true;
  int i = binary.length - 1;
  while (carry && i > 0) {
    bool tmp = binary[i];
    binary[i] = tmp ^ carry;
    carry = tmp & carry;
    i--;
  }
}