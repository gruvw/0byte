import 'dart:math';

import 'package:app_0byte/models/types.dart';
import 'package:app_0byte/providers/providers.dart';

import 'input_parsing.dart';

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

Pattern occurrence = RegExp(r" \((\d+)\)");

String uniqueLabel(String label) {
  String withoutOccurrence(String l) => l.replaceFirst(
      occurrence, "", l.lastIndexOf(occurrence).clamp(0, l.length));

  label = withoutOccurrence(label);

  List<int> numbers = container
      .read(collectionsProvider)
      .map((c) => c.label)
      .where((l) => withoutOccurrence(l) == label)
      .map((l) {
    final matches = occurrence.allMatches(l);
    return (matches.isEmpty ? 0 : int.parse(matches.last.group(1)!)) + 1;
  }).toList();

  return numbers.isEmpty ? label : "$label (${numbers.reduce(max)})";
}

ApplyInput applyInputFromType(ConversionType type) => (String input) {
      // Trim number prefix
      if (parseInput(type, input) == null) {
        if (input.startsWith(type.prefix)) {
          String inputWithoutPrefix = input.replaceFirst(type.prefix, "");
          if (parseInput(type, inputWithoutPrefix) != null) {
            input = inputWithoutPrefix;
          }
        }
      }

      // HEX to maj
      if (type == ConversionType.hexadecimal) {
        input = input.toUpperCase();
      }

      return input;
    };
