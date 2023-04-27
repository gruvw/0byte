import 'dart:math';

import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/number_types.dart';

import 'parser.dart';

typedef ApplyText = String Function(String);

const _asciiMap =
    "\u{0}\u{1}\u{2}\u{3}\u{4}\u{5}\u{6}\u{7}\u{8}\u{9}\u{A}\u{B}\u{C}\u{D}\u{E}\u{F}\u{10}\u{11}\u{12}\u{13}\u{14}\u{15}\u{16}\u{17}\u{18}\u{19}\u{1A}\u{1B}\u{1C}\u{1D}\u{1E}\u{1F} !\"#\$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\u{7F}";

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
        final hexUpper = StringBuffer();
        for (int i = 0; i < text.length; i++) {
          hexUpper.write(
              type.alphabet.contains(upperText[i]) ? upperText[i] : text[i]);
        }
        text = hexUpper.toString();
      }

      // ASCII map
      if (type == ConversionType.ascii) {
        final asciiMapped = StringBuffer();
        for (int i = 0; i < text.length; i++) {
          final pos = _asciiMap.indexOf(text[i]);
          asciiMapped
              .write(pos >= 0 ? ConversionType.ascii.alphabet[pos] : text[i]);
        }
        text = asciiMapped.toString();
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

      // Length limit (trim excess on the left)
      final length = min(text.length, Digits.MAX_AMOUNT);
      text = text.substring(text.length - length, text.length);
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
    // Testing purposes
    final clampedPosition = position.clamp(0, text.length);
    final before = text.substring(0, clampedPosition);
    final after = text.substring(clampedPosition);

    return "PositionedText[$before|$after = text: $text, position: $position]";
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

  // Prevent exceeding digits amount limit
  if (withoutSeparator(type, appliedNewFull).length > Digits.MAX_AMOUNT) {
    return oldValue;
  }

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

void Function(String) onSubmitNumberConversionLabel(NumberConversion number) =>
    (newLabel) {
      if (newLabel.isEmpty) {
        newLabel = SettingsTheme.defaultNumberLabel;
      }
      number.label = newLabel;
    };

String applyNumberTextDisplay(
  Number? number,
  bool displaySeparator,
) =>
    number == null
        ? ""
        : applyNumberPositionedText(
            PositionedText(number.text, 0),
            PositionedText(number.text, 0),
            number.type,
            displaySeparator,
          ).text;

String applyNumberTextBeforeSave(
  ConversionType type,
  String text,
) {
  return withoutSeparator(type, text);
}

void Function(String) onSubmitNumber(Number? number) => (newText) {
      if (number == null) {
        return;
      }

      if (newText.isEmpty) {
        // Take previous value instead
        newText = number.text;
      } else if (!isValidText(number.type, newText)) {
        // Change number type if text is valid without prefix (must be invalid at first)
        for (final type in ConversionType.values) {
          if (newText.startsWith(type.prefix)) {
            String newTextWithoutPrefix = newText.substring(type.prefix.length);
            if (isValidText(type, newTextWithoutPrefix)) {
              number.type = type;
              newText = newTextWithoutPrefix;
              break;
            }
          }
        }
      }

      number.text = applyNumberTextBeforeSave(number.type, newText);
    };
