/// MQTT Configuration for IoT Step Tracker
class MqttConfig {
  // Default MQTT Broker Settings
  static const String defaultBroker = 'broker.hivemq.com';
  static const int defaultPort = 1883;
  static const String? defaultUsername = null;
  static const String? defaultPassword = null;

  // Local Mosquitto Broker (uncomment to use)
  // static const String defaultBroker = '192.168.1.100';
  // static const int defaultPort = 1883;

  // HiveMQ Cloud (uncomment and configure)
  // static const String defaultBroker = 'YOUR_CLUSTER.s1.eu.hivemq.cloud';
  // static const int defaultPort = 8883; // TLS
  // static const String? defaultUsername = 'your_username';
  // static const String? defaultPassword = 'your_password';

  // Topics
  static String telemetryTopic(String deviceId) =>
      'devices/$deviceId/telemetry';
  static String accelTopic(String deviceId) => 'devices/$deviceId/accel';
  static String commandTopic(String deviceId) => 'devices/$deviceId/commands';

  // Connection Settings
  static const int keepAlivePeriod = 60; // seconds
  static const bool autoReconnect = true;
  static const int connectionTimeout = 30; // seconds

  // QoS Levels
  static const int telemetryQos = 1; // At least once
  static const int commandQos = 1;
  static const int accelQos = 0; // At most once (for high frequency data)
}

/// Device Configuration Defaults
class DeviceConfig {
  // Step Detection Parameters
  static const int defaultSampleRate = 50; // Hz
  static const double defaultThreshold = 1.15; // g
  static const int defaultMinInterval = 300; // ms
  static const double defaultFilterAlpha = 0.9;

  // Telemetry
  static const int defaultSendInterval = 5; // seconds
  static const bool defaultDebugMode = false;
}

/// User Profile Defaults
class UserProfileDefaults {
  static const double defaultHeight = 170.0; // cm
  static const double defaultWeight = 70.0; // kg
  static const int defaultAge = 30;
  static const String defaultGender = 'male';
  static const int defaultDailyGoal = 10000; // steps
}

/// App Configuration
class AppConfig {
  // Storage
  static const String hiveBoxDailyStats = 'daily_stats';
  static const String hiveBoxUserProfile = 'user_profile';
  static const String hiveBoxDevices = 'devices';
  static const String hiveBoxAccelEvents = 'accel_events';

  // Background Sync (Android)
  static const String workManagerTaskName = 'step_sync';
  static const Duration backgroundSyncInterval = Duration(minutes: 15);

  // Notifications
  static const bool enableNotifications = true;
  static const String notificationChannelId = 'step_tracker_channel';
  static const String notificationChannelName = 'Step Tracker';

  // Data Retention
  static const int maxAccelEventsStored = 10000; // Max raw events to keep
  static const int statsRetentionDays = 365; // Keep 1 year of stats

  // Export
  static const String csvExportDateFormat = 'yyyy-MM-dd';
  static const String csvExportFilenamePrefix = 'steps_data_';
}

/// Feature Flags
class FeatureFlags {
  static const bool enableFirebase = false; // Disable Firebase for pure IoT
  static const bool enableDebugMode = true; // Show debug options
  static const bool enableMultiDevice = true; // Support multiple Pico W devices
  static const bool enableCloudSync = false; // Future: cloud backup
  static const bool enableSocialFeatures = false; // Leaderboard, sharing, etc.
}
