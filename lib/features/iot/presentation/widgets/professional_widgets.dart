import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

/// Widget de carte avec effet Glassmorphism (verre givré)
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Gradient? gradient;

  const GlassCard({
    Key? key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderRadius,
    this.padding,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(opacity),
                    Colors.white.withOpacity(opacity * 0.5),
                  ],
                ),
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Widget de carte 3D avec effet de parallaxe
class Card3D extends StatefulWidget {
  final Widget child;
  final double depth;
  final bool enableShadow;
  final VoidCallback? onTap;

  const Card3D({
    Key? key,
    required this.child,
    this.depth = 20,
    this.enableShadow = true,
    this.onTap,
  }) : super(key: key);

  @override
  State<Card3D> createState() => _Card3DState();
}

class _Card3DState extends State<Card3D> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _offset = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset = Offset(
            (_offset.dx + details.delta.dx).clamp(-widget.depth, widget.depth),
            (_offset.dy + details.delta.dy).clamp(-widget.depth, widget.depth),
          );
        });
      },
      onPanEnd: (_) {
        setState(() {
          _offset = Offset.zero;
        });
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-_offset.dy * 0.01)
          ..rotateY(_offset.dx * 0.01),
        child: Container(
          decoration: widget.enableShadow
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(_offset.dx * 0.5, _offset.dy * 0.5 + 10),
                    ),
                  ],
                )
              : null,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Widget de particules flottantes animées
class FloatingParticles extends StatefulWidget {
  final int numberOfParticles;
  final Color color;
  final double minSize;
  final double maxSize;

  const FloatingParticles({
    Key? key,
    this.numberOfParticles = 20,
    this.color = Colors.white,
    this.minSize = 2,
    this.maxSize = 6,
  }) : super(key: key);

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _generateParticles();
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < widget.numberOfParticles; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: widget.minSize +
            random.nextDouble() * (widget.maxSize - widget.minSize),
        speedX: (random.nextDouble() - 0.5) * 0.02,
        speedY: -random.nextDouble() * 0.03 - 0.01,
        opacity: random.nextDouble() * 0.5 + 0.3,
      ));
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
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color color;

  ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Mettre à jour la position
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      // Réinitialiser si hors écran
      if (particle.y < 0) {
        particle.y = 1.0;
        particle.x = math.Random().nextDouble();
      }
      if (particle.x < 0) particle.x = 1.0;
      if (particle.x > 1) particle.x = 0.0;

      final paint = Paint()
        ..color = color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

/// Bouton avec effet de vague (ripple) animé
class RippleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color rippleColor;
  final double size;

  const RippleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.rippleColor = Colors.white,
    this.size = 200,
  }) : super(key: key);

  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: RipplePainter(
                  progress: _controller.value,
                  color: widget.rippleColor,
                ),
                size: Size(widget.size, widget.size),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final rippleProgress = (progress - i * 0.15).clamp(0.0, 1.0);
      final radius = maxRadius * rippleProgress;
      final opacity = (1 - rippleProgress) * 0.3;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Indicateur de progression circulaire animé avec gradient
class GradientCircularProgress extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Widget? center;

  const GradientCircularProgress({
    Key? key,
    required this.progress,
    this.size = 200,
    this.strokeWidth = 15,
    required this.gradientColors,
    this.center,
  }) : super(key: key);

  @override
  State<GradientCircularProgress> createState() =>
      _GradientCircularProgressState();
}

class _GradientCircularProgressState extends State<GradientCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(GradientCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
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
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: GradientCircularProgressPainter(
                  progress: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  gradientColors: widget.gradientColors,
                ),
                size: Size(widget.size, widget.size),
              ),
              if (widget.center != null) widget.center!,
            ],
          ),
        );
      },
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;

  GradientCircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Cercle de fond
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Arc de progression avec gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      colors: gradientColors,
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(GradientCircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
