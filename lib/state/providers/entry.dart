import 'package:app_0byte/state/updaters/database.dart';
import 'package:app_0byte/state/updaters/update_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';

final entryDigitsProvider = Provider.autoDispose.family<Digits, NumberConversionEntry>(
  (ref, entry) {
    ref.subscribe(entryEditionUpdater(entry));
    return entry.target.digits;
  },
);

final entryLabelProvider = Provider.autoDispose.family<String, NumberConversionEntry>(
  (ref, entry) {
    ref.subscribe(entryEditionUpdater(entry));
    return entry.label;
  },
);

final entryTextProvider = Provider.autoDispose.family<String, NumberConversionEntry>(
  (ref, entry) {
    ref.subscribe(entryEditionUpdater(entry));
    return entry.text;
  },
);
