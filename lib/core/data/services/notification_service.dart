import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_steps_tracker/core/data/services/achievement_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  int _notificationIdCounter = 0;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _requestPermissions();

    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // Could navigate to specific page based on response.payload
  }

  // Schedule daily reminder
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', hour);
    await prefs.setInt('reminder_minute', minute);
    await prefs.setBool('reminder_enabled', true);

    await _notificationsPlugin.zonedSchedule(
      0, // ID unique pour le rappel quotidien
      '⏰ Rappel quotidien',
      'N\'oubliez pas de marcher aujourd\'hui ! Atteignez votre objectif de pas 🚶‍♂️',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Rappels quotidiens',
          channelDescription: 'Rappels quotidiens pour marcher',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Cancel daily reminder
  Future<void> cancelDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_enabled', false);
    await _notificationsPlugin.cancel(0);
  }

  // Check if daily reminder is enabled
  Future<bool> isDailyReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('reminder_enabled') ?? false;
  }

  // Get daily reminder time
  Future<Map<String, int>?> getDailyReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('reminder_hour');
    final minute = prefs.getInt('reminder_minute');
    if (hour != null && minute != null) {
      return {'hour': hour, 'minute': minute};
    }
    return null;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Show achievement unlocked notification
  Future<void> showAchievementNotification(Achievement achievement) async {
    await _notificationsPlugin.show(
      _getNextNotificationId(),
      '🏆 Nouveau succès débloqué !',
      achievement.title,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'achievements',
          'Succès',
          channelDescription: 'Notifications pour les succès débloqués',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(
            achievement.description,
            contentTitle: '🏆 ${achievement.title}',
          ),
          color: const Color(0xFFFFD700), // Gold color
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // Show goal reached notification
  Future<void> showGoalReachedNotification({
    required int steps,
    required int goal,
  }) async {
    await _notificationsPlugin.show(
      _getNextNotificationId(),
      '🎯 Objectif atteint !',
      'Bravo ! Vous avez atteint votre objectif de $goal pas 🎉',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'goals',
          'Objectifs',
          channelDescription: 'Notifications quand un objectif est atteint',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(
            'Vous avez marché $steps pas aujourd\'hui. Continuez comme ça !',
            contentTitle: '🎯 Objectif atteint !',
          ),
          color: const Color(0xFF4CAF50), // Green color
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // Show challenge completed notification
  Future<void> showChallengeCompletedNotification(
      DailyChallenge challenge) async {
    await _notificationsPlugin.show(
      _getNextNotificationId(),
      '⭐ Défi terminé !',
      challenge.title,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'challenges',
          'Défis',
          channelDescription: 'Notifications pour les défis terminés',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(
            challenge.description,
            contentTitle: '⭐ ${challenge.title}',
          ),
          color: const Color(0xFF2196F3), // Blue color
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // Show inactivity alert
  Future<void> showInactivityAlert() async {
    await _notificationsPlugin.show(
      _getNextNotificationId(),
      '💤 Temps de bouger !',
      'Vous n\'avez pas bougé depuis 2 heures. Faites quelques pas ! 🚶‍♂️',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'inactivity',
          'Inactivité',
          channelDescription: 'Alertes d\'inactivité prolongée',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFFF9800), // Orange color
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // Show milestone notification
  Future<void> showMilestoneNotification({
    required String title,
    required String message,
  }) async {
    await _notificationsPlugin.show(
      _getNextNotificationId(),
      '🎊 $title',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'milestones',
          'Jalons',
          channelDescription: 'Notifications pour les jalons importants',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF9C27B0), // Purple color
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // Show streak notification
  Future<void> showStreakNotification(int streakDays) async {
    final String message;
    if (streakDays == 7) {
      message = 'Une semaine complète ! Continuez sur cette lancée 🔥';
    } else if (streakDays == 30) {
      message = 'Un mois entier ! Vous êtes incroyable 🔥🔥🔥';
    } else if (streakDays % 10 == 0) {
      message = '$streakDays jours consécutifs ! Impressionnant 🔥';
    } else {
      message = '$streakDays jours d\'affilée ! Ne brisez pas la chaîne 🔥';
    }

    await _notificationsPlugin.show(
      _getNextNotificationId(),
      '🔥 Série en cours !',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streaks',
          'Séries',
          channelDescription: 'Notifications pour les séries de jours actifs',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFFF5722), // Deep Orange color
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // Show progress notification (non-intrusive)
  Future<void> showProgressNotification({
    required int currentSteps,
    required int goalSteps,
  }) async {
    final progress = (currentSteps / goalSteps * 100).toInt();
    final remaining = goalSteps - currentSteps;

    await _notificationsPlugin.show(
      _getNextNotificationId(),
      'Progression: $progress%',
      'Plus que $remaining pas pour atteindre votre objectif !',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'progress',
          'Progression',
          channelDescription: 'Notifications de progression vers l\'objectif',
          importance: Importance.low,
          priority: Priority.low,
          icon: '@mipmap/ic_launcher',
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: 100,
          color: Color(0xFF03A9F4), // Light Blue color
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: true,
          presentSound: false,
        ),
      ),
    );
  }

  int _getNextNotificationId() {
    _notificationIdCounter++;
    if (_notificationIdCounter > 9999) {
      _notificationIdCounter = 1;
    }
    return _notificationIdCounter;
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Get pending notifications count
  Future<int> getPendingNotificationsCount() async {
    final pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();
    return pendingNotifications.length;
  }
}
