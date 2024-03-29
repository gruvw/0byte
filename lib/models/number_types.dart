import 'package:app_0byte/models/settings.dart';
import 'package:app_0byte/utils/conversion.dart';
import 'package:app_0byte/utils/input_transforms.dart';
import 'package:app_0byte/utils/parser.dart';
import 'package:app_0byte/utils/validation.dart';

mixin Exportable {
  String export(ApplicationSettings settings);
}

mixin Number implements Exportable {
  abstract ConversionType type;
  abstract String text;

  String? parsed() => parseText(type, text);

  ConvertedNumber convertTo(ConversionTarget target) {
    return ConvertedNumber.from(number: this, target: target);
  }

  PotentiallyMutable<Number> toPotentiallyMutable(bool isMutable) {
    return PotentiallyMutable(this, isMutable: isMutable);
  }

  Number withText(String text) {
    return DartNumber(type: type, text: text);
  }

  @override
  String export(ApplicationSettings settings) =>
      type.prefix + applyNumberTextExport(this, settings);
}

mixin NumberConversion on Number {
  abstract String label;
  abstract ConversionTarget target;

  ConvertedNumber get converted => convertTo(target);

  void setAllLike(NumberConversion other) {
    label = other.label;
    type = other.type; // ok to use setter here (as we set text again after)
    text = other.text;
    target = other.target;
  }
}

class DartNumber with Number {
  @override
  ConversionType type;

  @override
  String text;

  DartNumber({
    required this.type,
    required this.text,
  });
}

class DartNumberConversion with Number, NumberConversion {
  @override
  String label;
  @override
  ConversionType type;
  @override
  String text;
  @override
  ConversionTarget target;

  DartNumberConversion.clone(NumberConversion entry)
      : label = entry.label,
        type = entry.type,
        text = entry.text,
        target = entry.target;
}

class Digits {
  // ignore: constant_identifier_names
  static const int MIN_AMOUNT = 1;
  // ignore: constant_identifier_names
  static const int MAX_AMOUNT = 64;

  static bool isValidAmount(int? amount) {
    return amount != null && amount >= MIN_AMOUNT && amount <= MAX_AMOUNT;
  }

  static Digits? fromInt(int? amount) {
    if (!isValidAmount(amount)) {
      return null;
    }

    return Digits._(amount: amount!);
  }

  static Digits? fromString(String? text) {
    if (text == null) {
      return null;
    }

    return fromInt(int.tryParse(text));
  }

  final int amount;

  const Digits._({required this.amount});

  @override
  String toString() {
    return amount.toString();
  }
}

final Map<String, ConversionType> _typeFromPrefix =
    Map.fromEntries(ConversionType.values.map((e) => MapEntry(e.prefix, e)));

enum ConversionType {
  binary("0b", "Binary", "01", 4, 16),
  hexadecimal("0x", "Hexadecimal", "0123456789ABCDEF", 2, 8),
  unsignedDecimal("0d", "Unsigned Decimal", "0123456789", 3, 10),
  signedDecimal("0s", "Signed Decimal", "0123456789", 3, 10),
  ascii(
    "0a",
    "ASCII",
    "␀␁␂␃␄␅␆␇␈␉␊␋␌␍␎␏␐␑␒␓␔␕␖␗␘␙␚␛␜␝␞␟␣!\"#\$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~␡",
    -1,
    4,
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
  )   : base = alphabet.length, // must be >= 1
        isSeparated = blockLength >= 1;

  String get zero => alphabet[0];

  ConversionTarget get defaultTarget => ConversionTarget(
        type: this,
        digits: Digits.fromInt(_defaultDigitsAmount)!,
      );
}
