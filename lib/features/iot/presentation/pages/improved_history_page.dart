import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/database_service.dart';
import 'package:flutter_steps_tracker/core/data/services/stats_tracker.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:intl/intl.dart';

class ImprovedHistoryPage extends StatefulWidget {
  const ImprovedHistoryPage({Key? key}) : super(key: key);

  @override
  State<ImprovedHistoryPage> createState() => _ImprovedHistoryPageState();
}

class _ImprovedHistoryPageState extends State<ImprovedHistoryPage> {
  final StatsTracker _statsTracker = StatsTracker();
  List<DailyStats> _allStats = [];
  Map<String, dynamic> _lifetimeStats = {};
  bool _isLoading = true;
  int _selectedMonthIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final db = DatabaseService();
    _allStats = await db.getAllStats();
    _lifetimeStats = await _statsTracker.getLifetimeStats();

    setState(() => _isLoading = false);
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
                'Historique',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: _showCalendarPicker,
                ),
              ],
            ),

            // Statistiques Lifetime
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildLifetimeSection(isDark),
              ),
            ),

            // Liste de l'historique
            if (_isLoading)
              SliverFillRemaining(
                child: Center(
                  child:
                      CircularProgressIndicator(color: AppColors.kPrimaryColor),
                ),
              )
            else if (_allStats.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun historique disponible',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Commencez à marcher pour voir vos statistiques',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildHistoryCard(_allStats[index], isDark),
                      );
                    },
                    childCount: _allStats.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifetimeSection(bool isDark) {
    final totalSteps = _lifetimeStats['totalSteps'] ?? 0;
    final totalDistance = _lifetimeStats['totalDistance'] ?? 0.0;
    final totalCalories = _lifetimeStats['totalCalories'] ?? 0;
    final activeDays = _lifetimeStats['activeDays'] ?? 0;

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
                Icon(Icons.emoji_events,
                    color: AppColors.kPrimaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Statistiques Totales',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildLifetimeStatCard(
                    'Total Pas',
                    _formatNumber(totalSteps),
                    Icons.directions_walk,
                    AppColors.kPrimaryColor,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLifetimeStatCard(
                    'Distance',
                    '${(totalDistance as double).toStringAsFixed(1)} km',
                    Icons.straighten,
                    AppColors.kPrimaryLight,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLifetimeStatCard(
                    'Calories',
                    _formatNumber(totalCalories),
                    Icons.local_fire_department,
                    AppColors.kPrimaryDark,
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLifetimeStatCard(
                    'Jours Actifs',
                    '$activeDays',
                    Icons.calendar_today,
                    AppColors.kPrimaryColor,
                    isDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifetimeStatCard(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(DailyStats stats, bool isDark) {
    final date = DateTime.parse(stats.date);
    final formattedDate = DateFormat('EEEE d MMMM yyyy', 'fr').format(date);
    final dayName = DateFormat('EEE', 'fr').format(date);
    final dayNumber = date.day;

    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetailsDialog(stats, isDark),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date badge
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kPrimaryColor,
                      ),
                    ),
                    Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildMiniStat(
                          Icons.directions_walk,
                          '${stats.steps}',
                          AppColors.kPrimaryColor,
                          isDark,
                        ),
                        const SizedBox(width: 12),
                        _buildMiniStat(
                          Icons.straighten,
                          '${stats.distance.toStringAsFixed(1)} km',
                          AppColors.kPrimaryLight,
                          isDark,
                        ),
                        const SizedBox(width: 12),
                        _buildMiniStat(
                          Icons.local_fire_department,
                          '${stats.calories}',
                          AppColors.kPrimaryDark,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, Color color, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  void _showDetailsDialog(DailyStats stats, bool isDark) {
    final date = DateTime.parse(stats.date);
    final formattedDate = DateFormat('d MMMM yyyy', 'fr').format(date);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor:
            isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 60,
                color: AppColors.kPrimaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Pas', '${stats.steps}', Icons.directions_walk,
                  AppColors.kPrimaryColor, isDark),
              const SizedBox(height: 12),
              _buildDetailRow(
                  'Distance',
                  '${stats.distance.toStringAsFixed(2)} km',
                  Icons.straighten,
                  AppColors.kPrimaryLight,
                  isDark),
              const SizedBox(height: 12),
              _buildDetailRow('Calories', '${stats.calories} kcal',
                  Icons.local_fire_department, AppColors.kPrimaryDark, isDark),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendarPicker() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sélecteur de calendrier à venir'),
        backgroundColor: AppColors.kPrimaryColor,
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
