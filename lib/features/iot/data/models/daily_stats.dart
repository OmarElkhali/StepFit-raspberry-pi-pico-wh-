import 'package:hive/hive.dart';

part 'daily_stats.g.dart';

/// Model for daily statistics stored in Hive
@HiveType(typeId: 0)
class DailyStats extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int totalSteps;

  @HiveField(2)
  final double distanceMeters;

  @HiveField(3)
  final double caloriesBurned;

  @HiveField(4)
  final int activeMinutes;

  @HiveField(5)
  final String deviceId;

  DailyStats({
    required this.date,
    required this.totalSteps,
    required this.distanceMeters,
    required this.caloriesBurned,
    required this.activeMinutes,
    required this.deviceId,
  });

  /// Calculate distance from steps using user's stride length
  static double calculateDistance(int steps, double strideMeters) {
    return steps * strideMeters;
  }

  /// Estimate calories burned (simplified formula)
  /// calories = steps * weight_kg * 0.000435
  static double calculateCalories(int steps, double weightKg) {
    return steps * weightKg * 0.000435;
  }
}

/// Model for user profile stored in Hive
@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final double heightCm;

  @HiveField(2)
  final double weightKg;

  @HiveField(3)
  final int age;

  @HiveField(4)
  final String gender; // 'male' or 'female'

  @HiveField(5)
  final double strideLength; // in meters

  @HiveField(6)
  final int dailyGoal;

  UserProfile({
    required this.userId,
    required this.heightCm,
    required this.weightKg,
    required this.age,
    required this.gender,
    double? strideLength,
    this.dailyGoal = 10000,
  }) : strideLength = strideLength ?? _calculateStride(heightCm, gender);

  /// Calculate stride length based on height and gender
  /// Average stride = height * 0.413 (women) or height * 0.415 (men)
  static double _calculateStride(double heightCm, String gender) {
    final factor = gender.toLowerCase() == 'male' ? 0.415 : 0.413;
    return (heightCm / 100) * factor;
  }
}

/// Model for device info stored in Hive
@HiveType(typeId: 2)
class DeviceInfo extends HiveObject {
  @HiveField(0)
  final String deviceId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String ipAddress;

  @HiveField(3)
  DateTime? lastSeen;

  @HiveField(4)
  final bool isActive;

  DeviceInfo({
    required this.deviceId,
    required this.name,
    required this.ipAddress,
    this.lastSeen,
    this.isActive = true,
  });
}

/// Model for raw accelerometer events (optional, for debugging)
@HiveType(typeId: 3)
class AccelEvent extends HiveObject {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final double x;

  @HiveField(2)
  final double y;

  @HiveField(3)
  final double z;

  @HiveField(4)
  final double magnitude;

  @HiveField(5)
  final String deviceId;

  AccelEvent({
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
    required this.magnitude,
    required this.deviceId,
  });
}
