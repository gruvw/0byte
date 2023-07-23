import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/providers/database.dart';

final entryDigitsProvider = Provider.autoDispose.family<Digits, String>(
  (ref, entryKey) {
    return ref.watch(entryProvider(entryKey))!.target.digits;
  },
);

final entryLabelProvider = Provider.autoDispose.family<String, String>(
  (ref, entryKey) {
    return ref.watch(entryProvider(entryKey))!.label;
  },
);

final entryTextProvider = Provider.autoDispose.family<String, String>(
  (ref, entryKey) {
    return ref.watch(entryProvider(entryKey))!.text;
  },
);
