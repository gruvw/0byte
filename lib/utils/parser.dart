import 'package:tuple/tuple.dart';

import 'package:app_0byte/models/number_types.dart';

const sign = "-";
const separator = "_";

String leftTrimmed(ConversionType type, String value, [bool forceTrim = false]) {
  // Left trim 0s for decimal and ascii
  if (type == ConversionType.signedDecimal ||
      type == ConversionType.unsignedDecimal ||
      type == ConversionType.ascii ||
      forceTrim) {
    // Don't trim sign, don't return empty string, trim separators too
    String newVal = value.replaceFirst(RegExp("(?<=^$sign?)[${type.alphabet[0]}$separator]+"), "");
    return newVal.isNotEmpty ? newVal : type.alphabet[0];
  }
  return value;
}

Tuple2<String, String> splitSign(ConversionType type, String data) {
  bool signed = data.startsWith(sign);
  if (type != ConversionType.signedDecimal || !signed) {
    return Tuple2("", data);
  }
  return Tuple2(sign, data.replaceFirst(sign, ""));
}

String? parseText(ConversionType type, String text) {
  text = withoutSeparator(type, text);

  String toCheck = splitSign(type, text).item2;

  // Empty check
  if (toCheck.isEmpty) {
    return null;
  }
  // Alphabet verification
  for (int i = 0; i < toCheck.length; i++) {
    if (!type.alphabet.contains(toCheck[i])) {
      return null;
    }
  }

  String number = leftTrimmed(type, text);
  return number;
}

bool isValidText(ConversionType type, String text) {
  return parseText(type, text) != null;
}

String withoutSeparator(ConversionType type, String text) {
  if (type.isSeparated) {
    return text.replaceAll(separator, "");
  }

  return text;
}
