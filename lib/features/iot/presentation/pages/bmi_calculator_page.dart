import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:flutter_steps_tracker/generated/l10n.dart';

/// Page complète pour calculer l'IMC et les calories brûlées
class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({Key? key}) : super(key: key);

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _durationController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  double? _bmi;
  String _bmiCategory = '';
  Color _categoryColor = Colors.grey;
  String _healthAdvice = '';
  double? _caloriesBurned;
  String _selectedGender = 'male';
  String _selectedActivity = 'walking';

  // MET (Metabolic Equivalent of Task) values pour différentes activités
  final Map<String, double> _activityMET = {
    'walking': 3.5, // Marche normale
    'walking_fast': 4.5, // Marche rapide
    'jogging': 7.0, // Jogging
    'running': 9.8, // Course à pied
    'cycling': 8.0, // Vélo
    'swimming': 8.3, // Natation
    'stairs': 8.8, // Montée d'escaliers
    'yoga': 2.5, // Yoga
    'dancing': 4.8, // Danse
    'gym': 5.5, // Exercices en salle
  };

  final Map<String, String> _activityNames = {
    'walking': '🚶 Marche normale',
    'walking_fast': '🚶‍♂️ Marche rapide',
    'jogging': '🏃 Jogging',
    'running': '🏃‍♂️ Course',
    'cycling': '🚴 Vélo',
    'swimming': '🏊 Natation',
    'stairs': '🪜 Escaliers',
    'yoga': '🧘 Yoga',
    'dancing': '💃 Danse',
    'gym': '🏋️ Gym',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final heightInCm = double.parse(_heightController.text);
      final heightInM = heightInCm / 100;

      setState(() {
        _bmi = weight / (heightInM * heightInM);
        _categorizeBMI();
        _animationController.forward(from: 0);
      });
    }
  }

  void _categorizeBMI() {
    if (_bmi == null) return;

    if (_bmi! < 16) {
      _bmiCategory = 'Maigreur sévère';
      _categoryColor = Colors.red.shade900;
      _healthAdvice =
          '⚠️ Consultez immédiatement un médecin. Votre IMC indique une maigreur sévère qui peut être dangereuse pour votre santé.';
    } else if (_bmi! < 17) {
      _bmiCategory = 'Maigreur modérée';
      _categoryColor = Colors.orange.shade900;
      _healthAdvice =
          '⚠️ Consultez un professionnel de santé. Augmentez progressivement vos apports caloriques avec des aliments nutritifs.';
    } else if (_bmi! < 18.5) {
      _bmiCategory = 'Maigreur légère';
      _categoryColor = Colors.orange;
      _healthAdvice =
          '💡 Essayez d\'augmenter votre apport calorique de manière saine avec des protéines et des glucides complexes.';
    } else if (_bmi! < 25) {
      _bmiCategory = 'Poids normal';
      _categoryColor = Colors.green;
      _healthAdvice =
          '✅ Excellent ! Maintenez votre poids avec une alimentation équilibrée et une activité physique régulière.';
    } else if (_bmi! < 30) {
      _bmiCategory = 'Surpoids';
      _categoryColor = Colors.orange;
      _healthAdvice =
          '💪 Augmentez votre activité physique et adoptez une alimentation plus équilibrée. Visez 30 min d\'exercice par jour.';
    } else if (_bmi! < 35) {
      _bmiCategory = 'Obésité modérée (Classe I)';
      _categoryColor = Colors.orange.shade700;
      _healthAdvice =
          '⚠️ Consultez un nutritionniste. Combinez régime alimentaire équilibré et exercices réguliers adaptés.';
    } else if (_bmi! < 40) {
      _bmiCategory = 'Obésité sévère (Classe II)';
      _categoryColor = Colors.red;
      _healthAdvice =
          '⚠️ Consultez rapidement un médecin. Un suivi médical est recommandé pour une perte de poids progressive et saine.';
    } else {
      _bmiCategory = 'Obésité morbide (Classe III)';
      _categoryColor = Colors.red.shade900;
      _healthAdvice =
          '🚨 Consultez immédiatement un médecin. Un traitement médical spécialisé peut être nécessaire.';
    }
  }

  void _calculateCalories() {
    if (_weightController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Veuillez remplir tous les champs pour calculer les calories'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final weight = double.parse(_weightController.text);
    final duration = double.parse(_durationController.text); // en minutes
    final met = _activityMET[_selectedActivity]!;

    // Formule: Calories = MET × poids (kg) × durée (heures)
    final caloriesBurned = met * weight * (duration / 60);

    setState(() {
      _caloriesBurned = caloriesBurned;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).imcAndCalories,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kPrimaryColor),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec icône
              _buildHeader(),
              const SizedBox(height: 24),

              // Section IMC
              _buildIMCSection(),
              const SizedBox(height: 24),

              // Résultat IMC
              if (_bmi != null) _buildBMIResult(),
              if (_bmi != null) const SizedBox(height: 24),

              // Section Calories
              _buildCaloriesSection(),
              const SizedBox(height: 24),

              // Résultat Calories
              if (_caloriesBurned != null) _buildCaloriesResult(),
              const SizedBox(height: 24),

              // Tableau de référence IMC
              _buildBMIReferenceTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kPrimaryColor, AppColors.kSecondaryColor],
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.monitor_weight,
              color: AppColors.kPrimaryColor,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).imcAndCalories,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  S.of(context).imcCalculation,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIMCSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).imcCalculation,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 16),

          // Genre
          Text(
            S.of(context).gender,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton('male', '👨 ${S.of(context).male}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    _buildGenderButton('female', '👩 ${S.of(context).female}'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Poids
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: S.of(context).weight,
              hintText: 'Ex: 70',
              prefixIcon: const Icon(Icons.monitor_weight,
                  color: AppColors.kPrimaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.kPrimaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre poids';
              }
              if (double.tryParse(value) == null) {
                return 'Veuillez entrer un nombre valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Taille
          TextFormField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: S.of(context).height,
              hintText: 'Ex: 175',
              prefixIcon:
                  const Icon(Icons.height, color: AppColors.kPrimaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.kPrimaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre taille';
              }
              if (double.tryParse(value) == null) {
                return 'Veuillez entrer un nombre valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Âge
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: S.of(context).age,
              hintText: 'Ex: 30',
              prefixIcon:
                  const Icon(Icons.cake, color: AppColors.kPrimaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.kPrimaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre âge';
              }
              if (int.tryParse(value) == null) {
                return 'Veuillez entrer un nombre valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Bouton Calculer IMC
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                S.of(context).calculateMyBmi,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String gender, String label) {
    final isSelected = _selectedGender == gender;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.kPrimaryColor
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildBMIResult() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _categoryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Votre IMC',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _bmi!.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _categoryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _bmiCategory,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _categoryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _healthAdvice,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔥 Calcul des calories brûlées',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 16),

          // Type d'activité
          Text(
            'Type d\'activité',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.kPrimaryColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedActivity,
                items: _activityNames.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedActivity = value!);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Durée
          TextFormField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Durée (minutes)',
              hintText: 'Ex: 30',
              prefixIcon:
                  const Icon(Icons.timer, color: AppColors.kPrimaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.kPrimaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Bouton Calculer Calories
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _calculateCalories,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Calculer les calories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriesResult() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 50,
          ),
          const SizedBox(height: 12),
          const Text(
            'Calories brûlées',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_caloriesBurned!.toStringAsFixed(0)} kcal',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_activityNames[_selectedActivity]} pendant ${_durationController.text} min',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIReferenceTable() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 Tableau de référence IMC',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          _buildBMIRow('< 16', 'Maigreur sévère', Colors.red.shade900),
          _buildBMIRow('16 - 17', 'Maigreur modérée', Colors.orange.shade900),
          _buildBMIRow('17 - 18.5', 'Maigreur légère', Colors.orange),
          _buildBMIRow('18.5 - 25', 'Poids normal', Colors.green),
          _buildBMIRow('25 - 30', 'Surpoids', Colors.orange),
          _buildBMIRow('30 - 35', 'Obésité Classe I', Colors.orange.shade700),
          _buildBMIRow('35 - 40', 'Obésité Classe II', Colors.red),
          _buildBMIRow('> 40', 'Obésité Classe III', Colors.red.shade900),
        ],
      ),
    );
  }

  Widget _buildBMIRow(String range, String category, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              range,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
