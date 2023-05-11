// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_application_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveStoreApplicationSettingsAdapter
    extends TypeAdapter<HiveStoreApplicationSettings> {
  @override
  final int typeId = 2;

  @override
  HiveStoreApplicationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveStoreApplicationSettings(
      hiveDisplaySeparators: fields[0] as bool,
      hiveDisplayTrimConvertedLeadingZeros: fields[1] as bool,
      hiveExportSeparators: fields[2] as bool,
      hiveExportTrimConvertedLeadingZeros: fields[3] as bool,
      hiveExportUseASCIIControl: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveStoreApplicationSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.hiveDisplaySeparators)
      ..writeByte(1)
      ..write(obj.hiveDisplayTrimConvertedLeadingZeros)
      ..writeByte(2)
      ..write(obj.hiveExportSeparators)
      ..writeByte(3)
      ..write(obj.hiveExportTrimConvertedLeadingZeros)
      ..writeByte(4)
      ..write(obj.hiveExportUseASCIIControl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveStoreApplicationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
