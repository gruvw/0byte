import 'package:flutter/material.dart';

import 'package:app_0byte/utils/validation.dart';

class PotentiallyMutableField<T, View> extends PotentiallyMutable<T> {
  final View Function(T value) _getValue;

  final T Function(T value)? applyText;

  late final ValueNotifier<View> notifier;
  final void Function(T newValue)? onSubmitted;

  PotentiallyMutableField(
    super.object, {
    super.isMutable = true,
    required View Function(T value) getValue,
    T Function(T value)? applyText,
    void Function(T newValue)? onSubmitted,
  })  : _getValue = getValue,
        // If not editable, discards applyText and onSubmitted
        applyText = isMutable ? applyText : null,
        onSubmitted = isMutable ? onSubmitted : null {
    object = applyOr(applyText, object); // apply text at least once
    notifier = ValueNotifier(this.getValue());
  }

  View getValue() => _getValue(object);

  void setValue(T newValue) {
    if (isMutable) {
      object = applyOr(applyText, newValue);
      notifier.value = getValue();
    }
  }

  void Function(T newValue) get onChanged => (newValue) {
        setValue(applyOr(applyText, newValue));
      };

  void submit() {
    onSubmitted?.call(object);
  }
}
