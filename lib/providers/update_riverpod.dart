import 'package:hooks_riverpod/hooks_riverpod.dart';

class Updater<State> {
  final State element;
  final Function(WidgetRef ref, State element) subscribe;

  static UpdaterFamily<State> family<State>(
          Function(WidgetRef ref, State element) subscribe) =>
      UpdaterFamily<State>(subscribe);

  Updater(this.element, this.subscribe);
}

class UpdaterFamily<State> {
  final Function(WidgetRef ref, State element) subscribe;

  const UpdaterFamily(this.subscribe);

  Updater<State> call(State element) => Updater(element, subscribe);
}

extension Subscribe on WidgetRef {
  /// Rebuilds the widget when updater receives an update (even if the state did not change).
  void subscribe<State>(Updater<State> updater) {
    updater.subscribe(this, updater.element);
  }
}
