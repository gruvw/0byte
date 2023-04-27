import 'package:flutter/foundation.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/providers/database_providers.dart';
import 'package:app_0byte/utils/validation.dart';

mixin ListenableField<T> {
  static ProvidedField<Provided, Arg> provided<Provided, Arg>(
    Arg object, {
    required AutoDisposeProviderFamily<Provided, Arg> provider,
  }) =>
      ProvidedField._(object, provider: provider);

  ValueListenable<T> get notifier;

  T get value => notifier.value;

  void addListener(void Function(T newValue) listener) =>
      notifier.addListener(() => listener(value));
}

class ListenableFieldTransform<Input, Output> with ListenableField<Output> {
  final ListenableField<Input> inputField;
  final Output Function(Input input) transform;

  @override
  final ValueNotifier<Output> notifier;

  ListenableFieldTransform(
    this.inputField, {
    required this.transform,
  }) : notifier = ValueNotifier(transform(inputField.value)) {
    inputField.addListener((newValue) {
      notifier.value = transform(newValue);
    });
  }
}

class PotentiallyMutableField<T> extends PotentiallyMutable<T>
    with ListenableField<T> {
  @override
  @protected
  T get object;

  @override
  @protected
  set object(T);

  final T Function(T object)? applyObject;

  final void Function(T object)? _onSubmit;
  late final ValueNotifier<T> _notifier;

  @override
  ValueListenable<T> get notifier => _notifier;

  PotentiallyMutableField(
    super.object, {
    required super.isMutable,
    T Function(T object)? applyObject,
    void Function(T newObject)? onSubmitted,
  })  :
        // If not editable, discards applyText and onSubmitted
        applyObject = isMutable ? applyObject : null,
        _onSubmit = isMutable ? onSubmitted : null {
    object = applyOr(applyObject, object); // apply text at least once
    _notifier = ValueNotifier(object);
  }

  void set(T newObject) {
    if (isMutable) {
      _notifier.value = applyOr(applyObject, newObject);
    }
  }

  void subscribeTo(ListenableField<T> field) =>
      field.addListener((newValue) => set(newValue));

  void submit(T newObject) {
    set(newObject);
    _onSubmit?.call(value);
  }
}

class ImmutableField<T> extends PotentiallyMutableField<T> {
  final ListenableField<T> field;

  ImmutableField(this.field) : super(field.value, isMutable: false);

  @override
  ValueListenable<T> get notifier => field.notifier;
}

class ProvidedField<Provided, Arg> with ListenableField<Provided> {
  @override
  final ValueNotifier<Provided> notifier;

  ProvidedField._(
    Arg object, {
    required AutoDisposeProviderFamily<Provided, Arg> provider,
  }) : notifier = ValueNotifier(container.read(provider(object))) {
    container.listen(provider(object), (previous, next) {
      notifier.value = next;
    });
  }
}
