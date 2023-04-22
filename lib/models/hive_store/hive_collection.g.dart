// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveStoreCollectionAdapter extends TypeAdapter<HiveStoreCollection> {
  @override
  final int typeId = 0;

  @override
  HiveStoreCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveStoreCollection(
      entriesKeys: (fields[0] as List).cast<String>(),
      hiveLabel: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveStoreCollection obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.entriesKeys)
      ..writeByte(1)
      ..write(obj.hiveLabel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveStoreCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
