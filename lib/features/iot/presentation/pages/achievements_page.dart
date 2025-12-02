import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/achievement_service.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage>
    with TickerProviderStateMixin {
  final AchievementService _achievementService = AchievementService();
  late AnimationController _headerController;

  @override
  void initState() {
    super.initState();
    _achievementService.initialize();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unlockedCount = _achievementService.unlockedCount;
    final totalCount = _achievementService.achievements.length;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.kDarkBackgroundColor : AppColors.kWhiteColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar personnalisé
            _buildSliverAppBar(unlockedCount, totalCount, isDark),

            // Points et Streak
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildStatsSection(isDark),
              ),
            ),

            // Section Défis Quotidiens
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildDailyChallengesSection(isDark),
              ),
            ),

            // Grid des Achievements
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _buildAchievementsGrid(isDark),
            ),

            // Espacement en bas
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(int unlockedCount, int totalCount, bool isDark) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.kPrimaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: AppColors.kOrangeGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.emoji_events,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              const Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$unlockedCount / $totalCount débloqués',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.stars,
                    size: 40,
                    color: AppColors.kPrimaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_achievementService.totalPoints}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Points',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 40,
                    color: AppColors.kPrimaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_achievementService.currentStreak}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Jours de suite',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChallengesSection(bool isDark) {
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
                Icon(
                  Icons.flag,
                  color: AppColors.kPrimaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Défis Quotidiens',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._achievementService.dailyChallenges.map((challenge) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildChallengeCard(challenge, isDark),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(DailyChallenge challenge, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.kBlackMedium : AppColors.kWhiteOff,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.kBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: challenge.isCompleted
                      ? Colors.green.withOpacity(0.2)
                      : AppColors.kPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  challenge.icon,
                  color: challenge.isCompleted
                      ? Colors.green
                      : AppColors.kPrimaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (challenge.isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${challenge.reward}pts',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: challenge.progressPercentage,
                    minHeight: 8,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      challenge.isCompleted
                          ? Colors.green
                          : AppColors.kPrimaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${challenge.progress}/${challenge.target}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(bool isDark) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final achievement = _achievementService.achievements[index];
          return _buildAchievementCard(achievement, isDark);
        },
        childCount: _achievementService.achievements.length,
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isDark) {
    return GestureDetector(
      onTap: () => _showAchievementDetails(achievement, isDark),
      child: Card(
        color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
        elevation: achievement.isUnlocked ? 4 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: achievement.isUnlocked
                          ? AppColors.kPrimaryColor.withOpacity(0.2)
                          : (isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200),
                    ),
                  ),
                  Icon(
                    achievement.icon,
                    size: 50,
                    color: achievement.isUnlocked
                        ? AppColors.kPrimaryColor
                        : Colors.grey,
                  ),
                  if (!achievement.isUnlocked)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white70,
                        size: 30,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: achievement.isUnlocked
                      ? (isDark ? Colors.white : Colors.black87)
                      : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: achievement.isUnlocked
                      ? (isDark ? Colors.white54 : Colors.black54)
                      : Colors.grey.withOpacity(0.5),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement, bool isDark) {
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
                achievement.icon,
                size: 80,
                color: achievement.isUnlocked
                    ? AppColors.kPrimaryColor
                    : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                achievement.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (achievement.isUnlocked && achievement.unlockedAt != null)
                Text(
                  'Débloqué le ${achievement.unlockedAt!.day}/${achievement.unlockedAt!.month}/${achievement.unlockedAt!.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const SizedBox(height: 20),
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
}
