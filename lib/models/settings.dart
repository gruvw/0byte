class ExportSettings extends DisplaySettings {
  final bool useASCIIControl;

  ExportSettings({
    required super.useSeparators,
    required super.trimLeadingZeros,
    required this.useASCIIControl,
  });

  ExportSettings along({
    bool? useSeparators,
    bool? trimLeadingZeros,
    bool? useASCIIControl,
  }) =>
      ExportSettings(
        useSeparators: useSeparators ?? this.useSeparators,
        trimLeadingZeros: trimLeadingZeros ?? this.trimLeadingZeros,
        useASCIIControl: useASCIIControl ?? this.useASCIIControl,
      );
}

class DisplaySettings {
  final bool useSeparators;
  final bool trimLeadingZeros;

  DisplaySettings({
    required this.useSeparators,
    required this.trimLeadingZeros,
  });
}
