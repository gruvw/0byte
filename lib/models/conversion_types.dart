enum ConversionType {
  hexadecimal("HEX", 8, "0x"),
  binary("BIN", 32, "0b"),
  unsignedDecimal("DEC", 30, ""),
  signedDecimal("±DEC", 30, ""),
  ascii("ASCII", 30, "0a");

  final String label;
  final String prefix;
  final int defaultN;

  const ConversionType(this.label, this.defaultN, this.prefix);
}
