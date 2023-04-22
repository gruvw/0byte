// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_number_conversion_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveStoreNumberConversionEntryAdapter
    extends TypeAdapter<HiveStoreNumberConversionEntry> {
  @override
  final int typeId = 1;

  @override
  HiveStoreNumberConversionEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveStoreNumberConversionEntry(
      hiveCollectionKey: fields[0] as String,
      hivePosition: fields[1] as int,
      hiveLabel: fields[2] as String,
      hiveTypeIndex: fields[3] as int,
      hiveText: fields[4] as String,
      hiveTargetTypeIndex: fields[5] as int,
      hiveTargetDigitsAmount: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveStoreNumberConversionEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.hiveCollectionKey)
      ..writeByte(1)
      ..write(obj.hivePosition)
      ..writeByte(2)
      ..write(obj.hiveLabel)
      ..writeByte(3)
      ..write(obj.hiveTypeIndex)
      ..writeByte(4)
      ..write(obj.hiveText)
      ..writeByte(5)
      ..write(obj.hiveTargetTypeIndex)
      ..writeByte(6)
      ..write(obj.hiveTargetDigitsAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveStoreNumberConversionEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
