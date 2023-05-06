import 'package:flutter/foundation.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/utils/validation.dart';

mixin ListenableField<T> {
  // Can't have generic constructor in _ProvidedField so static generic "constructor" here
  static ListenableField<Provided> familyProvided<Provided, Arg>(
    Arg object, {
    required AutoDisposeProviderFamily<Provided, Arg> provider,
  }) =>
      _FamilyProvidedField._(object, provider: provider);

  static ListenableField<Provided> provided<Provided>(StateProvider<Provided> provider) =>
      _ProvidedField._(provider);

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

class PotentiallyMutableField<T> extends PotentiallyMutable<T> with ListenableField<T> {
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

  void subscribeTo(ListenableField<T> field) => field.addListener((newValue) => set(newValue));

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

class _FamilyProvidedField<Provided, Arg> with ListenableField<Provided> {
  @override
  final ValueNotifier<Provided> notifier;

  _FamilyProvidedField._(
    Arg object, {
    required AutoDisposeProviderFamily<Provided, Arg> provider,
  }) : notifier = ValueNotifier(container.read(provider(object))) {
    // FIXME this might be adding multiple times the same listner (listner leak)
    container.listen(provider(object), (previous, next) {
      notifier.value = next;
    });
  }
}

class _ProvidedField<Provided> with ListenableField<Provided> {
  @override
  final ValueNotifier<Provided> notifier;

  _ProvidedField._(
    StateProvider<Provided> provider,
  ) : notifier = ValueNotifier(container.read(provider)) {
    container.listen(provider, (previous, next) {
      notifier.value = next;
    });
  }
}
