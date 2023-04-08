import 'dart:math';

import 'package:app_0byte/models/types.dart';

import 'parsing.dart';

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

ApplyInput applyInputFromType(ConversionType type) => (String input) {
      input = withoutSeparator(type, input);

      // Trim number prefix
      if (!isValidText(type, input)) {
        if (input.startsWith(type.prefix)) {
          String inputWithoutPrefix = input.replaceFirst(type.prefix, "");
          if (isValidText(type, inputWithoutPrefix)) {
            input = inputWithoutPrefix;
          }
        }
      }

      // HEX to maj
      if (type == ConversionType.hexadecimal) {
        input = input.toUpperCase();
      }

      input = separatorTransform(type, input, true);

      return input;
    };

String separatorTransform(
  ConversionType type,
  String text,
  bool displaySeparator, // TODO use app/collection based setting
) {
  if (!displaySeparator || !type.isSeparated() || !isValidText(type, text)) {
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
