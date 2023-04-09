import 'dart:math';

import 'package:app_0byte/models/types.dart';

import 'parser.dart';

typedef ApplyInput = String Function(String);

extension FieldValidation on Map<String, dynamic> {
  bool hasField<T>(String name) {
    return containsKey(name) && this[name] is T;
  }

  T fieldOrDefault<T>(String name, T defaultValue) {
    return hasField<T>(name) ? this[name] : defaultValue;
  }

  T? fieldOrNull<T>(String name) {
    return hasField<T>(name) ? this[name] : null;
  }
}

class PotentiallyMutable<T> {
  T object;
  final bool isMutable;

  PotentiallyMutable(this.object, {this.isMutable = true});
}

class Mutable<T> extends PotentiallyMutable<T> {
  Mutable(super.object) : super(isMutable: true);
}

class Immutable<T> extends PotentiallyMutable<T> {
  Immutable(super.object) : super(isMutable: false);
}

Pattern occurrence = RegExp(r" \((\d+)\)");

String uniqueLabel(List<String> labels, String label) {
  String withoutOccurrence(String l) => l.replaceFirst(
      occurrence, "", l.lastIndexOf(occurrence).clamp(0, l.length));

  label = withoutOccurrence(label);

  List<int> numbers =
      labels.where((l) => withoutOccurrence(l) == label).map((l) {
    final matches = occurrence.allMatches(l);
    return (matches.isEmpty ? 0 : int.parse(matches.last.group(1)!)) + 1;
  }).toList();

  return numbers.isEmpty ? label : "$label (${numbers.reduce(max)})";
}

T applyOr<T>(T Function(T value)? applyInput, T value) {
  return applyInput?.call(value) ?? value;
}

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

ApplyInput applyInputFromType(ConversionType type, bool displaySeparator) =>
    (String input) {
      input = withoutSeparator(type, input);

      // HEX to maj
      if (type == ConversionType.hexadecimal) {
        // Modify only valid lowercase hex char to uppercase
        final upperInput = input.toUpperCase();
        String hexUpper = "";
        for (int i = 0; i < input.length; i++) {
          hexUpper +=
              type.alphabet.contains(upperInput[i]) ? upperInput[i] : input[i];
        }
        input = hexUpper;
      }

      // Trim number prefix (must be invalid at first)
      if (!isValidText(type, input)) {
        if (input.startsWith(type.prefix)) {
          String inputWithoutPrefix = input.substring(type.prefix.length);
          if (isValidText(type, inputWithoutPrefix)) {
            input = inputWithoutPrefix;
          }
        }
      }

      input = separatorTransform(type, input, displaySeparator);

      return input;
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

PositionedText applyPositionedText(
  PositionedText oldValue,
  PositionedText newValue,
  ConversionType type,
  bool displaySeparator,
) {
  ApplyInput applyText = applyInputFromType(type, displaySeparator);

  final appliedNewAfterPosition = applyText(newValue.textAfterPosition);
  int newAfterPositionDelta =
      appliedNewAfterPosition.length - newValue.textAfterPosition.length;

  final appliedNewFull = applyText(newValue.text);
  final newFullDelta = appliedNewFull.length - newValue.text.length;

  final appliedOldFull = applyText(oldValue.text);

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
      final appliedOldAfterPosition = applyText(oldValue.textAfterPosition);

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
    applyText(newValue.text),
    newValue.position + newFullDelta - newAfterPositionDelta,
  );
}

String applySimpleText(
  ConversionType type,
  String text,
  bool displaySeparator,
) =>
    applyPositionedText(
      PositionedText(text, 0),
      PositionedText(text, 0),
      type,
      displaySeparator,
    ).text;
