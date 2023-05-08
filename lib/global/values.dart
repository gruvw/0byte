import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';

abstract class ValuesTheme {
  static final Number defaultNumber = DartNumber(
    type: ConversionType.binary,
    text: ConversionType.binary.zero,
  );
  static final ConversionTarget defaultTarget = ConversionTarget(
    type: ConversionType.unsignedDecimal,
    digits: Digits.fromInt(10)!,
  );

  static const String newCollectionButtonLabel = "New Collection";
  static const String importButtonLabel = "Import";
  static const String exportCollectionButtonLabel = "Export Collection";
  static const String exportCollectionsButtonLabel = "${exportCollectionButtonLabel}s";
  static const String copyCollectionButtonLabel = "Copy Collection";
  static const String defaultCollectionLabel = "My Collection";
  static const String defaultNumberLabel = "Value";
  static const String symmetricArrow = "<-->";
  static const String nonSymmetricArrow = "-->";
  static const String inputTitle = "Input";
  static const String conversionTitle = "Converted";
  static const String targetTitle = "Target";
  static const String digitsSelectorLabel = "Digits:";
  static const String cancelLabel = "Cancel";
  static const String confirmLabel = "Confirm";
  static const String errorRouteText = "ERROR";
  static const String settingsTitle = "Settings";
  static const String settingsUITitle = "User Interface";
  static const String settingsExportTitle = "Clipboard exports";
  static const String displaySeparatorSettingsLabel = "Display number separators";
  static const String displayTrimConvertedLeadingZerosSettingsLabel =
      "Display leading zeros in conversion";
  static const String exportSeparatorsSettingsLabel = "Export number separators";
  static const String exportTrimConvertedLeadingZerosSettingsLabel =
      "Export leading zeros in conversion";
  static const String exportUseASCIIControlSettingsLabel =
      "Export ASCII Unicode Control Pictures instead of ASCII control codes";
}