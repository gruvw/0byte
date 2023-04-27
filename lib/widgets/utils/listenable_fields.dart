import 'package:flutter/foundation.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/providers/database_providers.dart';
import 'package:app_0byte/utils/validation.dart';

mixin ListenableField<V> {
  ValueListenable<V> get notifier;
  V get value;
}

class PotentiallyMutableField<T, View> extends PotentiallyMutable<T>
    with ListenableField<View> {
  final T Function(T object)? applyObject;

  @override
  late final ValueNotifier<View> notifier;

  final View Function(T object) _view;
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
    notifier = ValueNotifier(value);
  }

  @override
  View get value => _view(object);

  void set(T newObject) {
    if (isMutable) {
      object = applyOr(applyObject, newObject);
      notifier.value = value;
    }
  }

  void submit(T newObject) {
    set(newObject);
    _onSubmit?.call(object);
  }
}

// TODO ProvidedField everywhere
abstract class ProvidedField<F> with ListenableField<F> {
  static ProvidedField<F> fromProvider<F, T>(
    T object, {
    required AutoDisposeProviderFamily<F, T> provider,
  }) =>
      _ProvidedFieldBuilder(object, provider: provider);

  final ValueNotifier<F> _notifier;

  ProvidedField(this._notifier);

  @override
  ValueNotifier<F> get notifier => _notifier;
  @override
  F get value => _notifier.value;
}

// See https://github.com/dart-lang/language/issues/647 (constructors can't have type parameters)
class _ProvidedFieldBuilder<F, T> extends ProvidedField<F> {
  _ProvidedFieldBuilder(
    T object, {
    required AutoDisposeProviderFamily<F, T> provider,
  }) : super(ValueNotifier(container.read(provider(object)))) {
    container.listen(provider(object), (previous, next) {
      _notifier.value = next;
    });
  }
}
