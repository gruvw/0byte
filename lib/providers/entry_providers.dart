import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/providers/database_updaters.dart';
import 'package:app_0byte/providers/update_riverpod.dart';

final digitsProvider =
    Provider.autoDispose.family<Digits, NumberConversionEntry>(
  (ref, entry) {
    ref.subscribe(entryEditionUpdater(entry));
    return entry.target.digits;
  },
);
