import 'dart:math';

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

  PotentiallyMutable(
    this.object, {
    required this.isMutable,
  });
}

class Mutable<T> extends PotentiallyMutable<T> {
  Mutable(super.object) : super(isMutable: true);
}

class Immutable<T> extends PotentiallyMutable<T> {
  Immutable(super.object) : super(isMutable: false);
}

String _regexEnclosing(String enclosing) =>
    enclosing.isNotEmpty ? "\\${enclosing[0]}" : "";

String uniqueLabel(
  Iterable<String> labels,
  String label, {
  // Only first enclosing char taken into account
  String enclosingLeft = "",
  String enclosingRight = "",
}) {
  final occurrence = RegExp(
      " ${_regexEnclosing(enclosingLeft)}(\\d+)${_regexEnclosing(enclosingRight)}\$");

  String withoutOccurrence(String l) => l.replaceFirst(
      occurrence, "", l.lastIndexOf(occurrence).clamp(0, l.length));

  label = withoutOccurrence(label);

  final numbers = labels.where((l) => withoutOccurrence(l) == label).map((l) {
    final matches = occurrence.allMatches(l);
    return (matches.isEmpty ? 0 : int.parse(matches.last.group(1)!)) + 1;
  });

  return numbers.isEmpty
      ? label
      : "$label $enclosingLeft${numbers.reduce(max)}$enclosingRight";
}

T applyOr<T>(T Function(T value)? applyText, T value) {
  return applyText?.call(value) ?? value;
}
