import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/notification_service.dart';
import 'package:flutter_steps_tracker/core/data/services/achievement_service.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotificationService _notificationService = NotificationService();

  bool _dailyReminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _achievementsEnabled = true;
  bool _goalsEnabled = true;
  bool _challengesEnabled = true;
  bool _inactivityEnabled = false;
  bool _streaksEnabled = true;
  bool _progressEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _dailyReminderEnabled = await _notificationService.isDailyReminderEnabled();
    final reminderTime = await _notificationService.getDailyReminderTime();
    if (reminderTime != null) {
      _reminderTime = TimeOfDay(
        hour: reminderTime['hour']!,
        minute: reminderTime['minute']!,
      );
    }
    setState(() {});
  }

  Future<void> _selectTime() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: AppColors.kPrimaryColor,
                    onPrimary: Colors.white,
                    surface: AppColors.kDarkCardColor,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.kPrimaryColor,
                    onPrimary: Colors.white,
                    surface: AppColors.kWhiteColor,
                    onSurface: Colors.black87,
                  ),
                ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
      if (_dailyReminderEnabled) {
        await _notificationService.scheduleDailyReminder(
          hour: _reminderTime.hour,
          minute: _reminderTime.minute,
        );
        _showSnackBar('✓ Rappel mis à jour pour ${_formatTime(_reminderTime)}');
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.kDarkBackgroundColor : AppColors.kWhiteColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.kPrimaryColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Contenu
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Rappel quotidien
                    _buildDailyReminderSection(isDark),
                    const SizedBox(height: 16),

                    // Types de notifications
                    _buildNotificationTypesSection(isDark),
                    const SizedBox(height: 16),

                    // Actions de test
                    _buildTestSection(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyReminderSection(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.alarm, color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Rappel Quotidien',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Recevez une notification quotidienne pour vous rappeler de marcher',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activer',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (_dailyReminderEnabled)
                      Text(
                        'Heure: ${_formatTime(_reminderTime)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                  ],
                ),
                Switch(
                  value: _dailyReminderEnabled,
                  activeColor: AppColors.kPrimaryColor,
                  onChanged: (value) async {
                    setState(() => _dailyReminderEnabled = value);
                    if (value) {
                      await _notificationService.scheduleDailyReminder(
                        hour: _reminderTime.hour,
                        minute: _reminderTime.minute,
                      );
                      _showSnackBar(
                          '✓ Rappel activé pour ${_formatTime(_reminderTime)}');
                    } else {
                      await _notificationService.cancelDailyReminder();
                      _showSnackBar('✓ Rappel désactivé');
                    }
                  },
                ),
              ],
            ),
            if (_dailyReminderEnabled) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.kPrimaryColor.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, color: AppColors.kPrimaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Modifier l\'heure',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypesSection(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications_active,
                    color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Types de Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationSwitch(
              '🏆 Succès',
              'Notifier quand vous débloquez un succès',
              _achievementsEnabled,
              (value) => setState(() => _achievementsEnabled = value),
              isDark,
            ),
            _buildDivider(isDark),
            _buildNotificationSwitch(
              '🎯 Objectifs',
              'Notifier quand vous atteignez un objectif',
              _goalsEnabled,
              (value) => setState(() => _goalsEnabled = value),
              isDark,
            ),
            _buildDivider(isDark),
            _buildNotificationSwitch(
              '⭐ Défis',
              'Notifier quand vous terminez un défi',
              _challengesEnabled,
              (value) => setState(() => _challengesEnabled = value),
              isDark,
            ),
            _buildDivider(isDark),
            _buildNotificationSwitch(
              '🔥 Séries',
              'Notifier pour vos séries de jours actifs',
              _streaksEnabled,
              (value) => setState(() => _streaksEnabled = value),
              isDark,
            ),
            _buildDivider(isDark),
            _buildNotificationSwitch(
              '💤 Inactivité',
              'Alertes après 2h d\'inactivité',
              _inactivityEnabled,
              (value) => setState(() => _inactivityEnabled = value),
              isDark,
            ),
            _buildDivider(isDark),
            _buildNotificationSwitch(
              '📊 Progression',
              'Notifications de progression (discret)',
              _progressEnabled,
              (value) => setState(() => _progressEnabled = value),
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.kPrimaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        color: isDark ? Colors.white12 : Colors.black12,
        thickness: 1,
      ),
    );
  }

  Widget _buildTestSection(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Tester les Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTestButton(
              'Tester Succès',
              Icons.emoji_events,
              AppColors.kPrimaryColor,
              isDark,
              () async {
                await _notificationService.showAchievementNotification(
                  Achievement(
                    id: 'test',
                    title: 'Test Succès',
                    description: 'Ceci est une notification de test',
                    type: 'steps',
                    requirement: 100,
                    icon: Icons.star,
                    color: AppColors.kPrimaryColor,
                    isUnlocked: false,
                  ),
                );
                _showSnackBar('✓ Notification de succès envoyée');
              },
            ),
            const SizedBox(height: 12),
            _buildTestButton(
              'Tester Objectif',
              Icons.flag,
              Colors.green,
              isDark,
              () async {
                await _notificationService.showGoalReachedNotification(
                  steps: 10000,
                  goal: 10000,
                );
                _showSnackBar('✓ Notification d\'objectif envoyée');
              },
            ),
            const SizedBox(height: 12),
            _buildTestButton(
              'Tester Inactivité',
              Icons.access_time,
              AppColors.kPrimaryLight,
              isDark,
              () async {
                await _notificationService.showInactivityAlert();
                _showSnackBar('✓ Alerte d\'inactivité envoyée');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(
    String label,
    IconData icon,
    Color color,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
