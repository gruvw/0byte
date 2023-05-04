import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/settings.dart';

// Settings should all be true by default

// User interface
final displaySeparatorsProvider = StateProvider((ref) => true);
final displayConvertedLeadingZerosProvider = StateProvider((ref) => true);

// Exports (clipboard)
final exportSeparatorsProvider = StateProvider((ref) => true);
final exportConvertedLeadingZerosProvider = StateProvider((ref) => true);
final exportASCIIControlProvider = StateProvider((ref) => true); // TODO implement

final displayNumberSettingsProvider = StateProvider((ref) {
  return DisplaySettings(
    useSeparators: ref.watch(displaySeparatorsProvider),
    trimLeadingZeros: false, // always display leading zeros on user entered numbers
  );
});

final displayConvertedSettingsProvider = StateProvider((ref) {
  return DisplaySettings(
    useSeparators: ref.watch(displaySeparatorsProvider),
    trimLeadingZeros: !ref.watch(displayConvertedLeadingZerosProvider),
  );
});

final exportSettingsProvider = StateProvider((ref) {
  return ExportSettings(
    useSeparators: ref.watch(exportSeparatorsProvider),
    trimLeadingZeros: !ref.watch(exportConvertedLeadingZerosProvider),
    useASCIIControl: ref.watch(exportASCIIControlProvider),
  );
});
