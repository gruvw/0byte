import 'package:hooks_riverpod/hooks_riverpod.dart';

// Note: dynamic in this file is for typedef UpdaterRef = WidgetRef | ProviderRef;

class Updater<State> {
  final Function(dynamic ref) subscribe;

  Updater(this.subscribe);
}

class FamilyUpdater<State> extends Updater {
  static FamilyUpdaterBuilder<State> family<State>(
          Function(dynamic ref, State element) subscribe) =>
      FamilyUpdaterBuilder<State>(subscribe);

  FamilyUpdater(
    State element,
    Function(dynamic ref, State element) familySubscribe,
  ) : super((ref) => familySubscribe(ref, element));
}

class FamilyUpdaterBuilder<State> {
  final Function(dynamic ref, State element) subscribe;

  const FamilyUpdaterBuilder(this.subscribe);

  FamilyUpdater<State> call(State element) => FamilyUpdater(element, subscribe);
}

extension WidgetRefSubscribe on WidgetRef {
  /// Rebuilds the widget when updater receives an update (even if the state did not change).
  void subscribe<State>(Updater<State> updater) {
    updater.subscribe(this);
  }
}

extension ProviderRefSubscribe on ProviderRef {
  /// Rebuilds the widget when updater receives an update (even if the state did not change).
  void subscribe<State>(Updater<State> updater) {
    updater.subscribe(this);
  }
}
