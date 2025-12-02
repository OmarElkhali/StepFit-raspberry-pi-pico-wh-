import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/user_preferences_service.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:flutter_steps_tracker/generated/l10n.dart';

/// Page de profil utilisateur avec informations personnelles éditables
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male';
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userInfo = await UserPreferencesService.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _firstNameController.text = userInfo['firstName'] ?? '';
        _lastNameController.text = userInfo['lastName'] ?? '';
        _weightController.text = userInfo['weight']?.toString() ?? '';
        _heightController.text = userInfo['height']?.toString() ?? '';
        _ageController.text = userInfo['age']?.toString() ?? '';
        _gender = userInfo['gender'] ?? 'Male';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _toggleEdit() async {
    if (_isEditing && _formKey.currentState!.validate()) {
      // Sauvegarder les données
      await UserPreferencesService.saveUserInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        age: int.parse(_ageController.text),
        gender: _gender,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).profileUpdated),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).myProfile,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kPrimaryColor),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: AppColors.kPrimaryColor,
            ),
            onPressed: _toggleEdit,
            tooltip: _isEditing ? S.of(context).save : S.of(context).edit,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.kPrimaryColor),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Photo de profil
                    _buildProfileHeader(),
                    const SizedBox(height: 30),

                    // Section Informations personnelles
                    _buildSectionTitle(S.of(context).personalInfo),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      children: [
                        _buildTextField(
                          controller: _firstNameController,
                          label: S.of(context).firstName,
                          icon: Icons.person,
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _lastNameController,
                          label: S.of(context).lastName,
                          icon: Icons.person_outline,
                          enabled: _isEditing,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Données physiques
                    _buildSectionTitle(S.of(context).physicalInfo),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _weightController,
                                label: S.of(context).weight,
                                icon: Icons.monitor_weight,
                                enabled: _isEditing,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _heightController,
                                label: S.of(context).height,
                                icon: Icons.height,
                                enabled: _isEditing,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _ageController,
                                label: S.of(context).age,
                                icon: Icons.cake,
                                enabled: _isEditing,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildGenderDropdown(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Statistiques IMC
                    _buildIMCCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.kPrimaryColor, AppColors.kSecondaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${_firstNameController.text[0]}${_lastNameController.text[0]}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '${_firstNameController.text} ${_lastNameController.text}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.kLightOrange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${S.of(context).memberSince} Nov 2025',
            style: TextStyle(
              color: AppColors.kDarkOrange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: enabled
            ? Theme.of(context).textTheme.bodyLarge?.color
            : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.kPrimaryColor, size: 22),
        filled: true,
        fillColor: enabled
            ? AppColors.kLightOrange.withOpacity(0.3)
            : (isDark ? Colors.grey[800] : Colors.grey[100]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.kPrimaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.kPrimaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).requiredField;
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _isEditing
            ? AppColors.kLightOrange.withOpacity(0.3)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.wc, color: AppColors.kPrimaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _gender,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: _isEditing
                      ? AppColors.kPrimaryColor
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                style: TextStyle(
                  color: _isEditing
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.white,
                items: [
                  DropdownMenuItem<String>(
                    value: 'Male',
                    child: Text(S.of(context).male),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Female',
                    child: Text(S.of(context).female),
                  ),
                ],
                onChanged: _isEditing
                    ? (String? newValue) {
                        setState(() {
                          _gender = newValue!;
                        });
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIMCCard() {
    final weight = double.tryParse(_weightController.text) ?? 70.0;
    final height = double.tryParse(_heightController.text) ?? 170.0;
    final bmi = weight / ((height / 100) * (height / 100));

    String category = '';
    Color categoryColor = Colors.grey;

    if (bmi < 18.5) {
      category = S.of(context).moderateThinness;
      categoryColor = Colors.blue;
    } else if (bmi < 25) {
      category = S.of(context).normalWeight;
      categoryColor = Colors.green;
    } else if (bmi < 30) {
      category = S.of(context).overweight;
      categoryColor = Colors.orange;
    } else {
      category = S.of(context).obesityClass1;
      categoryColor = Colors.red;
    }

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
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            S.of(context).bodyMassIndex,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: categoryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
