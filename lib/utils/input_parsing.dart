import 'package:app_0byte/models/conversion_types.dart';
import 'package:tuple/tuple.dart';

const String sign = "-";

String leftTrimmed(String val, ConversionType type) {
  // Left trim 0s for decimal and ascii
  if (type == ConversionType.signedDecimal ||
      type == ConversionType.unsignedDecimal ||
      type == ConversionType.ascii) {
    String newVal =
        val.replaceFirst(RegExp("(?<=^$sign?)${type.alphabet[0]}+"), "");
    return newVal.isNotEmpty ? newVal : type.alphabet[0];
  }
  return val;
}

Tuple2<String, String> splitSign(String data) {
  return Tuple2(data.startsWith(sign) ? sign : "", data.replaceFirst(sign, ""));
}

Tuple2<ConversionType, String>? parseInput(String input) {
  if (input.length < 3 || !typeFromPrefix.containsKey(input.substring(0, 2))) {
    return null;
  }

  String inputPrefix = input.substring(0, 2);
  ConversionType inputType = typeFromPrefix[inputPrefix]!;
  String inputVal = leftTrimmed(input.substring(2), inputType);

  return Tuple2(inputType, inputVal);
}
