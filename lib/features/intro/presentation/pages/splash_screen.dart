import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/features/iot/presentation/pages/main_dashboard_page.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particlesController;
  late AnimationController _progressController;
  late AnimationController _textController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _progressAnimation;

  final List<_SplashParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Animation du logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi * 2,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Animation des particules
    _particlesController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // Générer les particules
    for (int i = 0; i < 40; i++) {
      _particles.add(_SplashParticle());
    }

    // Animation du texte
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Animation de la barre de progression
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Démarrer les animations
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    // Démarrer les particules immédiatement
    _particlesController.repeat();

    // Logo apparaît
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Texte apparaît
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Barre de progression
    await Future.delayed(const Duration(milliseconds: 500));
    _progressController.forward();

    // Attendre que tout soit terminé
    await Future.delayed(const Duration(milliseconds: 1500));

    // Navigation vers le dashboard
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainDashboardPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particlesController.dispose();
    _progressController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Particules animées
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particlesController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _SplashParticlesPainter(
                      particles: _particles,
                      animation: _particlesController,
                    ),
                  );
                },
              ),
            ),

            // Contenu principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animé
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoScaleAnimation,
                      _logoRotationAnimation,
                      _logoFadeAnimation,
                    ]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoFadeAnimation.value,
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Transform.rotate(
                            angle: _logoRotationAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.8),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.directions_walk,
                                size: 70,
                                color: Color(0xFF667eea),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Texte animé
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Steps Tracker',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Suivez chaque pas de votre parcours',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Barre de progression
                  SizedBox(
                    width: 200,
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _progressAnimation.value,
                                minHeight: 6,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FadeTransition(
                              opacity: _textFadeAnimation,
                              child: Text(
                                'Chargement...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Version en bas
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Text(
                  'v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashParticle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  _SplashParticle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        size = math.Random().nextDouble() * 3 + 1,
        speedX = (math.Random().nextDouble() - 0.5) * 0.002,
        speedY = (math.Random().nextDouble() - 0.5) * 0.002,
        opacity = math.Random().nextDouble() * 0.5 + 0.3;
}

class _SplashParticlesPainter extends CustomPainter {
  final List<_SplashParticle> particles;
  final Animation<double> animation;

  _SplashParticlesPainter({
    required this.particles,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var particle in particles) {
      // Mettre à jour la position
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      // Wrap around
      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;
      if (particle.y > 1) particle.y = 0;

      paint.color = Colors.white.withOpacity(particle.opacity);

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SplashParticlesPainter oldDelegate) => true;
}
