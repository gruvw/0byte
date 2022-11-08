import 'dart:ffi';

import 'package:app_0byte/models/conversion_types.dart';
import 'package:tuple/tuple.dart';

const String sign = "-";

String leftTrimmed(ConversionType type, String value) {
  // Left trim 0s for decimal and ascii
  if (type == ConversionType.signedDecimal ||
      type == ConversionType.unsignedDecimal ||
      type == ConversionType.ascii) {
    String newVal =
        value.replaceFirst(RegExp("(?<=^$sign?)${type.alphabet[0]}+"), "");
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

String? parseInput(ConversionType type, String input) {
  String toCheck = splitSign(type, input).item2;

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

  String number = leftTrimmed(type, input);
  return number;
}
