import 'package:app_0byte/utils/validation.dart';
import 'package:flutter/material.dart';

class EditableField<T> extends Editable<T> {
  late final ValueNotifier<T> notifier;

  late T _value;
  T get value => _value;
  set value(T newValue) {
    if (isEditable) {
      _value = _applyOr(newValue);
      notifier.value = value;
    }
  }

  final T Function(T value)? applyInput;
  final void Function(T newValue)? onSubmitted;

  void Function(T newValue) get onChanged => (newValue) {
        value = newValue;
      };

  EditableField(
    super.object, {
    super.isEditable = true,
    this.applyInput,
    this.onSubmitted,
  }) {
    _value = _applyOr(object);
    notifier = ValueNotifier(value);
  }

  T _applyOr(T defaultValue) {
    return applyInput?.call(object) ?? defaultValue;
  }

  void submit() {
    onSubmitted?.call(value);
  }
}
