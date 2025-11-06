import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_telemetry.freezed.dart';
part 'device_telemetry.g.json.dart';

/// Model for telemetry data received from Pico W
@freezed
class DeviceTelemetry with _$DeviceTelemetry {
  const factory DeviceTelemetry({
    required String deviceId,
    required DateTime timestamp,
    required int stepsDelta,
    required int totalSteps,
    required double battery,
    required int sampleRate,
    @Default(0.0) double temperature,
  }) = _DeviceTelemetry;

  factory DeviceTelemetry.fromJson(Map<String, dynamic> json) =>
      _$DeviceTelemetryFromJson(json);
}

/// Model for raw accelerometer data (optional, for debug mode)
@freezed
class AccelerometerData with _$AccelerometerData {
  const factory AccelerometerData({
    required String deviceId,
    required DateTime timestamp,
    required double x,
    required double y,
    required double z,
    double? magnitude,
  }) = _AccelerometerData;

  factory AccelerometerData.fromJson(Map<String, dynamic> json) =>
      _$AccelerometerDataFromJson(json);
}

/// Model for device configuration/calibration
@freezed
class DeviceConfig with _$DeviceConfig {
  const factory DeviceConfig({
    required String deviceId,
    @Default(50) int sampleRate,
    @Default(1.15) double threshold,
    @Default(300) int minInterval,
    @Default(0.9) double filterAlpha,
    @Default(false) bool debugMode,
  }) = _DeviceConfig;

  factory DeviceConfig.fromJson(Map<String, dynamic> json) =>
      _$DeviceConfigFromJson(json);
}

/// Model for device information
@freezed
class PicoDevice with _$PicoDevice {
  const factory PicoDevice({
    required String deviceId,
    required String name,
    required String ipAddress,
    DateTime? lastSeen,
    DeviceStatus? status,
    double? batteryLevel,
  }) = _PicoDevice;

  factory PicoDevice.fromJson(Map<String, dynamic> json) =>
      _$PicoDeviceFromJson(json);
}

enum DeviceStatus {
  connected,
  disconnected,
  connecting,
  error,
}
