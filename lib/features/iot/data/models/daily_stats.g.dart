// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStatsAdapter extends TypeAdapter<DailyStats> {
  @override
  final int typeId = 0;

  @override
  DailyStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStats(
      date: fields[0] as DateTime,
      totalSteps: fields[1] as int,
      distanceMeters: fields[2] as double,
      caloriesBurned: fields[3] as double,
      activeMinutes: fields[4] as int,
      deviceId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyStats obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalSteps)
      ..writeByte(2)
      ..write(obj.distanceMeters)
      ..writeByte(3)
      ..write(obj.caloriesBurned)
      ..writeByte(4)
      ..write(obj.activeMinutes)
      ..writeByte(5)
      ..write(obj.deviceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
