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
      this.label, this.alphabet, this.defaultTargetSize, this.prefix)
      : base = alphabet.length;
}

final Map<String, ConversionType> typeFromPrefix =
    Map.fromEntries(ConversionType.values.map((e) => MapEntry(e.prefix, e)));
