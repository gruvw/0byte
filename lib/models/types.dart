import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/input_parsing.dart';
import 'package:app_0byte/utils/validation.dart';

// TODO use new types everywhere

abstract class Number {
  abstract ConversionType type;
  abstract String text;
  String? label;

  String? parsed() => parseInput(type, text);

  Converted<Number>? convertTo(ConversionTarget target) {
    return Converted.from(number: this, target: target);
  }

  Editable<Number> toEditable([bool isEditable = true]) {
    return Editable(this, isEditable: isEditable);
  }

  Number withText(String text) {
    return DartNumber(type: type, text: text, label: label);
  }
}

class DartNumber extends Number {
  @override
  String? label;

  @override
  final ConversionType type;

  @override
  set type(ConversionType _) => throw UnimplementedError();

  @override
  final String text;
  @override
  set text(String _) => throw UnimplementedError();

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
  hexadecimal("HEX", "0123456789ABCDEF", 8, "0x"),
  binary("BIN", "01", 16, "0b"),
  unsignedDecimal("DEC", "0123456789", 10, "0d"),
  signedDecimal("±DEC", "0123456789", 10, "0s"),
  ascii(
    "ASCII",
    "�······························· !\"#\$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~·",
    10,
    "0a",
  );

  final String label;
  final String alphabet;
  final int base;
  final String prefix;
  final int defaultTargetSize;

  const ConversionType(
    this.label,
    this.alphabet,
    this.defaultTargetSize,
    this.prefix,
  ) : base = alphabet.length;

  static bool isValidTypeIndex(int typeIndex) {
    return 0 <= typeIndex && typeIndex < values.length;
  }

  static ConversionType? fromPrefix(String prefix) {
    return _typeFromPrefix[prefix];
  }
}
