import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/user_preferences_service.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/main_dashboard_page.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/pages/onboarding_form_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserPreferencesService.hasCompletedOnboarding(),
      builder: (context, snapshot) {
        // En attendant la réponse, afficher un écran de chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Si l'utilisateur a complété l'onboarding, aller à l'accueil
        // Sinon, afficher le formulaire d'onboarding
        final hasCompletedOnboarding = snapshot.data ?? false;

        if (hasCompletedOnboarding) {
          return const MainDashboardPage();
        } else {
          return const OnboardingFormPage();
        }
      },
    );
  }
}
