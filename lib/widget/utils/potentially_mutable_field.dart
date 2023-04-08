import 'package:flutter/material.dart';

import 'package:app_0byte/utils/validation.dart';

class PotentiallyMutableField<T, View> extends PotentiallyMutable<T> {
  static T _staticApplyOr<T>(T Function(T value)? applyInput, T value) {
    return applyInput?.call(value) ?? value;
  }

  final View Function(T value) _getValue;

  final T Function(T value)? applyInput;
  T _applyOr(T value) {
    return _staticApplyOr(applyInput, value);
  }

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
    object = _staticApplyOr(applyInput, object); // apply input at least once
    notifier = ValueNotifier(this.getValue());
  }

  View getValue() => _getValue(object);

  void setValue(T newValue) {
    if (isMutable) {
      object = _applyOr(newValue);
      notifier.value = getValue();
    }
  }

  void Function(T newValue) get onChanged => (newValue) {
        setValue(_applyOr(newValue));
      };

  void submit() {
    onSubmitted?.call(object);
  }
}
