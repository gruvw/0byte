import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/input_parsing.dart';

// TODO use new types everywhere

class Number {
  final ConversionType type;
  final String text;

  Number._({required this.type, required this.text});

  static Number? fromInput({
    required ConversionType type,
    required String input,
  }) {
    String? text = parseInput(type, input);
    return text != null ? Number._(type: type, text: text) : null;
  }

  ConvertedNumber convertTo(ConversionTarget target) {
    return ConvertedNumber(number: this, target: target);
  }
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
