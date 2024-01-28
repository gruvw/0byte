import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';

abstract class CoreValues {
  static const String appTitle = "0byte";
}

abstract class UIValues {
  static const String newCollectionButtonLabel = "New Collection";
  static const String importButtonLabel = "Import";
  static const String exportCollectionButtonLabel = "Export Collection";
  static const String exportCollectionsButtonLabel =
      "${exportCollectionButtonLabel}s";
  static const String copyCollectionButtonLabel = "Copy Collection";

  static const String symmetricArrow = "<->";
  static const String nonSymmetricArrow = "-->";

  static const String inputTitle = "Input";
  static const String conversionTitle = "Converted";
  static const String targetTitle = "Target";

  static const String settingsTitle = "Settings";
  static const String settingsUITitle = "User Interface";
  static const String settingsExportTitle = "Clipboard exports";

  static const String digitsSelectorLabel = "Digits:";
  static const String cancelLabel = "Cancel";
  static const String confirmLabel = "Confirm";

  static const String errorRouteText = "ERROR";
}

abstract class DefaultValues {
  static final Number number = DartNumber(
    type: ConversionType.binary,
    text: ConversionType.binary.zero,
  );

  static final ConversionTarget target = ConversionTarget(
    type: ConversionType.unsignedDecimal,
    digits: Digits.fromInt(10)!,
  );

  static const String numberLabel = "Value";
  static const String collectionLabel = "My Collection";
}

abstract class SettingsValues {
  static const String displaySeparatorLabel = "Display number separators";
  static const String displayTrimConvertedLeadingZerosLabel =
      "Trim leading zeros when displaying conversion";
  static const String exportSeparatorsLabel = "Export number separators";
  static const String exportTrimConvertedLeadingZerosLabel =
      "Trim leading zeros when exporting conversion";
  static const String exportUseASCIIControlLabel =
      "Export ASCII unicode control pictures instead of ASCII control codes";
}
