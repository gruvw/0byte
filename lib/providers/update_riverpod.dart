import 'package:hooks_riverpod/hooks_riverpod.dart';

class Updater<State> {
  final Function(WidgetRef ref) subscribe;

  Updater(this.subscribe);
}

class FamilyUpdater<State> extends Updater {
  static FamilyUpdaterBuilder<State> family<State>(
          Function(WidgetRef ref, State element) subscribe) =>
      FamilyUpdaterBuilder<State>(subscribe);

  FamilyUpdater(
    State element,
    Function(WidgetRef ref, State element) familySubscribe,
  ) : super((ref) => familySubscribe(ref, element));
}

class FamilyUpdaterBuilder<State> {
  final Function(WidgetRef ref, State element) subscribe;

  const FamilyUpdaterBuilder(this.subscribe);

  FamilyUpdater<State> call(State element) => FamilyUpdater(element, subscribe);
}

extension Subscribe on WidgetRef {
  /// Rebuilds the widget when updater receives an update (even if the state did not change).
  void subscribe<State>(Updater<State> updater) {
    updater.subscribe(this);
  }
}
