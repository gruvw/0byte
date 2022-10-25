// TODO support base 64 and Latin-1 (ISO 8859-1 or 8-bits ascii)

enum ConversionType {
  hexadecimal("HEX", "0123456789ABCDEF", 8, "0x"),
  binary("BIN", "01", 32, "0b"),
  unsignedDecimal("DEC", "0123456789", 32, "0d"),
  signedDecimal("±DEC", "0123456789", 30, "0s"),
  ascii(
      "ASCII",
      "�······························· !\"#\$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~·",
      30,
      "0a");

  final String label;
  final String alphabet;
  final int base;
  final String prefix;
  final int defaultN;

  const ConversionType(this.label, this.alphabet, this.defaultN, this.prefix)
      : base = alphabet.length;
}

final Map<String, ConversionType> typeFromPrefix =
    Map.fromEntries(ConversionType.values.map((e) => MapEntry(e.prefix, e)));
