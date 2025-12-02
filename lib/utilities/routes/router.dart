import 'package:flutter/cupertino.dart';
import 'package:flutter_steps_tracker/core/presentation/pages/landing_page.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/presentation/pages/bottom_navbar.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/main_dashboard_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/achievements_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/enhanced_profile_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/notification_settings_page.dart';
import 'package:flutter_steps_tracker/features/intro/presentation/pages/splash_screen.dart';
import 'package:flutter_steps_tracker/utilities/routes/routes.dart';

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.mainDashboardRoute:
      return CupertinoPageRoute(
        builder: (_) => const MainDashboardPage(),
        settings: settings,
      );
    case AppRoutes.homePageRoute:
      return CupertinoPageRoute(
        builder: (_) => const BottomNavbar(),
        settings: settings,
      );
    case AppRoutes.achievementsRoute:
      return CupertinoPageRoute(
        builder: (_) => const AchievementsPage(),
        settings: settings,
      );
    case AppRoutes.profileRoute:
      return CupertinoPageRoute(
        builder: (_) => const EnhancedProfilePage(),
        settings: settings,
      );
    case AppRoutes.notificationSettingsRoute:
      return CupertinoPageRoute(
        builder: (_) => const NotificationSettingsPage(),
        settings: settings,
      );
    case AppRoutes.landingPageRoute:
      return CupertinoPageRoute(
        builder: (_) => const LandingPage(),
        settings: settings,
      );
    case AppRoutes.splashRoute:
    default:
      return CupertinoPageRoute(
        builder: (_) => const SplashScreen(),
        settings: settings,
      );
  }
}
