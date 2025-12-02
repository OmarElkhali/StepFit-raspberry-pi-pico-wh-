import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/main_dashboard_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/history_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/bmi_calculator_page.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/profile_page.dart';
import 'package:flutter_steps_tracker/features/bottom_navbar/presentation/widgets/app_bar_area.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter_steps_tracker/generated/l10n.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final _bottomNavbarController = PersistentTabController();

  List<Widget> _buildScreens() {
    return [
      const MainDashboardPage(), // Page d'accueil Bluetooth
      const BMICalculatorPage(), // Page IMC/Calories
      const HistoryPage(), // Historique
      const ProfilePage(), // Profil utilisateur
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: S.of(context).home,
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.monitor_weight), // Icône BMI
        title: S.of(context).imcAndCalories,
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.history), // Icône historique
        title: S.of(context).history,
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person), // Icône profil
        title: S.of(context).myProfile,
        activeColorPrimary: Theme.of(context).primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, size.height * 0.06),
        child: const AppBarArea(),
      ),
      body: SafeArea(
        child: PersistentTabView(
          context,
          controller: _bottomNavbarController,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          handleAndroidBackButtonPress: true,
          // Default is true.
          resizeToAvoidBottomInset: true,
          // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true,
          // Default is true.
          hideNavigationBarWhenKeyboardShows: true,
          // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style1, // Choose the nav bar style with this property.
        ),
      ),
    );
  }
}
