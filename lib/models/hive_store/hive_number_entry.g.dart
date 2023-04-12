// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_number_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveStoreNumberEntryAdapter extends TypeAdapter<HiveStoreNumberEntry> {
  @override
  final int typeId = 1;

  @override
  HiveStoreNumberEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveStoreNumberEntry(
      hiveLabel: fields[0] as String,
      hiveTypeIndex: fields[1] as int,
      hiveText: fields[2] as String,
      hivePosition: fields[3] as int,
      hiveCollectionKey: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveStoreNumberEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.hiveLabel)
      ..writeByte(1)
      ..write(obj.hiveTypeIndex)
      ..writeByte(2)
      ..write(obj.hiveText)
      ..writeByte(3)
      ..write(obj.hivePosition)
      ..writeByte(4)
      ..write(obj.hiveCollectionKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveStoreNumberEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
