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

Tuple2<String, String> splitSign(String data) {
  return Tuple2(data.startsWith(sign) ? sign : "", data.replaceFirst(sign, ""));
}

String? parseInput(ConversionType type, String input) {
  if (input.isEmpty || input == sign) {
    return null;
  }

  String number = leftTrimmed(type, input);
  return number;
}
