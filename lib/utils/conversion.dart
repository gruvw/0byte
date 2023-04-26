import 'dart:math';

import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/parser.dart';
import 'package:app_0byte/utils/transforms.dart';

class ConversionTarget {
  final ConversionType type;
  final Digits digits;

  const ConversionTarget({required this.type, required this.digits});

  ConversionTarget withDigits(Digits digits) =>
      ConversionTarget(type: type, digits: digits);
}

class Converted<N extends Number> implements SeparableDisplay {
  final Number result;
  final Digits digits;
  final bool wasSymmetric;

  Converted._({
    required this.result,
    required this.digits,
    required this.wasSymmetric,
  });

  static Converted<N>? from<N extends Number>({
    required N number,
    required ConversionTarget target,
  }) {
    final parsedNumber = number.parsed();

    if (parsedNumber == null) {
      return null;
    }

    String result = converted(
      inputType: number.type,
      number: parsedNumber,
      targetType: target.type,
      targetSize: target.digits.amount,
    );
    bool wasSymmetric = isSymmetric(
      inputType: number.type,
      number: parsedNumber,
      targetType: target.type,
      result: result,
    );

    return Converted._(
      result: DartNumber(type: target.type, text: result),
      digits: target.digits,
      wasSymmetric: wasSymmetric,
    );
  }

  @override
  String display(bool displaySeparator) {
    final arrow = wasSymmetric
        ? SettingsTheme.symmetricArrow
        : SettingsTheme.nonSymmetricArrow;
    final displayedDigits = wasSymmetric ? "" : " ${digits.amount}";
    final displayedConverted = applyNumberTextDisplay(result, displaySeparator);
    return " $arrow [${result.type.prefix}$displayedDigits]$displayedConverted";
  }
}

String converted({
  required ConversionType inputType,
  required String number,
  required ConversionType targetType,
  required int targetSize,
}) {
  bool negativeInput = splitSign(inputType, number).item1.isNotEmpty;
  String absData = negativeInput ? number.substring(1) : number;

  // Absolute input to decimal
  BigInt abs = BigInt.zero;
  for (int i = 0; i < absData.length; ++i) {
    abs += BigInt.from(
            inputType.alphabet.indexOf(absData[absData.length - i - 1])) *
        BigInt.from(inputType.base).pow(i);
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
    binary[binary.length - i - 1] = (abs % BigInt.two).toInt() != 0;
    abs = abs ~/ BigInt.two;
  }

  // Negative input => transform binary using 2's complement
  if (negativeInput) _twoComplement(binary);

  // Extend sign
  if (negativeInput) {
    int nAdd = (targetSize * _log2(targetType.base)).ceil() - binary.length;
    if (nAdd > 0) {
      binary.insertAll(0, List.filled(nAdd, binary[0]));
    }
  }

  // Base conversion
  bool negativeOutput = targetType == ConversionType.signedDecimal && binary[0];
  String converted = "";

  // Signed output & negative binary representation => reverse 2's complement
  if (negativeOutput) _twoComplement(binary);

  // Unsigned binary output => decimal
  BigInt decimal = BigInt.zero;
  for (int i = 0; i < binary.length; ++i) {
    decimal += binary[binary.length - i - 1] ? BigInt.two.pow(i) : BigInt.zero;
  }

  // Decimal => final base
  BigInt targetBase = BigInt.from(targetType.base);
  for (int i = 0; i < targetSize; ++i) {
    converted = targetType.alphabet[(decimal % targetBase).toInt()] + converted;
    decimal = decimal ~/ targetBase;
  }

  converted = leftTrimmed(targetType, converted);

  return (negativeOutput ? sign : "") + converted;
}

bool isSymmetric({
  required ConversionType inputType,
  required String number,
  required ConversionType targetType,
  required String result,
}) {
  String symmetric = converted(
    number: result,
    targetSize: splitSign(inputType, number).item2.length,
    inputType: targetType,
    targetType: inputType,
  );
  return number == symmetric;
}

double _log2(num x) => log(x) / log(2);

void _twoComplement(List<bool> binary) {
  for (int i = 0; i < binary.length; ++i) {
    binary[i] = !binary[i];
  }

  bool carry = true;
  int i = binary.length - 1;
  while (carry && i >= 0) {
    bool tmp = binary[i];
    binary[i] = tmp ^ carry;
    carry = tmp & carry;
    i--;
  }
}
