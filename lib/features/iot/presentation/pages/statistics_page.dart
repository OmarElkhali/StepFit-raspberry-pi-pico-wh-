import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:flutter_steps_tracker/core/data/services/stats_tracker.dart';
import 'package:flutter_steps_tracker/core/data/services/database_service.dart';
import 'dart:math' as math;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 0; // 0: Semaine, 1: Mois
  final StatsTracker _statsTracker = StatsTracker();

  // Données chargées depuis la base de données
  List<double> weeklySteps = [];
  List<double> weeklyDistance = [];
  List<double> weeklyCalories = [];
  List<double> monthlySteps = [];
  List<double> monthlyDistance = [];
  List<double> monthlyCalories = [];

  // Records
  DailyStats? stepsRecord;
  DailyStats? distanceRecord;
  DailyStats? caloriesRecord;
  int currentStreak = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Charger les statistiques hebdomadaires
    final weeklyData = await _statsTracker.getWeeklyStats();

    // Remplir avec des 0 si certains jours manquent (max 7 jours)
    weeklySteps = List.filled(7, 0.0);
    weeklyDistance = List.filled(7, 0.0);
    weeklyCalories = List.filled(7, 0.0);

    for (int i = 0; i < weeklyData.length && i < 7; i++) {
      weeklySteps[i] = weeklyData[i].steps.toDouble();
      weeklyDistance[i] = weeklyData[i].distance;
      weeklyCalories[i] = weeklyData[i].calories.toDouble();
    }

    // Charger les statistiques mensuelles
    final monthlyData = await _statsTracker.getMonthlyStats();

    monthlySteps = List.filled(30, 0.0);
    monthlyDistance = List.filled(30, 0.0);
    monthlyCalories = List.filled(30, 0.0);

    for (int i = 0; i < monthlyData.length && i < 30; i++) {
      monthlySteps[i] = monthlyData[i].steps.toDouble();
      monthlyDistance[i] = monthlyData[i].distance;
      monthlyCalories[i] = monthlyData[i].calories.toDouble();
    }

    // Charger les records
    final records = await _statsTracker.getRecords();
    stepsRecord = records['steps'];
    distanceRecord = records['distance'];
    caloriesRecord = records['calories'];

    // Charger le streak (utilise 10000 comme objectif par défaut)
    final db = DatabaseService();
    currentStreak = await db.getCurrentStreak(10000);

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                'Statistiques',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // TODO: Implémenter le partage
                  },
                ),
              ],
            ),

            // Sélecteur de période
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildPeriodSelector(isDark),
              ),
            ),

            // Onglets
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color:
                      isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.kPrimaryColor,
                    labelColor: AppColors.kPrimaryColor,
                    unselectedLabelColor:
                        isDark ? Colors.white54 : Colors.black54,
                    tabs: const [
                      Tab(
                          text: 'Pas',
                          icon: Icon(Icons.directions_walk, size: 20)),
                      Tab(
                          text: 'Distance',
                          icon: Icon(Icons.straighten, size: 20)),
                      Tab(
                          text: 'Calories',
                          icon: Icon(Icons.local_fire_department, size: 20)),
                    ],
                  ),
                ),
              ),
            ),

            // Contenu des onglets
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStepsTab(isDark),
                  _buildDistanceTab(isDark),
                  _buildCaloriesTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(child: _buildPeriodButton('Semaine', 0, isDark)),
            const SizedBox(width: 8),
            Expanded(child: _buildPeriodButton('Mois', 1, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String label, int index, bool isDark) {
    final isSelected = _selectedPeriod == index;
    return InkWell(
      onTap: () {
        setState(() => _selectedPeriod = index);
        _loadData();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _buildStepsTab(bool isDark) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
      );
    }

    final data = _selectedPeriod == 0 ? weeklySteps : monthlySteps;
    final total = data.fold<double>(0, (sum, val) => sum + val);
    final avg = data.isNotEmpty ? (total / data.length) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Total', '${total.toInt()}', 'pas',
                      Icons.directions_walk, isDark)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard('Moyenne', '${avg.toInt()}', 'pas/jour',
                      Icons.trending_up, isDark)),
            ],
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            _selectedPeriod == 0
                ? 'Évolution hebdomadaire'
                : 'Évolution mensuelle',
            _buildBarChart(data, AppColors.kPrimaryColor, isDark),
            isDark,
          ),
          const SizedBox(height: 16),
          _buildRecordsSection(isDark),
        ],
      ),
    );
  }

  Widget _buildDistanceTab(bool isDark) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(color: AppColors.kPrimaryColor));
    }

    final data = _selectedPeriod == 0 ? weeklyDistance : monthlyDistance;
    final total = data.fold<double>(0, (sum, val) => sum + val);
    final avg = data.isNotEmpty ? (total / data.length) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Total', total.toStringAsFixed(1), 'km',
                      Icons.straighten, isDark)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard('Moyenne', avg.toStringAsFixed(1),
                      'km/jour', Icons.trending_up, isDark)),
            ],
          ),
          const SizedBox(height: 16),
          _buildChartCard('Distance parcourue',
              _buildLineChart(data, Colors.green, isDark), isDark),
        ],
      ),
    );
  }

  Widget _buildCaloriesTab(bool isDark) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(color: AppColors.kPrimaryColor));
    }

    final data = _selectedPeriod == 0 ? weeklyCalories : monthlyCalories;
    final total = data.fold<double>(0, (sum, val) => sum + val);
    final avg = data.isNotEmpty ? (total / data.length) : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Total', '${total.toInt()}', 'kcal',
                      Icons.local_fire_department, isDark)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard('Moyenne', '${avg.toInt()}',
                      'kcal/jour', Icons.trending_up, isDark)),
            ],
          ),
          const SizedBox(height: 16),
          _buildChartCard('Calories brûlées',
              _buildAreaChart(data, AppColors.kPrimaryColor, isDark), isDark),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, String unit, IconData icon, bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: AppColors.kPrimaryColor, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.black38),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart, bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(height: 250, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(List<double> data, Color color, bool isDark) {
    final maxVal = data.isEmpty ? 1.0 : data.reduce(math.max);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: isDark ? Colors.white : Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()}',
                TextStyle(
                    color: isDark ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                return Text(
                  days[value.toInt() % 7],
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.black12,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data[index],
                color: color,
                width: 16,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLineChart(List<double> data, Color color, bool isDark) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.black12,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                return Text(
                  days[value.toInt() % 7],
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                data.length, (index) => FlSpot(index.toDouble(), data[index])),
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData:
                BarAreaData(show: true, color: color.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaChart(List<double> data, Color color, bool isDark) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.black12,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                return Text(
                  days[value.toInt() % 7],
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 12),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                data.length, (index) => FlSpot(index.toDouble(), data[index])),
            isCurved: true,
            color: color,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.5), color.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsSection(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events,
                    color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Records Personnels',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRecordItem(
                'Plus de pas en un jour',
                stepsRecord != null ? '${stepsRecord!.steps}' : '0',
                Icons.directions_walk,
                isDark),
            const SizedBox(height: 12),
            _buildRecordItem(
                'Plus longue distance',
                distanceRecord != null
                    ? '${distanceRecord!.distance.toStringAsFixed(1)} km'
                    : '0 km',
                Icons.straighten,
                isDark),
            const SizedBox(height: 12),
            _buildRecordItem(
                'Plus de calories brûlées',
                caloriesRecord != null
                    ? '${caloriesRecord!.calories} kcal'
                    : '0 kcal',
                Icons.local_fire_department,
                isDark),
            const SizedBox(height: 12),
            _buildRecordItem('Plus longue série', '$currentStreak jours',
                Icons.local_fire_department, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordItem(
      String title, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.kBlackMedium : AppColors.kWhiteOff,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.kPrimaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              color: isDark ? Colors.white38 : Colors.black38, size: 16),
        ],
      ),
    );
  }
}
