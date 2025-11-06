import 'dart:async';
import 'package:flutter_steps_tracker/features/iot/data/models/daily_stats.dart';
import 'package:flutter_steps_tracker/features/iot/data/services/mqtt_service.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';

/// Service to manage Pico W devices and process telemetry
class PicoDeviceService {
  final _logger = Logger('PicoDeviceService');
  final MqttService mqttService;

  Box<DailyStats>? _statsBox;
  Box<UserProfile>? _profileBox;
  Box<DeviceInfo>? _deviceBox;

  String? _currentDeviceId;
  int _currentDaySteps = 0;
  DateTime _lastUpdate = DateTime.now();

  // Realtime data streams
  final _stepsController = StreamController<int>.broadcast();
  final _cadenceController = StreamController<double>.broadcast();
  final _batteryController = StreamController<double>.broadcast();

  Stream<int> get stepsStream => _stepsController.stream;
  Stream<double> get cadenceStream => _cadenceController.stream;
  Stream<double> get batteryStream => _batteryController.stream;

  int get currentSteps => _currentDaySteps;

  PicoDeviceService(this.mqttService);

  /// Initialize the service and open Hive boxes
  Future<void> initialize() async {
    _logger.info('Initializing PicoDeviceService');

    // Open Hive boxes
    _statsBox = await Hive.openBox<DailyStats>('daily_stats');
    _profileBox = await Hive.openBox<UserProfile>('user_profile');
    _deviceBox = await Hive.openBox<DeviceInfo>('devices');

    // Load today's stats
    await _loadTodayStats();

    // Listen to telemetry
    mqttService.telemetryStream.listen(_processTelemetry);
  }

  /// Register a new device
  Future<void> registerDevice(
      String deviceId, String name, String ipAddress) async {
    final device = DeviceInfo(
      deviceId: deviceId,
      name: name,
      ipAddress: ipAddress,
      lastSeen: DateTime.now(),
      isActive: true,
    );

    await _deviceBox!.put(deviceId, device);
    _logger.info('Device registered: $deviceId');
  }

  /// Connect to a specific device
  Future<bool> connectToDevice(String deviceId) async {
    _logger.info('Connecting to device: $deviceId');

    _currentDeviceId = deviceId;

    // Subscribe to device topics
    mqttService.subscribeToDevice(deviceId);

    // Update device last seen
    final device = _deviceBox!.get(deviceId);
    if (device != null) {
      device.lastSeen = DateTime.now();
      await device.save();
    }

    return true;
  }

  /// Process incoming telemetry from MQTT
  void _processTelemetry(Map<String, dynamic> data) {
    try {
      final deviceId = data['device_id'] as String?;
      final stepsDelta = data['steps_delta'] as int? ?? 0;
      final totalSteps = data['total_steps'] as int? ?? 0;
      final battery = (data['battery'] as num?)?.toDouble() ?? 0.0;
      final timestamp = DateTime.tryParse(data['timestamp'] as String? ?? '');

      if (deviceId == null || timestamp == null) {
        _logger
            .warning('Invalid telemetry data: missing deviceId or timestamp');
        return;
      }

      _logger.fine('Processing telemetry: $stepsDelta steps from $deviceId');

      // Update current day steps
      _currentDaySteps += stepsDelta;
      _stepsController.add(_currentDaySteps);

      // Calculate cadence (steps per minute)
      final timeDiff = DateTime.now().difference(_lastUpdate).inSeconds;
      if (timeDiff > 0) {
        final cadence = (stepsDelta / timeDiff) * 60;
        _cadenceController.add(cadence);
      }

      _batteryController.add(battery);
      _lastUpdate = DateTime.now();

      // Update daily stats
      _updateDailyStats(stepsDelta);

      // Update device last seen
      final device = _deviceBox!.get(deviceId);
      if (device != null) {
        device.lastSeen = DateTime.now();
        device.save();
      }
    } catch (e) {
      _logger.severe('Error processing telemetry: $e');
    }
  }

  /// Load today's steps from storage
  Future<void> _loadTodayStats() async {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final stats = _statsBox!.get(todayKey);
    if (stats != null) {
      _currentDaySteps = stats.totalSteps;
      _logger.info('Loaded today\'s stats: $_currentDaySteps steps');
    } else {
      _currentDaySteps = 0;
      _logger.info('No stats for today, starting fresh');
    }
  }

  /// Update daily statistics
  Future<void> _updateDailyStats(int stepsDelta) async {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final profile = await getUserProfile();
    if (profile == null) {
      _logger
          .warning('No user profile found, cannot calculate distance/calories');
      return;
    }

    final distance =
        DailyStats.calculateDistance(_currentDaySteps, profile.strideLength);
    final calories =
        DailyStats.calculateCalories(_currentDaySteps, profile.weightKg);

    final stats = DailyStats(
      date: today,
      totalSteps: _currentDaySteps,
      distanceMeters: distance,
      caloriesBurned: calories,
      activeMinutes: 0, // TODO: Calculate based on cadence
      deviceId: _currentDeviceId ?? 'unknown',
    );

    await _statsBox!.put(todayKey, stats);
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile() async {
    return _profileBox!.get('default');
  }

  /// Save user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    await _profileBox!.put('default', profile);
    _logger.info('User profile saved');
  }

  /// Get statistics for a date range
  Future<List<DailyStats>> getStatsRange(DateTime start, DateTime end) async {
    final stats = <DailyStats>[];

    for (var date = start;
        date.isBefore(end) || date.isAtSameMomentAs(end);
        date = date.add(const Duration(days: 1))) {
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayStat = _statsBox!.get(key);
      if (dayStat != null) {
        stats.add(dayStat);
      }
    }

    return stats;
  }

  /// Get all registered devices
  List<DeviceInfo> getDevices() {
    return _deviceBox!.values.toList();
  }

  /// Send calibration command to device
  void calibrateDevice(String deviceId) {
    mqttService.sendCommand(deviceId, {
      'command': 'calibrate',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Send configuration update to device
  void updateDeviceConfig(
    String deviceId, {
    int? sampleRate,
    double? threshold,
    int? minInterval,
    bool? debugMode,
  }) {
    final config = <String, dynamic>{
      'command': 'update_config',
    };

    if (sampleRate != null) config['sample_rate'] = sampleRate;
    if (threshold != null) config['threshold'] = threshold;
    if (minInterval != null) config['min_interval'] = minInterval;
    if (debugMode != null) config['debug_mode'] = debugMode;

    mqttService.sendCommand(deviceId, config);
  }

  /// Export stats to CSV format
  Future<String> exportStatsToCSV(DateTime start, DateTime end) async {
    final stats = await getStatsRange(start, end);

    final buffer = StringBuffer();
    buffer.writeln('Date,Steps,Distance (m),Calories,Active Minutes');

    for (final stat in stats) {
      buffer.writeln('${stat.date.toIso8601String().split('T')[0]},'
          '${stat.totalSteps},'
          '${stat.distanceMeters.toStringAsFixed(2)},'
          '${stat.caloriesBurned.toStringAsFixed(2)},'
          '${stat.activeMinutes}');
    }

    return buffer.toString();
  }

  /// Dispose resources
  void dispose() {
    _stepsController.close();
    _cadenceController.close();
    _batteryController.close();
  }
}
