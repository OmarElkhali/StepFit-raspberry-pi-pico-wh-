import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget animé qui affiche une personne marchant/courant selon la vitesse
class AnimatedSpeedIndicator extends StatefulWidget {
  final double speed; // en m/s
  final String activityType;

  const AnimatedSpeedIndicator({
    Key? key,
    required this.speed,
    required this.activityType,
  }) : super(key: key);

  @override
  State<AnimatedSpeedIndicator> createState() => _AnimatedSpeedIndicatorState();
}

class _AnimatedSpeedIndicatorState extends State<AnimatedSpeedIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _getAnimationDuration(),
    )..repeat();
  }

  @override
  void didUpdateWidget(AnimatedSpeedIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _controller.duration = _getAnimationDuration();
    }
  }

  /// Calcule la durée d'animation basée sur la vitesse scientifique
  Duration _getAnimationDuration() {
    // Vitesse en km/h
    final speedKmh = widget.speed * 3.6;

    // Durée d'animation inversement proportionnelle à la vitesse
    // Plus rapide = animation plus rapide
    if (speedKmh < 0.5) {
      return const Duration(milliseconds: 3000); // Immobile/très lent
    } else if (speedKmh < 3.2) {
      return const Duration(milliseconds: 1800); // Marche très lente
    } else if (speedKmh < 4.8) {
      return const Duration(milliseconds: 1200); // Marche normale
    } else if (speedKmh < 6.4) {
      return const Duration(milliseconds: 800); // Marche rapide
    } else if (speedKmh < 8.0) {
      return const Duration(milliseconds: 600); // Course lente
    } else {
      return const Duration(milliseconds: 400); // Course rapide
    }
  }

  Color _getSpeedColor() {
    final speedKmh = widget.speed * 3.6;
    if (speedKmh < 0.5) return Colors.grey;
    if (speedKmh < 3.2) return Colors.blue;
    if (speedKmh < 4.8) return Colors.green;
    if (speedKmh < 6.4) return Colors.orange;
    return Colors.red;
  }

  IconData _getActivityIcon() {
    final speedKmh = widget.speed * 3.6;
    if (speedKmh < 0.5) return Icons.accessibility_new;
    if (speedKmh < 6.4) return Icons.directions_walk;
    return Icons.directions_run;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final speedKmh = widget.speed * 3.6;
    final speedColor = _getSpeedColor();

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: isDark
                ? [speedColor.withOpacity(0.3), speedColor.withOpacity(0.1)]
                : [speedColor.withOpacity(0.2), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Titre
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vitesse',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: speedColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.activityType,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: speedColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Animation de la personne
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _WalkingPersonPainter(
                      progress: _controller.value,
                      speedKmh: speedKmh,
                      color: speedColor,
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Affichage de la vitesse
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(_getActivityIcon(), color: speedColor, size: 32),
                const SizedBox(width: 12),
                Text(
                  speedKmh.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: speedColor,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'km/h',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Vitesse en m/s
            Text(
              '${widget.speed.toStringAsFixed(2)} m/s',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),

            const SizedBox(height: 16),

            // Barre indicatrice de vitesse
            _buildSpeedBar(speedKmh, speedColor, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedBar(double speedKmh, Color color, bool isDark) {
    // Max speed pour l'échelle : 15 km/h (course rapide)
    final progress = (speedKmh / 15.0).clamp(0.0, 1.0);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSpeedLabel('0', Colors.grey, isDark),
            _buildSpeedLabel('3', Colors.blue, isDark),
            _buildSpeedLabel('5', Colors.green, isDark),
            _buildSpeedLabel('7', Colors.orange, isDark),
            _buildSpeedLabel('10+', Colors.red, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedLabel(String label, Color color, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: color.withOpacity(0.7),
      ),
    );
  }
}

/// Painter qui dessine une personne marchant/courant avec animation
class _WalkingPersonPainter extends CustomPainter {
  final double progress; // 0.0 à 1.0
  final double speedKmh;
  final Color color;
  final bool isDark;

  _WalkingPersonPainter({
    required this.progress,
    required this.speedKmh,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Facteur d'animation basé sur la progression
    final animProgress = progress * 2 * math.pi;

    // Intensité du mouvement basée sur la vitesse
    double legSwing, armSwing, bodyTilt;

    if (speedKmh < 0.5) {
      // Immobile
      legSwing = 0;
      armSwing = 0;
      bodyTilt = 0;
    } else if (speedKmh < 3.2) {
      // Marche très lente
      legSwing = math.sin(animProgress) * 15;
      armSwing = math.sin(animProgress + math.pi) * 10;
      bodyTilt = math.sin(animProgress) * 2;
    } else if (speedKmh < 4.8) {
      // Marche normale
      legSwing = math.sin(animProgress) * 25;
      armSwing = math.sin(animProgress + math.pi) * 20;
      bodyTilt = math.sin(animProgress) * 3;
    } else if (speedKmh < 6.4) {
      // Marche rapide
      legSwing = math.sin(animProgress) * 35;
      armSwing = math.sin(animProgress + math.pi) * 30;
      bodyTilt = math.sin(animProgress) * 5;
    } else {
      // Course
      legSwing = math.sin(animProgress) * 45;
      armSwing = math.sin(animProgress + math.pi) * 40;
      bodyTilt = math.sin(animProgress) * 8;
    }

    // Position de base
    final headY = centerY - 60 + bodyTilt;
    final neckY = centerY - 45 + bodyTilt;
    final bodyBottomY = centerY + 10 + bodyTilt;
    final hipY = centerY + 10;

    // Dessiner la tête
    canvas.drawCircle(
      Offset(centerX, headY),
      12,
      fillPaint,
    );

    // Dessiner le corps (ligne verticale)
    canvas.drawLine(
      Offset(centerX, neckY),
      Offset(centerX, bodyBottomY),
      paint,
    );

    // Dessiner les bras
    // Bras gauche
    final leftArmAngle = armSwing * math.pi / 180;
    canvas.drawLine(
      Offset(centerX, neckY + 10),
      Offset(
        centerX - math.sin(leftArmAngle) * 30,
        neckY + 10 + math.cos(leftArmAngle) * 30,
      ),
      paint,
    );

    // Bras droit
    final rightArmAngle = -armSwing * math.pi / 180;
    canvas.drawLine(
      Offset(centerX, neckY + 10),
      Offset(
        centerX - math.sin(rightArmAngle) * 30,
        neckY + 10 + math.cos(rightArmAngle) * 30,
      ),
      paint,
    );

    // Dessiner les jambes
    // Jambe gauche
    final leftLegAngle = legSwing * math.pi / 180;
    final leftKneeX = centerX - math.sin(leftLegAngle) * 25;
    final leftKneeY = hipY + math.cos(leftLegAngle) * 25;
    final leftFootX = leftKneeX - math.sin(leftLegAngle) * 25;
    final leftFootY = leftKneeY + 25;

    canvas.drawLine(
      Offset(centerX, hipY),
      Offset(leftKneeX, leftKneeY),
      paint,
    );
    canvas.drawLine(
      Offset(leftKneeX, leftKneeY),
      Offset(leftFootX, leftFootY),
      paint,
    );

    // Jambe droite
    final rightLegAngle = -legSwing * math.pi / 180;
    final rightKneeX = centerX - math.sin(rightLegAngle) * 25;
    final rightKneeY = hipY + math.cos(rightLegAngle) * 25;
    final rightFootX = rightKneeX - math.sin(rightLegAngle) * 25;
    final rightFootY = rightKneeY + 25;

    canvas.drawLine(
      Offset(centerX, hipY),
      Offset(rightKneeX, rightKneeY),
      paint,
    );
    canvas.drawLine(
      Offset(rightKneeX, rightKneeY),
      Offset(rightFootX, rightFootY),
      paint,
    );

    // Dessiner le sol (ligne pointillée)
    final groundPaint = Paint()
      ..color = isDark ? Colors.grey[700]! : Colors.grey[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final groundY = size.height - 10;
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, groundY),
        Offset(i + 10, groundY),
        groundPaint,
      );
    }

    // Ajouter des lignes de vitesse si en course
    if (speedKmh >= 6.4) {
      final speedLinePaint = Paint()
        ..color = color.withOpacity(0.3)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      // Dessiner 3 lignes de vitesse derrière la personne
      for (int i = 0; i < 3; i++) {
        final offset = (progress * 50 + i * 20) % 60;
        canvas.drawLine(
          Offset(centerX - 40 - offset, centerY - 20 + i * 15),
          Offset(centerX - 60 - offset, centerY - 20 + i * 15),
          speedLinePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_WalkingPersonPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.speedKmh != speedKmh ||
        oldDelegate.color != color;
  }
}
