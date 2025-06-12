import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedSphere extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration animationDuration;
  final Widget? child;
  final VoidCallback? onTap;

  const AnimatedSphere({
    Key? key,
    this.size = 100.0,
    this.primaryColor = const Color(0xFF4A90E2),
    this.secondaryColor = const Color(0xFF7B68EE),
    this.animationDuration = const Duration(seconds: 3),
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  _AnimatedSphereState createState() => _AnimatedSphereState();
}

class _AnimatedSphereState extends State<AnimatedSphere>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    // Rotation animation
    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    // Pulse animation
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Float animation
    _floatController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _pulseController,
          _floatController,
        ]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0,
              math.sin(_floatController.value * math.pi) * 8,
            ),
            child: Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.1),
              child: Container(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: SpherePainter(
                    rotationValue: _rotationController.value,
                    primaryColor: widget.primaryColor,
                    secondaryColor: widget.secondaryColor,
                  ),
                  child: widget.child != null
                      ? Center(child: widget.child)
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SpherePainter extends CustomPainter {
  final double rotationValue;
  final Color primaryColor;
  final Color secondaryColor;

  SpherePainter({
    required this.rotationValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create gradient for 3D effect
    final gradient = RadialGradient(
      center: Alignment(-0.3, -0.3),
      radius: 1.2,
      colors: [
        Colors.white.withOpacity(0.8),
        primaryColor,
        secondaryColor,
        primaryColor.withOpacity(0.3),
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    // Draw main sphere
    canvas.drawCircle(center, radius, paint);

    // Add rotating highlight
    final highlightAngle = rotationValue * 2 * math.pi;
    final highlightX = center.dx + math.cos(highlightAngle) * radius * 0.3;
    final highlightY = center.dy + math.sin(highlightAngle) * radius * 0.3;

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      Offset(highlightX, highlightY),
      radius * 0.2,
      highlightPaint,
    );

    // Add shadow/depth
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(
      Offset(center.dx + 3, center.dy + 3),
      radius * 0.95,
      shadowPaint,
    );

    // Add surface pattern
    _drawSurfacePattern(canvas, size, center, radius);
  }

  void _drawSurfacePattern(Canvas canvas, Size size, Offset center, double radius) {
    final patternPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw rotating grid lines
    const gridLines = 8;
    for (int i = 0; i < gridLines; i++) {
      final angle = (i / gridLines * 2 * math.pi) + (rotationValue * 2 * math.pi);

      // Vertical lines
      final startX = center.dx + math.cos(angle) * radius * 0.8;
      final startY = center.dy - radius * 0.6;
      final endX = center.dx + math.cos(angle) * radius * 0.8;
      final endY = center.dy + radius * 0.6;

      // Only draw visible parts (simple depth culling)
      if (math.cos(angle) > -0.5) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          patternPaint,
        );
      }
    }

    // Horizontal circles
    for (int i = 1; i < 4; i++) {
      final circleRadius = radius * (0.2 + i * 0.2);
      final circlePaint = Paint()
        ..color = Colors.white.withOpacity(0.05)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, circleRadius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Usage example widget
class SphereExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Basic sphere
            AnimatedSphere(
              size: 120,
              primaryColor: Color(0xFF4A90E2),
              secondaryColor: Color(0xFF7B68EE),
              onTap: () => print("Sphere tapped!"),
            ),
            SizedBox(height: 40),

            // Sphere with icon
            AnimatedSphere(
              size: 100,
              primaryColor: Color(0xFF4CAF50),
              secondaryColor: Color(0xFF81C784),
              child: Icon(
                Icons.psychology,
                size: 40,
                color: Colors.white,
              ),
              onTap: () => print("Icon sphere tapped!"),
            ),
            SizedBox(height: 40),

            // Small sphere with text
            AnimatedSphere(
              size: 80,
              primaryColor: Color(0xFFFF9800),
              secondaryColor: Color(0xFFFFB74D),
              animationDuration: Duration(seconds: 5),
              child: Text(
                "AI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}