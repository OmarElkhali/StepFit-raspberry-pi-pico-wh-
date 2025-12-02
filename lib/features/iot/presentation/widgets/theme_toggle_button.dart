import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/utilities/locale/app_theme.dart';

/// Bouton pour basculer entre Light et Dark mode
class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Charger le thème actuel
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    final themeCubit = ThemeCubit();
    await themeCubit.initialize();
    setState(() {
      _isDark = themeCubit.currentTheme == ThemeMode.dark;
      if (_isDark) {
        _controller.value = 1.0;
      }
    });
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _isDark = !_isDark;
    });

    if (_isDark) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    final themeCubit = ThemeCubit();
    await themeCubit.toggleTheme();

    // Recharger l'app pour appliquer le nouveau thème
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return IconButton(
          icon: Icon(
            _isDark ? Icons.light_mode : Icons.dark_mode,
            color: _isDark ? Colors.orange[300] : Colors.indigo[700],
          ),
          onPressed: _toggleTheme,
          tooltip: _isDark ? 'Mode clair' : 'Mode sombre',
        );
      },
    );
  }
}

/// Version floating action button
class ThemeToggleFAB extends StatefulWidget {
  const ThemeToggleFAB({Key? key}) : super(key: key);

  @override
  State<ThemeToggleFAB> createState() => _ThemeToggleFABState();
}

class _ThemeToggleFABState extends State<ThemeToggleFAB> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    final themeCubit = ThemeCubit();
    await themeCubit.initialize();
    if (mounted) {
      setState(() {
        _isDark = themeCubit.currentTheme == ThemeMode.dark;
      });
    }
  }

  Future<void> _toggleTheme() async {
    final themeCubit = ThemeCubit();
    await themeCubit.toggleTheme();

    if (mounted) {
      setState(() {
        _isDark = !_isDark;
      });

      // Afficher un message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isDark ? '🌙 Mode sombre activé' : '☀️ Mode clair activé',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _toggleTheme,
      child: Icon(
        _isDark ? Icons.light_mode : Icons.dark_mode,
      ),
      tooltip: _isDark ? 'Mode clair' : 'Mode sombre',
    );
  }
}
