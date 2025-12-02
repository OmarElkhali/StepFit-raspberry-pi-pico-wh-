import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter_steps_tracker/generated/l10n.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  // Données réelles depuis SQLite - en attente de connexion IoT
  final bool hasData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).history,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kPrimaryColor),
      ),
      body: !hasData
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).noDataAvailable,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).connectIot,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Statistiques résumées
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kPrimaryColor,
                        AppColors.kSecondaryColor
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Cette semaine',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Total', '12,456', 'pas'),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildStat('Moyenne', '1,779', 'pas/jour'),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          _buildStat('Distance', '8.7', 'km'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Liste des activités
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      final date =
                          DateTime.now().subtract(Duration(days: index));
                      final steps = 5000 + (index * 300);
                      final distance = (steps * 0.0007).toStringAsFixed(2);
                      final calories = (steps * 0.04).toStringAsFixed(0);

                      return _buildHistoryCard(
                        context,
                        date: date,
                        steps: steps,
                        distance: distance,
                        calories: calories,
                        isToday: index == 0,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStat(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required DateTime date,
    required int steps,
    required String distance,
    required String calories,
    bool isToday = false,
  }) {
    final dayFormat = DateFormat('EEEE', 'fr_FR');
    final dateFormat = DateFormat('d MMM', 'fr_FR');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.kLightOrange.withOpacity(0.3)
            : (isDark ? Colors.grey[850] : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday
              ? AppColors.kPrimaryColor
              : Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.2) ??
                  Colors.grey.withOpacity(0.2),
          width: isToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date
          Container(
            width: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.kPrimaryColor
                  : (isDark ? Colors.grey[800] : Colors.grey[200]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isToday
                        ? Colors.white
                        : Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateFormat.format(date).split(' ')[1].toUpperCase(),
                  style: TextStyle(
                    color: isToday
                        ? Colors.white.withOpacity(0.8)
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? "Aujourd'hui" : dayFormat.format(date),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 16,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.directions_walk,
                      '$steps pas',
                      AppColors.kPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.straighten,
                      '$distance km',
                      AppColors.kSecondaryColor,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.local_fire_department,
                      '$calories cal',
                      Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Icône
          Icon(
            steps >= 8000 ? Icons.check_circle : Icons.trending_up,
            color: steps >= 8000 ? Colors.green : AppColors.kPrimaryColor,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Builder(
      builder: (context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
