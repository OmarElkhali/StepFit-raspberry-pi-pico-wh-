import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/achievement_service.dart';
import 'dart:math' as math;

class AchievementNotification extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementNotification({
    Key? key,
    required this.achievement,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<AchievementNotification> createState() =>
      _AchievementNotificationState();
}

class _AchievementNotificationState extends State<AchievementNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late AnimationController _particlesController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Animation d'entrée en slide
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Animation de scale pour l'icône
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Animation de glow pulsant
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Animation des particules
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Générer des particules
    for (int i = 0; i < 15; i++) {
      _particles.add(_Particle());
    }

    // Démarrer les animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _glowController.repeat(reverse: true);
      _particlesController.forward();
    });

    // Auto-dismiss après 4 secondes
    Future.delayed(const Duration(seconds: 4), () {
      _dismiss();
    });
  }

  void _dismiss() {
    _slideController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: _dismiss,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.achievement.color.withOpacity(0.9),
                    widget.achievement.color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.achievement.color.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Particules animées
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedBuilder(
                        animation: _particlesController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _ParticlesPainter(
                              particles: _particles,
                              animation: _particlesController,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icône avec glow
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _scaleAnimation,
                            _glowAnimation,
                          ]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(
                                          _glowAnimation.value * 0.6),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  widget.achievement.icon,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 16),

                        // Texte
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '🎉 Achievement Débloqué !',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.achievement.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.achievement.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Bouton fermer
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _dismiss,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  _Particle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        size = math.Random().nextDouble() * 4 + 2,
        speedX = (math.Random().nextDouble() - 0.5) * 0.02,
        speedY = math.Random().nextDouble() * -0.01 - 0.005,
        opacity = math.Random().nextDouble() * 0.5 + 0.3;
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final Animation<double> animation;
  final Color color;

  _ParticlesPainter({
    required this.particles,
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (var particle in particles) {
      // Mettre à jour la position
      particle.x += particle.speedX;
      particle.y += particle.speedY + animation.value * 0.01;

      // Wrap around
      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;

      // Diminuer l'opacité avec le temps
      final fadeOpacity = (1 - animation.value) * particle.opacity;

      paint.color = color.withOpacity(fadeOpacity);

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => true;
}

// Overlay global pour afficher les notifications
class AchievementOverlay {
  static OverlayEntry? _currentEntry;

  static void show(BuildContext context, Achievement achievement) {
    // Retirer l'overlay existant si présent
    hide();

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 0,
        right: 0,
        child: AchievementNotification(
          achievement: achievement,
          onDismiss: hide,
        ),
      ),
    );

    Overlay.of(context).insert(_currentEntry!);
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
