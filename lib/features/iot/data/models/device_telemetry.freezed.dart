// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_telemetry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DeviceTelemetry _$DeviceTelemetryFromJson(Map<String, dynamic> json) {
  return _DeviceTelemetry.fromJson(json);
}

/// @nodoc
mixin _$DeviceTelemetry {
  String get deviceId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get stepsDelta => throw _privateConstructorUsedError;
  int get totalSteps => throw _privateConstructorUsedError;
  double get battery => throw _privateConstructorUsedError;
  int get sampleRate => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceTelemetryCopyWith<DeviceTelemetry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceTelemetryCopyWith<$Res> {
  factory $DeviceTelemetryCopyWith(
          DeviceTelemetry value, $Res Function(DeviceTelemetry) then) =
      _$DeviceTelemetryCopyWithImpl<$Res, DeviceTelemetry>;
  @useResult
  $Res call(
      {String deviceId,
      DateTime timestamp,
      int stepsDelta,
      int totalSteps,
      double battery,
      int sampleRate,
      double temperature});
}

/// @nodoc
class _$DeviceTelemetryCopyWithImpl<$Res, $Val extends DeviceTelemetry>
    implements $DeviceTelemetryCopyWith<$Res> {
  _$DeviceTelemetryCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? timestamp = null,
    Object? stepsDelta = null,
    Object? totalSteps = null,
    Object? battery = null,
    Object? sampleRate = null,
    Object? temperature = null,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      stepsDelta: null == stepsDelta ? _value.stepsDelta : stepsDelta as int,
      totalSteps: null == totalSteps ? _value.totalSteps : totalSteps as int,
      battery: null == battery ? _value.battery : battery as double,
      sampleRate: null == sampleRate ? _value.sampleRate : sampleRate as int,
      temperature:
          null == temperature ? _value.temperature : temperature as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceTelemetryImplCopyWith<$Res>
    implements $DeviceTelemetryCopyWith<$Res> {
  factory _$$DeviceTelemetryImplCopyWith(_$DeviceTelemetryImpl value,
          $Res Function(_$DeviceTelemetryImpl) then) =
      __$$DeviceTelemetryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      DateTime timestamp,
      int stepsDelta,
      int totalSteps,
      double battery,
      int sampleRate,
      double temperature});
}

/// @nodoc
class __$$DeviceTelemetryImplCopyWithImpl<$Res>
    extends _$DeviceTelemetryCopyWithImpl<$Res, _$DeviceTelemetryImpl>
    implements _$$DeviceTelemetryImplCopyWith<$Res> {
  __$$DeviceTelemetryImplCopyWithImpl(
      _$DeviceTelemetryImpl _value, $Res Function(_$DeviceTelemetryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? timestamp = null,
    Object? stepsDelta = null,
    Object? totalSteps = null,
    Object? battery = null,
    Object? sampleRate = null,
    Object? temperature = null,
  }) {
    return _then(_$DeviceTelemetryImpl(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      stepsDelta: null == stepsDelta ? _value.stepsDelta : stepsDelta as int,
      totalSteps: null == totalSteps ? _value.totalSteps : totalSteps as int,
      battery: null == battery ? _value.battery : battery as double,
      sampleRate: null == sampleRate ? _value.sampleRate : sampleRate as int,
      temperature:
          null == temperature ? _value.temperature : temperature as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceTelemetryImpl implements _DeviceTelemetry {
  const _$DeviceTelemetryImpl(
      {required this.deviceId,
      required this.timestamp,
      required this.stepsDelta,
      required this.totalSteps,
      required this.battery,
      required this.sampleRate,
      this.temperature = 0.0});

  factory _$DeviceTelemetryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceTelemetryImplFromJson(json);

  @override
  final String deviceId;
  @override
  final DateTime timestamp;
  @override
  final int stepsDelta;
  @override
  final int totalSteps;
  @override
  final double battery;
  @override
  final int sampleRate;
  @override
  @JsonKey()
  final double temperature;

  @override
  String toString() {
    return 'DeviceTelemetry(deviceId: $deviceId, timestamp: $timestamp, stepsDelta: $stepsDelta, totalSteps: $totalSteps, battery: $battery, sampleRate: $sampleRate, temperature: $temperature)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceTelemetryImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.stepsDelta, stepsDelta) ||
                other.stepsDelta == stepsDelta) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            (identical(other.battery, battery) || other.battery == battery) &&
            (identical(other.sampleRate, sampleRate) ||
                other.sampleRate == sampleRate) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, timestamp, stepsDelta,
      totalSteps, battery, sampleRate, temperature);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceTelemetryImplCopyWith<_$DeviceTelemetryImpl> get copyWith =>
      __$$DeviceTelemetryImplCopyWithImpl<_$DeviceTelemetryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceTelemetryImplToJson(
      this,
    );
  }
}

abstract class _DeviceTelemetry implements DeviceTelemetry {
  const factory _DeviceTelemetry(
      {required final String deviceId,
      required final DateTime timestamp,
      required final int stepsDelta,
      required final int totalSteps,
      required final double battery,
      required final int sampleRate,
      final double temperature}) = _$DeviceTelemetryImpl;

  factory _DeviceTelemetry.fromJson(Map<String, dynamic> json) =
      _$DeviceTelemetryImpl.fromJson;

  @override
  String get deviceId;
  @override
  DateTime get timestamp;
  @override
  int get stepsDelta;
  @override
  int get totalSteps;
  @override
  double get battery;
  @override
  int get sampleRate;
  @override
  double get temperature;
  @override
  @JsonKey(ignore: true)
  _$$DeviceTelemetryImplCopyWith<_$DeviceTelemetryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccelerometerData _$AccelerometerDataFromJson(Map<String, dynamic> json) {
  return _AccelerometerData.fromJson(json);
}

/// @nodoc
mixin _$AccelerometerData {
  String get deviceId => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get z => throw _privateConstructorUsedError;
  double? get magnitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccelerometerDataCopyWith<AccelerometerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccelerometerDataCopyWith<$Res> {
  factory $AccelerometerDataCopyWith(
          AccelerometerData value, $Res Function(AccelerometerData) then) =
      _$AccelerometerDataCopyWithImpl<$Res, AccelerometerData>;
  @useResult
  $Res call(
      {String deviceId,
      DateTime timestamp,
      double x,
      double y,
      double z,
      double? magnitude});
}

/// @nodoc
class _$AccelerometerDataCopyWithImpl<$Res, $Val extends AccelerometerData>
    implements $AccelerometerDataCopyWith<$Res> {
  _$AccelerometerDataCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? timestamp = null,
    Object? x = null,
    Object? y = null,
    Object? z = null,
    Object? magnitude = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      x: null == x ? _value.x : x as double,
      y: null == y ? _value.y : y as double,
      z: null == z ? _value.z : z as double,
      magnitude: freezed == magnitude ? _value.magnitude : magnitude as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccelerometerDataImplCopyWith<$Res>
    implements $AccelerometerDataCopyWith<$Res> {
  factory _$$AccelerometerDataImplCopyWith(_$AccelerometerDataImpl value,
          $Res Function(_$AccelerometerDataImpl) then) =
      __$$AccelerometerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      DateTime timestamp,
      double x,
      double y,
      double z,
      double? magnitude});
}

/// @nodoc
class __$$AccelerometerDataImplCopyWithImpl<$Res>
    extends _$AccelerometerDataCopyWithImpl<$Res, _$AccelerometerDataImpl>
    implements _$$AccelerometerDataImplCopyWith<$Res> {
  __$$AccelerometerDataImplCopyWithImpl(_$AccelerometerDataImpl _value,
      $Res Function(_$AccelerometerDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? timestamp = null,
    Object? x = null,
    Object? y = null,
    Object? z = null,
    Object? magnitude = freezed,
  }) {
    return _then(_$AccelerometerDataImpl(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      timestamp: null == timestamp ? _value.timestamp : timestamp as DateTime,
      x: null == x ? _value.x : x as double,
      y: null == y ? _value.y : y as double,
      z: null == z ? _value.z : z as double,
      magnitude: freezed == magnitude ? _value.magnitude : magnitude as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccelerometerDataImpl implements _AccelerometerData {
  const _$AccelerometerDataImpl(
      {required this.deviceId,
      required this.timestamp,
      required this.x,
      required this.y,
      required this.z,
      this.magnitude});

  factory _$AccelerometerDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccelerometerDataImplFromJson(json);

  @override
  final String deviceId;
  @override
  final DateTime timestamp;
  @override
  final double x;
  @override
  final double y;
  @override
  final double z;
  @override
  final double? magnitude;

  @override
  String toString() {
    return 'AccelerometerData(deviceId: $deviceId, timestamp: $timestamp, x: $x, y: $y, z: $z, magnitude: $magnitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccelerometerDataImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.z, z) || other.z == z) &&
            (identical(other.magnitude, magnitude) ||
                other.magnitude == magnitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, deviceId, timestamp, x, y, z, magnitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccelerometerDataImplCopyWith<_$AccelerometerDataImpl> get copyWith =>
      __$$AccelerometerDataImplCopyWithImpl<_$AccelerometerDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccelerometerDataImplToJson(
      this,
    );
  }
}

abstract class _AccelerometerData implements AccelerometerData {
  const factory _AccelerometerData(
      {required final String deviceId,
      required final DateTime timestamp,
      required final double x,
      required final double y,
      required final double z,
      final double? magnitude}) = _$AccelerometerDataImpl;

  factory _AccelerometerData.fromJson(Map<String, dynamic> json) =
      _$AccelerometerDataImpl.fromJson;

  @override
  String get deviceId;
  @override
  DateTime get timestamp;
  @override
  double get x;
  @override
  double get y;
  @override
  double get z;
  @override
  double? get magnitude;
  @override
  @JsonKey(ignore: true)
  _$$AccelerometerDataImplCopyWith<_$AccelerometerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceConfig _$DeviceConfigFromJson(Map<String, dynamic> json) {
  return _DeviceConfig.fromJson(json);
}

/// @nodoc
mixin _$DeviceConfig {
  String get deviceId => throw _privateConstructorUsedError;
  int get sampleRate => throw _privateConstructorUsedError;
  double get threshold => throw _privateConstructorUsedError;
  int get minInterval => throw _privateConstructorUsedError;
  double get filterAlpha => throw _privateConstructorUsedError;
  bool get debugMode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceConfigCopyWith<DeviceConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceConfigCopyWith<$Res> {
  factory $DeviceConfigCopyWith(
          DeviceConfig value, $Res Function(DeviceConfig) then) =
      _$DeviceConfigCopyWithImpl<$Res, DeviceConfig>;
  @useResult
  $Res call(
      {String deviceId,
      int sampleRate,
      double threshold,
      int minInterval,
      double filterAlpha,
      bool debugMode});
}

/// @nodoc
class _$DeviceConfigCopyWithImpl<$Res, $Val extends DeviceConfig>
    implements $DeviceConfigCopyWith<$Res> {
  _$DeviceConfigCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? sampleRate = null,
    Object? threshold = null,
    Object? minInterval = null,
    Object? filterAlpha = null,
    Object? debugMode = null,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      sampleRate: null == sampleRate ? _value.sampleRate : sampleRate as int,
      threshold: null == threshold ? _value.threshold : threshold as double,
      minInterval:
          null == minInterval ? _value.minInterval : minInterval as int,
      filterAlpha:
          null == filterAlpha ? _value.filterAlpha : filterAlpha as double,
      debugMode: null == debugMode ? _value.debugMode : debugMode as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceConfigImplCopyWith<$Res>
    implements $DeviceConfigCopyWith<$Res> {
  factory _$$DeviceConfigImplCopyWith(
          _$DeviceConfigImpl value, $Res Function(_$DeviceConfigImpl) then) =
      __$$DeviceConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      int sampleRate,
      double threshold,
      int minInterval,
      double filterAlpha,
      bool debugMode});
}

/// @nodoc
class __$$DeviceConfigImplCopyWithImpl<$Res>
    extends _$DeviceConfigCopyWithImpl<$Res, _$DeviceConfigImpl>
    implements _$$DeviceConfigImplCopyWith<$Res> {
  __$$DeviceConfigImplCopyWithImpl(
      _$DeviceConfigImpl _value, $Res Function(_$DeviceConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? sampleRate = null,
    Object? threshold = null,
    Object? minInterval = null,
    Object? filterAlpha = null,
    Object? debugMode = null,
  }) {
    return _then(_$DeviceConfigImpl(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      sampleRate: null == sampleRate ? _value.sampleRate : sampleRate as int,
      threshold: null == threshold ? _value.threshold : threshold as double,
      minInterval:
          null == minInterval ? _value.minInterval : minInterval as int,
      filterAlpha:
          null == filterAlpha ? _value.filterAlpha : filterAlpha as double,
      debugMode: null == debugMode ? _value.debugMode : debugMode as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceConfigImpl implements _DeviceConfig {
  const _$DeviceConfigImpl(
      {required this.deviceId,
      this.sampleRate = 50,
      this.threshold = 1.15,
      this.minInterval = 300,
      this.filterAlpha = 0.9,
      this.debugMode = false});

  factory _$DeviceConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceConfigImplFromJson(json);

  @override
  final String deviceId;
  @override
  @JsonKey()
  final int sampleRate;
  @override
  @JsonKey()
  final double threshold;
  @override
  @JsonKey()
  final int minInterval;
  @override
  @JsonKey()
  final double filterAlpha;
  @override
  @JsonKey()
  final bool debugMode;

  @override
  String toString() {
    return 'DeviceConfig(deviceId: $deviceId, sampleRate: $sampleRate, threshold: $threshold, minInterval: $minInterval, filterAlpha: $filterAlpha, debugMode: $debugMode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceConfigImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.sampleRate, sampleRate) ||
                other.sampleRate == sampleRate) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.minInterval, minInterval) ||
                other.minInterval == minInterval) &&
            (identical(other.filterAlpha, filterAlpha) ||
                other.filterAlpha == filterAlpha) &&
            (identical(other.debugMode, debugMode) ||
                other.debugMode == debugMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, sampleRate, threshold,
      minInterval, filterAlpha, debugMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceConfigImplCopyWith<_$DeviceConfigImpl> get copyWith =>
      __$$DeviceConfigImplCopyWithImpl<_$DeviceConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceConfigImplToJson(
      this,
    );
  }
}

abstract class _DeviceConfig implements DeviceConfig {
  const factory _DeviceConfig(
      {required final String deviceId,
      final int sampleRate,
      final double threshold,
      final int minInterval,
      final double filterAlpha,
      final bool debugMode}) = _$DeviceConfigImpl;

  factory _DeviceConfig.fromJson(Map<String, dynamic> json) =
      _$DeviceConfigImpl.fromJson;

  @override
  String get deviceId;
  @override
  int get sampleRate;
  @override
  double get threshold;
  @override
  int get minInterval;
  @override
  double get filterAlpha;
  @override
  bool get debugMode;
  @override
  @JsonKey(ignore: true)
  _$$DeviceConfigImplCopyWith<_$DeviceConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PicoDevice _$PicoDeviceFromJson(Map<String, dynamic> json) {
  return _PicoDevice.fromJson(json);
}

/// @nodoc
mixin _$PicoDevice {
  String get deviceId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;
  DeviceStatus? get status => throw _privateConstructorUsedError;
  double? get batteryLevel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PicoDeviceCopyWith<PicoDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicoDeviceCopyWith<$Res> {
  factory $PicoDeviceCopyWith(
          PicoDevice value, $Res Function(PicoDevice) then) =
      _$PicoDeviceCopyWithImpl<$Res, PicoDevice>;
  @useResult
  $Res call(
      {String deviceId,
      String name,
      String ipAddress,
      DateTime? lastSeen,
      DeviceStatus? status,
      double? batteryLevel});
}

/// @nodoc
class _$PicoDeviceCopyWithImpl<$Res, $Val extends PicoDevice>
    implements $PicoDeviceCopyWith<$Res> {
  _$PicoDeviceCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? lastSeen = freezed,
    Object? status = freezed,
    Object? batteryLevel = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      name: null == name ? _value.name : name as String,
      ipAddress: null == ipAddress ? _value.ipAddress : ipAddress as String,
      lastSeen: freezed == lastSeen ? _value.lastSeen : lastSeen as DateTime?,
      status: freezed == status ? _value.status : status as DeviceStatus?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PicoDeviceImplCopyWith<$Res>
    implements $PicoDeviceCopyWith<$Res> {
  factory _$$PicoDeviceImplCopyWith(
          _$PicoDeviceImpl value, $Res Function(_$PicoDeviceImpl) then) =
      __$$PicoDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      String name,
      String ipAddress,
      DateTime? lastSeen,
      DeviceStatus? status,
      double? batteryLevel});
}

/// @nodoc
class __$$PicoDeviceImplCopyWithImpl<$Res>
    extends _$PicoDeviceCopyWithImpl<$Res, _$PicoDeviceImpl>
    implements _$$PicoDeviceImplCopyWith<$Res> {
  __$$PicoDeviceImplCopyWithImpl(
      _$PicoDeviceImpl _value, $Res Function(_$PicoDeviceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? lastSeen = freezed,
    Object? status = freezed,
    Object? batteryLevel = freezed,
  }) {
    return _then(_$PicoDeviceImpl(
      deviceId: null == deviceId ? _value.deviceId : deviceId as String,
      name: null == name ? _value.name : name as String,
      ipAddress: null == ipAddress ? _value.ipAddress : ipAddress as String,
      lastSeen: freezed == lastSeen ? _value.lastSeen : lastSeen as DateTime?,
      status: freezed == status ? _value.status : status as DeviceStatus?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PicoDeviceImpl implements _PicoDevice {
  const _$PicoDeviceImpl(
      {required this.deviceId,
      required this.name,
      required this.ipAddress,
      this.lastSeen,
      this.status,
      this.batteryLevel});

  factory _$PicoDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PicoDeviceImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String name;
  @override
  final String ipAddress;
  @override
  final DateTime? lastSeen;
  @override
  final DeviceStatus? status;
  @override
  final double? batteryLevel;

  @override
  String toString() {
    return 'PicoDevice(deviceId: $deviceId, name: $name, ipAddress: $ipAddress, lastSeen: $lastSeen, status: $status, batteryLevel: $batteryLevel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PicoDeviceImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, deviceId, name, ipAddress, lastSeen, status, batteryLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PicoDeviceImplCopyWith<_$PicoDeviceImpl> get copyWith =>
      __$$PicoDeviceImplCopyWithImpl<_$PicoDeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PicoDeviceImplToJson(
      this,
    );
  }
}

abstract class _PicoDevice implements PicoDevice {
  const factory _PicoDevice(
      {required final String deviceId,
      required final String name,
      required final String ipAddress,
      final DateTime? lastSeen,
      final DeviceStatus? status,
      final double? batteryLevel}) = _$PicoDeviceImpl;

  factory _PicoDevice.fromJson(Map<String, dynamic> json) =
      _$PicoDeviceImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get name;
  @override
  String get ipAddress;
  @override
  DateTime? get lastSeen;
  @override
  DeviceStatus? get status;
  @override
  double? get batteryLevel;
  @override
  @JsonKey(ignore: true)
  _$$PicoDeviceImplCopyWith<_$PicoDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
