import 'package:flutter/material.dart';

import 'package:app_0byte/utils/validation.dart';

class PotentiallyMutableField<T, View> extends PotentiallyMutable<T> {
  final View Function(T object) _view;

  final T Function(T object)? applyObject;

  late final ValueNotifier<View> notifier;
  final void Function(T object)? _onSubmit;

  PotentiallyMutableField(
    super.object, {
    required super.isMutable,
    required View Function(T object) view,
    T Function(T object)? applyObject,
    void Function(T newObject)? onSubmitted,
  })  : _view = view,
        // If not editable, discards applyText and onSubmitted
        applyObject = isMutable ? applyObject : null,
        _onSubmit = isMutable ? onSubmitted : null {
    object = applyOr(applyObject, object); // apply text at least once
    notifier = ValueNotifier(this.view());
  }

  View view() => _view(object);

  void set(T newObject) {
    if (isMutable) {
      object = applyOr(applyObject, newObject);
      notifier.value = view();
    }
  }

  void submit(T newObject) {
    set(newObject);
    _onSubmit?.call(object);
  }
}
