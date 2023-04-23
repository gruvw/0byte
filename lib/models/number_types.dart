import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/parser.dart';
import 'package:app_0byte/utils/validation.dart';

mixin Number {
  abstract ConversionType type;
  abstract String text;

  String? parsed() => parseText(type, text);

  Converted<Number>? convertTo(ConversionTarget target) {
    return Converted.from(number: this, target: target);
  }

  PotentiallyMutable<Number> toPotentiallyMutable(bool isMutable) {
    return PotentiallyMutable(this, isMutable: isMutable);
  }

  Number withText(String text) {
    return DartNumber(type: type, text: text);
  }
}

mixin NumberConversion on Number {
  abstract String label;
  abstract ConversionTarget target;

  void setAllLike(NumberConversion other) {
    label = other.label;
    type = other.type;
    text = other.text;
    target = other.target;
  }

  @override
  String toString() {
    String res = "$label: ${type.prefix}$text";

    final converted = convertTo(target);

    if (converted != null) {
      res +=
          " ${converted.wasSymmetric ? SettingsTheme.symmetricArrow : SettingsTheme.nonSymmetricArrow} ${converted.convertedNumber}";
    }

    return res;
  }
}

class DartNumber with Number {
  @override
  ConversionType type;

  @override
  String text;

  DartNumber({required this.type, required this.text});
}

class DartConversion with Number, NumberConversion {
  @override
  late String label;
  @override
  late ConversionType type;
  @override
  late String text;
  @override
  late ConversionTarget target;

  DartConversion.from(NumberConversion entry) {
    setAllLike(entry);
  }
}

class Digits {
  // ignore: constant_identifier_names
  static const int _MIN_AMOUNT = 0;
  // ignore: constant_identifier_names
  static const int _MAX_AMOUNT = 64;

  static bool isValidAmount(int amount) {
    return amount >= _MIN_AMOUNT && amount <= _MAX_AMOUNT;
  }

  static Digits? fromInt(int amount) {
    if (!isValidAmount(amount)) {
      return null;
    }

    return Digits._(amount: amount);
  }

  final int amount;

  const Digits._({required this.amount});
}

final Map<String, ConversionType> _typeFromPrefix =
    Map.fromEntries(ConversionType.values.map((e) => MapEntry(e.prefix, e)));

enum ConversionType {
  binary("0b", "BIN", "01", 4, 16),
  hexadecimal("0x", "HEX", "0123456789ABCDEF", 2, 8),
  unsignedDecimal("0d", "DEC", "0123456789", 3, 10),
  signedDecimal("0s", "±DEC", "0123456789", 3, 10),
  ascii(
    "0a",
    "ASCII",
    "�······························· !\"#\$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~·",
    -1,
    10,
  );

  static bool isValidTypeIndex(int typeIndex) {
    return 0 <= typeIndex && typeIndex < values.length;
  }

  static ConversionType? fromPrefix(String prefix) {
    return _typeFromPrefix[prefix];
  }

  final String prefix;
  final String label;
  final String alphabet;
  final int base;
  final int blockLength; // used for placing _ at correct places (-1: disabled)
  final bool isSeparated;
  final int _defaultDigitsAmount;

  const ConversionType(
    this.prefix,
    this.label,
    this.alphabet,
    this.blockLength,
    this._defaultDigitsAmount,
  )   : base = alphabet.length,
        isSeparated = blockLength >= 1;

  ConversionTarget get defaultTarget => ConversionTarget(
        type: this,
        digits: Digits.fromInt(_defaultDigitsAmount)!,
      );
}
