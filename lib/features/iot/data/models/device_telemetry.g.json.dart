// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_telemetry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceTelemetryImpl _$$DeviceTelemetryImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceTelemetryImpl(
      deviceId: json['deviceId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      stepsDelta: json['stepsDelta'] as int,
      totalSteps: json['totalSteps'] as int,
      battery: (json['battery'] as num).toDouble(),
      sampleRate: json['sampleRate'] as int,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$DeviceTelemetryImplToJson(
        _$DeviceTelemetryImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'timestamp': instance.timestamp.toIso8601String(),
      'stepsDelta': instance.stepsDelta,
      'totalSteps': instance.totalSteps,
      'battery': instance.battery,
      'sampleRate': instance.sampleRate,
      'temperature': instance.temperature,
    };

_$AccelerometerDataImpl _$$AccelerometerDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AccelerometerDataImpl(
      deviceId: json['deviceId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      magnitude: (json['magnitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AccelerometerDataImplToJson(
        _$AccelerometerDataImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'timestamp': instance.timestamp.toIso8601String(),
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'magnitude': instance.magnitude,
    };

_$DeviceConfigImpl _$$DeviceConfigImplFromJson(Map<String, dynamic> json) =>
    _$DeviceConfigImpl(
      deviceId: json['deviceId'] as String,
      sampleRate: json['sampleRate'] as int? ?? 50,
      threshold: (json['threshold'] as num?)?.toDouble() ?? 1.15,
      minInterval: json['minInterval'] as int? ?? 300,
      filterAlpha: (json['filterAlpha'] as num?)?.toDouble() ?? 0.9,
      debugMode: json['debugMode'] as bool? ?? false,
    );

Map<String, dynamic> _$$DeviceConfigImplToJson(_$DeviceConfigImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'sampleRate': instance.sampleRate,
      'threshold': instance.threshold,
      'minInterval': instance.minInterval,
      'filterAlpha': instance.filterAlpha,
      'debugMode': instance.debugMode,
    };

_$PicoDeviceImpl _$$PicoDeviceImplFromJson(Map<String, dynamic> json) =>
    _$PicoDeviceImpl(
      deviceId: json['deviceId'] as String,
      name: json['name'] as String,
      ipAddress: json['ipAddress'] as String,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      status: $enumDecodeNullable(_$DeviceStatusEnumMap, json['status']),
      batteryLevel: (json['batteryLevel'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PicoDeviceImplToJson(_$PicoDeviceImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'name': instance.name,
      'ipAddress': instance.ipAddress,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'status': _$DeviceStatusEnumMap[instance.status],
      'batteryLevel': instance.batteryLevel,
    };

const _$DeviceStatusEnumMap = {
  DeviceStatus.connected: 'connected',
  DeviceStatus.disconnected: 'disconnected',
  DeviceStatus.connecting: 'connecting',
  DeviceStatus.error: 'error',
};

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}
