import 'package:app_0byte/models/conversion_types.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final container = ProviderContainer();
final targetConversionTypeProvider =
    StateProvider((ref) => ConversionType.hexadecimal);
final targetSizeProvider =
    StateProvider((ref) => ConversionType.hexadecimal.defaultTargetSize);
