import 'package:flutter/material.dart';

import 'package:app_0byte/utils/validation.dart';

class PotentiallyMutableField<T, View> extends PotentiallyMutable<T> {
  final View Function(T value) _getValue;

  final T Function(T value)? applyInput;

  late final ValueNotifier<View> notifier;
  final void Function(T newValue)? onSubmitted;

  PotentiallyMutableField(
    super.object, {
    super.isMutable = true,
    required View Function(T value) getValue,
    T Function(T value)? applyInput,
    void Function(T newValue)? onSubmitted,
  })  : _getValue = getValue,
        // If not editable, discards applyInput and onSubmitted
        applyInput = isMutable ? applyInput : null,
        onSubmitted = isMutable ? onSubmitted : null {
    object = applyOr(applyInput, object); // apply input at least once
    notifier = ValueNotifier(this.getValue());
  }

  View getValue() => _getValue(object);

  void setValue(T newValue) {
    if (isMutable) {
      object = applyOr(applyInput, newValue);
      notifier.value = getValue();
    }
  }

  void Function(T newValue) get onChanged => (newValue) {
        setValue(applyOr(applyInput, newValue));
      };

  void submit() {
    onSubmitted?.call(object);
  }
}
