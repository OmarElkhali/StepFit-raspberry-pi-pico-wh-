import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/stats_tracker.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/widgets/professional_widgets.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/notification_settings_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/export_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EnhancedProfilePage extends StatefulWidget {
  const EnhancedProfilePage({Key? key}) : super(key: key);

  @override
  State<EnhancedProfilePage> createState() => _EnhancedProfilePageState();
}

class _EnhancedProfilePageState extends State<EnhancedProfilePage> {
  final StatsTracker _statsTracker = StatsTracker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _userName = 'Utilisateur';
  String? _avatarPath;
  int _goalSteps = 10000;
  double _goalDistance = 5.0;
  int _goalCalories = 400;
  double _weight = 70.0;
  double _height = 170.0;
  int _age = 25;

  Map<String, dynamic> _lifetimeStats = {};
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadLifetimeStats();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Utilisateur';
      _avatarPath = prefs.getString('avatar_path');
      _goalSteps = prefs.getInt('goal_steps') ?? 10000;
      _goalDistance = prefs.getDouble('goal_distance') ?? 5.0;
      _goalCalories = prefs.getInt('goal_calories') ?? 400;
      _weight = prefs.getDouble('user_weight') ?? 70.0;
      _height = prefs.getDouble('user_height') ?? 170.0;
      _age = prefs.getInt('user_age') ?? 25;

      _nameController.text = _userName;
      _weightController.text = _weight.toString();
      _heightController.text = _height.toString();
      _ageController.text = _age.toString();
    });
  }

  Future<void> _loadLifetimeStats() async {
    setState(() => _isLoading = true);
    _lifetimeStats = await _statsTracker.getLifetimeStats();
    setState(() => _isLoading = false);
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setInt('goal_steps', _goalSteps);
    await prefs.setDouble('goal_distance', _goalDistance);
    await prefs.setInt('goal_calories', _goalCalories);
    await prefs.setDouble(
        'user_weight', double.tryParse(_weightController.text) ?? 70.0);
    await prefs.setDouble(
        'user_height', double.tryParse(_heightController.text) ?? 170.0);
    await prefs.setInt('user_age', int.tryParse(_ageController.text) ?? 25);
    if (_avatarPath != null) {
      await prefs.setString('avatar_path', _avatarPath!);
    }

    setState(() {
      _userName = _nameController.text;
      _weight = double.tryParse(_weightController.text) ?? 70.0;
      _height = double.tryParse(_heightController.text) ?? 170.0;
      _age = int.tryParse(_ageController.text) ?? 25;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Profil mis à jour'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarPath = pickedFile.path;
      });
    }
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
                'Profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.save : Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_isEditing) {
                      _saveUserData();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
                ),
              ],
            ),

            // Contenu
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Section Avatar et Nom
                    _buildProfileHeader(isDark),
                    const SizedBox(height: 24),

                    // Informations personnelles
                    _buildPersonalInfo(),
                    const SizedBox(height: 16),

                    // Objectifs
                    _buildGoalsSection(),
                    const SizedBox(height: 16),

                    // Statistiques Lifetime
                    _buildLifetimeStats(),
                    const SizedBox(height: 16),

                    // Actions
                    _buildActionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            GestureDetector(
              onTap: _isEditing ? _pickImage : null,
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.kPrimaryColor, width: 3),
                      image: _avatarPath != null
                          ? DecorationImage(
                              image: FileImage(File(_avatarPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _avatarPath == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: isDark ? Colors.white54 : Colors.black38,
                          )
                        : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Nom
            if (_isEditing)
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Votre nom',
                  hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kPrimaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black26),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kPrimaryColor),
                  ),
                ),
              )
            else
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Card3D(
      child: GlassCard(
        opacity: 0.15,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Informations Personnelles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                'Poids', _weightController, 'kg', Icons.monitor_weight),
            const SizedBox(height: 12),
            _buildInfoRow('Taille', _heightController, 'cm', Icons.height),
            const SizedBox(height: 12),
            _buildInfoRow('Âge', _ageController, 'ans', Icons.cake),
            if (!_isEditing) ...[
              const SizedBox(height: 16),
              _buildCalculatedInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, TextEditingController controller,
      String unit, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.6), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        if (_isEditing)
          SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.amber),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
              ),
            ),
          )
        else
          Text(
            '${controller.text} $unit',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildCalculatedInfo() {
    final bmi = _weight / ((_height / 100) * (_height / 100));
    final bmr = _age >= 18
        ? 10 * _weight + 6.25 * _height - 5 * _age + 5 // Homme
        : 10 * _weight + 6.25 * _height - 5 * _age - 161; // Femme

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'IMC',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bmi.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.2),
          ),
          Column(
            children: [
              Text(
                'MB (kcal/jour)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bmr.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Card3D(
      child: GlassCard(
        opacity: 0.15,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Objectifs Quotidiens',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGoalSlider(
              'Pas',
              _goalSteps.toDouble(),
              1000,
              20000,
              1000,
              Icons.directions_walk,
              Colors.blue,
              (value) => setState(() => _goalSteps = value.toInt()),
            ),
            const SizedBox(height: 12),
            _buildGoalSlider(
              'Distance (km)',
              _goalDistance,
              1,
              20,
              0.5,
              Icons.straighten,
              Colors.green,
              (value) => setState(() => _goalDistance = value),
            ),
            const SizedBox(height: 12),
            _buildGoalSlider(
              'Calories',
              _goalCalories.toDouble(),
              100,
              1000,
              50,
              Icons.local_fire_department,
              Colors.deepOrange,
              (value) => setState(() => _goalCalories = value.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSlider(
    String label,
    double value,
    double min,
    double max,
    double divisions,
    IconData icon,
    Color color,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const Spacer(),
            Text(
              label.contains('km')
                  ? value.toStringAsFixed(1)
                  : value.toInt().toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.3),
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / divisions).toInt(),
            onChanged: _isEditing ? onChanged : null,
          ),
        ),
      ],
    );
  }

  Widget _buildLifetimeStats() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    final totalSteps = _lifetimeStats['totalSteps'] ?? 0;
    final totalDistance = _lifetimeStats['totalDistance'] ?? 0.0;
    final totalCalories = _lifetimeStats['totalCalories'] ?? 0;
    final activeDays = _lifetimeStats['activeDays'] ?? 0;
    final avgSteps = _lifetimeStats['avgSteps'] ?? 0;

    return Card3D(
      child: GlassCard(
        opacity: 0.15,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Statistiques Totales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Pas',
                    _formatNumber(totalSteps),
                    Icons.directions_walk,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Distance',
                    '${(totalDistance as double).toStringAsFixed(1)} km',
                    Icons.straighten,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Calories',
                    _formatNumber(totalCalories),
                    Icons.local_fire_department,
                    Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Jours Actifs',
                    '$activeDays',
                    Icons.calendar_today,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, color: Colors.amber, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      const Text(
                        'Moyenne Quotidienne',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '$avgSteps pas',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.4),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card3D(
      child: GlassCard(
        opacity: 0.15,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildActionButton(
              'Paramètres de notifications',
              Icons.notifications,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsPage(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Exporter les données',
              Icons.file_download,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExportPage(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Réinitialiser les statistiques',
              Icons.refresh,
              Colors.orange,
              () => _showResetDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Réinitialiser les statistiques',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir réinitialiser toutes vos statistiques ? Cette action est irréversible.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implémenter la réinitialisation
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité à venir'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Réinitialiser'),
          ),
        ],
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

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
