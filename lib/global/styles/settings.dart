import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/utils/conversion.dart';

abstract class SettingsTheme {
  static final Number defaultNumber = DartNumber(
    type: ConversionType.binary,
    text: ConversionType.binary.alphabet[0],
  );
  static final ConversionTarget defaultTarget = ConversionTarget(
    type: ConversionType.unsignedDecimal,
    digits: Digits.fromInt(10)!,
  );

  static const String newCollectionButtonLabel = "New Collection";
  static const String importButtonLabel = "Import";
  static const String exportCollectionButtonLabel = "Export Collection";
  static const String exportCollectionsButtonLabel = "Export Collections";
  static const String copyCollectionButtonLabel = "Copy Collection";
  static const String defaultCollectionLabel = "My Collection";
  static const String defaultNumberLabel = "Value";
  static const String symmetricArrow = "<-->";
  static const String nonSymmetricArrow = "-->";
}
