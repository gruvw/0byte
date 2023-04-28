import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useListener<T>(
  ValueListenable<T> notifier,
  void Function(T newValue) listener,
) {
  final update = useValueListenable(notifier);
  useEffect(
    () {
      listener(update);
      return null;
    },
    [update],
  );
}
