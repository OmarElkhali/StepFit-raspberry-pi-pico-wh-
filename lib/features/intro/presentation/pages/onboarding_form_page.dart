import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/user_preferences_service.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/presentation/pages/bottom_navbar.dart';
import 'package:flutter_steps_tracker/generated/l10n.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';

class OnboardingFormPage extends StatefulWidget {
  const OnboardingFormPage({Key? key}) : super(key: key);

  @override
  State<OnboardingFormPage> createState() => _OnboardingFormPageState();
}

class _OnboardingFormPageState extends State<OnboardingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedGender = 'Male';
  int _currentStep = 0;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (_formKey.currentState!.validate()) {
      await UserPreferencesService.saveUserInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.kPrimaryColor,
              AppColors.kSecondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.directions_run,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).welcomeToTracker,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).letsCreateProfile,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Indicateur de progression
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Formulaire
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_currentStep == 0) ..._buildIdentityStep(),
                          if (_currentStep == 1) ..._buildPhysicalInfoStep(),
                          if (_currentStep == 2) ..._buildFinalStep(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Boutons de navigation
              Container(
                padding: const EdgeInsets.all(24),
                color: isDark ? Colors.grey[900] : Colors.white,
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.kPrimaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            S.of(context).back,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 16),
                    Expanded(
                      flex: _currentStep == 0 ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentStep < 2) {
                            if (_validateCurrentStep()) {
                              setState(() {
                                _currentStep++;
                              });
                            }
                          } else {
                            _saveAndContinue();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentStep < 2
                              ? S.of(context).next
                              : S.of(context).start,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      return _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty;
    } else if (_currentStep == 1) {
      return _weightController.text.isNotEmpty &&
          _heightController.text.isNotEmpty &&
          _ageController.text.isNotEmpty;
    }
    return true;
  }

  List<Widget> _buildIdentityStep() {
    return [
      Text(
        S.of(context).yourIdentity,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        S.of(context).howToCallYou,
        style: TextStyle(
          fontSize: 14,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      const SizedBox(height: 32),
      _buildTextField(
        controller: _firstNameController,
        label: S.of(context).firstName,
        icon: Icons.person_outline,
        hint: S.of(context).enterFirstName,
      ),
      const SizedBox(height: 20),
      _buildTextField(
        controller: _lastNameController,
        label: S.of(context).lastName,
        icon: Icons.person,
        hint: S.of(context).enterLastName,
      ),
      const SizedBox(height: 32),
      _buildGenderSelector(),
    ];
  }

  List<Widget> _buildPhysicalInfoStep() {
    return [
      Text(
        S.of(context).physicalInfo,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        S.of(context).helpPersonalize,
        style: TextStyle(
          fontSize: 14,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      const SizedBox(height: 32),
      _buildTextField(
        controller: _weightController,
        label: S.of(context).weight,
        icon: Icons.monitor_weight_outlined,
        hint: S.of(context).weightExample,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 20),
      _buildTextField(
        controller: _heightController,
        label: S.of(context).height,
        icon: Icons.height,
        hint: S.of(context).heightExample,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 20),
      _buildTextField(
        controller: _ageController,
        label: S.of(context).age,
        icon: Icons.cake_outlined,
        hint: S.of(context).ageExample,
        keyboardType: TextInputType.number,
      ),
    ];
  }

  List<Widget> _buildFinalStep() {
    return [
      Text(
        S.of(context).summary,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        S.of(context).verifyInfo,
        style: TextStyle(
          fontSize: 14,
          color:
              Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        ),
      ),
      const SizedBox(height: 32),
      _buildSummaryCard(
        S.of(context).identity,
        [
          _buildSummaryRow(Icons.person, S.of(context).fullName,
              '${_firstNameController.text} ${_lastNameController.text}'),
          _buildSummaryRow(
              Icons.wc,
              S.of(context).gender,
              _selectedGender == 'Male'
                  ? S.of(context).male
                  : S.of(context).female),
        ],
      ),
      const SizedBox(height: 20),
      _buildSummaryCard(
        S.of(context).physicalInformation,
        [
          _buildSummaryRow(Icons.monitor_weight_outlined, S.of(context).weight,
              '${_weightController.text} kg'),
          _buildSummaryRow(Icons.height, S.of(context).height,
              '${_heightController.text} cm'),
          _buildSummaryRow(Icons.cake_outlined, S.of(context).age,
              '${_ageController.text} ${S.of(context).years}'),
        ],
      ),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.kLightOrange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.kPrimaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.kPrimaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).canModifyLater,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.5),
            ),
            prefixIcon: Icon(icon, color: AppColors.kPrimaryColor),
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.kPrimaryColor,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).requiredField;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).gender,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderButton('Male', Icons.male),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderButton('Female', Icons.female),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : (isDark ? Colors.grey[800] : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.kPrimaryColor
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : AppColors.kPrimaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              gender == 'Male' ? S.of(context).male : S.of(context).female,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.kPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.kPrimaryColor.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
