import 'package:app_0byte/models/database.dart';

// class ExportSettings extends DisplaySettings {
//   final bool useASCIIControl;

//   ExportSettings({
//     required super.useSeparators,
//     required super.trimLeadingZeros,
//     required this.useASCIIControl,
//   });

//   ExportSettings along({
//     bool? useSeparators,
//     bool? trimLeadingZeros,
//     bool? useASCIIControl,
//   }) =>
//       ExportSettings(
//         useSeparators: useSeparators ?? this.useSeparators,
//         trimLeadingZeros: trimLeadingZeros ?? this.trimLeadingZeros,
//         useASCIIControl: useASCIIControl ?? this.useASCIIControl,
//       );
// }

// class DisplaySettings {
//   final bool useSeparators;
//   final bool trimLeadingZeros;

//   DisplaySettings({
//     required this.useSeparators,
//     required this.trimLeadingZeros,
//   });
// }

abstract class ApplicationSettings extends DatabaseObject {
  abstract bool displaySeparators;
  abstract bool displayTrimConvertedLeadingZeros;
  abstract bool exportSeparators;
  abstract bool exportTrimConvertedLeadingZeros;
  abstract bool exportUseASCIIControl;

  ApplicationSettings({required super.database});
}
