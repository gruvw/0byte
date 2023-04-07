import 'package:flutter/material.dart';

import 'package:app_0byte/utils/validation.dart';

class EditableField<Input, Output> extends Editable<Input> {
  final Output Function(Input value) _getValue;

  final Input Function(Input value)? applyInput;
  Input _applyOr(Input value) {
    return applyInput?.call(value) ?? value;
  }

  late final ValueNotifier<Output> notifier;
  final void Function(Input newValue)? onSubmitted;

  EditableField(
    super.object, {
    super.isEditable = true,
    required Output Function(Input value) getValue,
    Input Function(Input value)? applyInput,
    void Function(Input newValue)? onSubmitted,
  })  : _getValue = getValue,
        // If not editable, discards applyInput and onSubmitted
        applyInput = isEditable ? applyInput : null,
        onSubmitted = isEditable ? onSubmitted : null {
    object = _applyOr(object);
    notifier = ValueNotifier(this.getValue());
  }

  Output getValue() => _getValue(object);

  void setValue(Input newValue) {
    if (isEditable) {
      object = _applyOr(newValue);
      notifier.value = getValue();
    }
  }

  void Function(Input newValue) get onChanged => (newValue) {
        setValue(_applyOr(newValue));
      };

  void submit() {
    onSubmitted?.call(object);
  }
}
