import 'package:app_0byte/providers/providers.dart';

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

String uniqueLabel(String label) {
  int number = 0;
  String getLabel() => number == 0 ? label : "$label $number";

  while (container
      .read(collectionsProvider)
      .map((c) => c.label)
      .contains(getLabel())) {
    ++number;
  }

  return getLabel();
}
