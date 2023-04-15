// ignore_for_file: constant_identifier_names

import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/parser.dart';
import 'package:app_0byte/utils/validation.dart';

// TODO 0 use new types everywhere

abstract class Number {
  abstract ConversionType type;
  abstract String text;
  String? label;

  String? parsed() => parseText(type, text);

  Converted<Number>? convertTo(ConversionTarget target) {
    return Converted.from(number: this, target: target);
  }

  PotentiallyMutable<Number> toPotentiallyMutable(bool isMutable) {
    return PotentiallyMutable(this, isMutable: isMutable);
  }

  Number withText(String text) {
    return DartNumber(type: type, text: text, label: label);
  }
}

class DartNumber extends Number {
  @override
  // ignore: overridden_fields
  String? label;

  @override
  ConversionType type;

  @override
  String text;

  DartNumber({required this.type, required this.text, this.label});
}

const int _MIN_AMOUNT = 0;
const int _MAX_AMOUNT = 64;

class Digits {
  final int amount;

  Digits._({required this.amount});

  static Digits? fromInt(int amount) {
    if (!(amount >= _MIN_AMOUNT && amount <= _MAX_AMOUNT)) {
      return null;
    }

    return Digits._(amount: amount);
  }
}

final Map<String, ConversionType> _typeFromPrefix =
    Map.fromEntries(ConversionType.values.map((e) => MapEntry(e.prefix, e)));

enum ConversionType {
  hexadecimal("HEX", "0123456789ABCDEF", 8, "0x", 2),
  binary("BIN", "01", 16, "0b", 4),
  unsignedDecimal("DEC", "0123456789", 10, "0d", 3),
  signedDecimal("±DEC", "0123456789", 10, "0s", 3),
  ascii(
    "ASCII",
    "�······························· !\"#\$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~·",
    10,
    "0a",
    -1,
  );

  static bool isValidTypeIndex(int typeIndex) {
    return 0 <= typeIndex && typeIndex < values.length;
  }

  static ConversionType? fromPrefix(String prefix) {
    return _typeFromPrefix[prefix];
  }

  final String label;
  final String alphabet;
  final int base;
  final String prefix;
  final int defaultTargetSize;

  // used for placing _ at correct places (-1 means disabled)
  final int blockLength;

  const ConversionType(
    this.label,
    this.alphabet,
    this.defaultTargetSize,
    this.prefix,
    this.blockLength,
  ) : base = alphabet.length;

  bool get isSeparated => blockLength >= 1;
}
