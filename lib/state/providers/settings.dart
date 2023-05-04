import 'package:hooks_riverpod/hooks_riverpod.dart';

// TODO move to object

// User interface
final displaySeparatorsProvider = StateProvider.autoDispose((ref) => true);
final trimConvertedLeadingZerosProvider = StateProvider.autoDispose((ref) => true);

// Exports (clipboard)
final exportSeparatorsProvider = StateProvider.autoDispose((ref) => true);
final exportASCIIControlProvider = StateProvider.autoDispose((ref) => true);
