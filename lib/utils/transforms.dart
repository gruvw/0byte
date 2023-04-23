import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/number_types.dart';

import 'parser.dart';

typedef ApplyText = String Function(String);

String separatorTransform(
  ConversionType type,
  String text,
  bool displaySeparator,
) {
  if (!displaySeparator || !type.isSeparated || !isValidText(type, text)) {
    // Don't use separators
    return text;
  }

  // Prevents sign separation (ex.: -_100)
  final signSplit = splitSign(type, text);
  final unsignedText = signSplit.item2;

  // Add separator while enough chars left (backward walk)
  String unsignedSeparatedText = "";
  int i = unsignedText.length;
  for (; i > type.blockLength; i -= type.blockLength) {
    unsignedSeparatedText = separator +
        unsignedText.substring(i - type.blockLength, i) +
        unsignedSeparatedText;
  }
  final left = unsignedText.substring(0, i);

  return signSplit.item1 + left + unsignedSeparatedText;
}

ApplyText applyNumberTextFromType(ConversionType type, bool displaySeparator) =>
    (String text) {
      text = withoutSeparator(type, text);

      // HEX to maj
      if (type == ConversionType.hexadecimal) {
        // Modify only valid lowercase hex char to uppercase
        final upperText = text.toUpperCase();
        String hexUpper = "";
        for (int i = 0; i < text.length; i++) {
          hexUpper +=
              type.alphabet.contains(upperText[i]) ? upperText[i] : text[i];
        }
        text = hexUpper;
      }

      // Trim number prefix from correct type (must be invalid at first)
      if (!isValidText(type, text)) {
        if (text.startsWith(type.prefix)) {
          String textWithoutPrefix = text.substring(type.prefix.length);
          if (isValidText(type, textWithoutPrefix)) {
            text = textWithoutPrefix;
          }
        }
      }

      text = separatorTransform(type, text, displaySeparator);

      return text;
    };

class PositionedText {
  final String text;
  final int position;

  PositionedText(this.text, this.position);

  String get textAfterPosition => text.substring(position);

  @override
  String toString() {
    final clampedPosition = position.clamp(0, text.length);
    final readable =
        "${text.substring(0, clampedPosition)}|${text.substring(clampedPosition)}";

    return "PositionedText[$readable = text: $text, position: $position]";
  }

  @override
  bool operator ==(covariant PositionedText other) =>
      text == other.text && position == other.position;

  @override
  int get hashCode => Object.hash(text, position);
}

PositionedText applyNumberPositionedText(
  PositionedText oldValue,
  PositionedText newValue,
  ConversionType type,
  bool displaySeparator,
) {
  ApplyText applyNumberText = applyNumberTextFromType(type, displaySeparator);

  final appliedNewAfterPosition = applyNumberText(newValue.textAfterPosition);
  int newAfterPositionDelta =
      appliedNewAfterPosition.length - newValue.textAfterPosition.length;

  final appliedNewFull = applyNumberText(newValue.text);
  final newFullDelta = appliedNewFull.length - newValue.text.length;

  final appliedOldFull = applyNumberText(oldValue.text);

  // If both old and new are invalid, don't carry on
  if (!isValidText(type, appliedOldFull) &&
      !isValidText(type, appliedNewFull)) {
    return newValue;
  }

  // newFull is invalid but newAfterPosition is valid (added separators)
  if (!isValidText(type, appliedNewFull) &&
      isValidText(type, appliedNewAfterPosition)) {
    final newSeparatorsCountBeforePosition = separator
        .allMatches(newValue.text.substring(0, newValue.position))
        .length;
    newAfterPositionDelta = newFullDelta + newSeparatorsCountBeforePosition;
  }

  if (type.isSeparated && isValidText(type, appliedNewFull)) {
    // Check addition of separator right after position (not detected when textAfterPosition isolated)
    final newRealAfterPositonCharIndex =
        appliedNewFull.length - appliedNewAfterPosition.length - 1;
    if (newRealAfterPositonCharIndex >= 0 &&
        appliedNewFull[newRealAfterPositonCharIndex] == separator) {
      newAfterPositionDelta += 1;

      // Separator (addition) deletion correction (move over separator instead)
      final oldNewFullDelta = appliedNewFull.length - appliedOldFull.length;
      final appliedOldAfterPosition =
          applyNumberText(oldValue.textAfterPosition);

      final oldRealAfterPositionCharIndex =
          appliedOldFull.length - appliedOldAfterPosition.length - 1;
      if (oldNewFullDelta == 0 &&
              oldRealAfterPositionCharIndex >= 0 &&
              appliedOldFull[oldRealAfterPositionCharIndex] == separator &&
              oldValue.textAfterPosition.isNotEmpty &&
              (oldValue.textAfterPosition[0] == separator || // over separator
                  oldValue.position < newValue.position) // new separator
          ) {
        newAfterPositionDelta -= 1;
      }
    }
  }

  return PositionedText(
    applyNumberText(newValue.text),
    newValue.position + newFullDelta - newAfterPositionDelta,
  );
}

void Function(String) onSubmitNumberLabel(NumberConversion number) =>
    (newLabel) {
      if (newLabel.isEmpty) {
        newLabel = SettingsTheme.defaultNumberLabel;
      }
      number.label = newLabel;
    };

String applyNumberText(
  Number number,
  bool displaySeparator,
) =>
    applyNumberPositionedText(
      PositionedText(number.text, 0),
      PositionedText(number.text, 0),
      number.type,
      displaySeparator,
    ).text;

void Function(String) onSubmitNumber(Number number) => (newText) {
      if (newText.isEmpty) {
        // Take previous value instead
        newText = number.text;
      } else if (!isValidText(number.type, newText)) {
        // Change number type if text is valid without prefix (must be invalid at first)
        for (final type in ConversionType.values) {
          if (newText.startsWith(type.prefix)) {
            String newTextWithoutPrefix = newText.substring(type.prefix.length);
            if (isValidText(type, newTextWithoutPrefix)) {
              number.type = type; // change type
              newText = newTextWithoutPrefix;
            }
          }
        }
      }

      number.text = newText;
    };
