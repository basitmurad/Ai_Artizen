import 'package:flutter/material.dart';
import 'dart:math' as math;

// Level data model for the zigzag widget
class ZigzagLevelData {
  final int id;
  final String title;
  final bool isCompleted;
  final bool isUnlocked;
  final int stars;
  final Map<String, dynamic> data;

  ZigzagLevelData({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isUnlocked,
    this.stars = 0,
    this.data = const {},
  });
}

class ZigzagModuleWidget extends StatefulWidget {
  final List<ZigzagLevelData> levels;
  final Function(ZigzagLevelData level)? onLevelTap;
  final Duration animationDuration;
  final bool showAnimation;
  final EdgeInsets levelMargin;
  final double levelSpacing;
  final double levelSize;
  final bool showConnectors;
  final Color pathColor;

  const ZigzagModuleWidget({
    Key? key,
    required this.levels,
    this.onLevelTap,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.showAnimation = true,
    this.levelMargin = const EdgeInsets.symmetric(vertical: 8),
    this.levelSpacing = 30.0,
    this.levelSize = 70.0,
    this.showConnectors = true,
    this.pathColor = Colors.white,
  }) : super(key: key);

  @override
  _ZigzagModuleWidgetState createState() => _ZigzagModuleWidgetState();
}

class _ZigzagModuleWidgetState extends State<ZigzagModuleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pathController;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _pathController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    if (widget.showAnimation) {
      _pathController.forward();
    } else {
      _pathController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }

  void restartAnimation() {
    _pathController.reset();
    _pathController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.levels.asMap().entries.map((entry) {
        int levelIndex = entry.key;
        ZigzagLevelData level = entry.value;

        bool isLeft = levelIndex % 2 == 0;
        double horizontalOffset = isLeft ? -0.3 : 0.3;

        return AnimatedBuilder(
          animation: _pathController,
          builder: (context, child) {
            double totalLevels = widget.levels.length.toDouble();
            double levelDelay = 0.1 + (levelIndex / totalLevels) * 0.4;
            double animationDuration = 0.2;

            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _pathController,
                  curve: Interval(
                    levelDelay,
                    (levelDelay + animationDuration).clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(horizontalOffset, 0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _pathController,
                    curve: Interval(
                      levelDelay,
                      (levelDelay + animationDuration).clamp(0.0, 1.0),
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildLevelRow(level, levelIndex, isLeft),
                    if (widget.showConnectors && levelIndex < widget.levels.length - 1)
                      _buildConnector(levelIndex),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildLevelRow(ZigzagLevelData level, int levelIndex, bool isLeft) {
    return Container(
      margin: widget.levelMargin,
      child: Row(
        mainAxisAlignment: isLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (isLeft) SizedBox(width: widget.levelSpacing),
          _buildLevelNode(level),
          if (!isLeft) SizedBox(width: widget.levelSpacing),
        ],
      ),
    );
  }

  Widget _buildConnector(int levelIndex) {
    bool currentIsLeft = levelIndex % 2 == 0;
    bool nextIsLeft = (levelIndex + 1) % 2 == 0;

    return Container(
      height: 20,
      child: CustomPaint(
        size: Size(double.infinity, 20),
        painter: ZigzagConnectorPainter(
          startLeft: currentIsLeft,
          endLeft: nextIsLeft,
          color: widget.pathColor.withOpacity(0.3),
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  Widget _buildLevelNode(ZigzagLevelData level) {
    final nodeStyles = _getLevelNodeStyles(level);

    return GestureDetector(
      onTap: level.isUnlocked ? () => widget.onLevelTap?.call(level) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLevelCircle(level, nodeStyles),
          SizedBox(height: 6),
          if (level.isUnlocked) _buildStarsDisplay(level),
          if (level.isUnlocked) SizedBox(height: 4),
          if (level.isUnlocked) _buildLevelTitle(level),
        ],
      ),
    );
  }

  Map<String, dynamic> _getLevelNodeStyles(ZigzagLevelData level) {
    if (level.isCompleted) {
      return {
        'color': Color(0xFF4CAF50),
        'icon': Icons.check,
        'iconColor': Colors.white,
        'displayText': '',
        'glowColor': Color(0xFF4CAF50),
      };
    } else if (level.isUnlocked) {
      return {
        'color': Color(0xFFFFD700),
        'icon': Icons.play_arrow,
        'iconColor': Colors.white,
        'displayText': '${level.id}',
        'glowColor': Color(0xFFFFD700),
      };
    } else {
      return {
        'color': Colors.grey[400]!,
        'icon': Icons.lock,
        'iconColor': Colors.grey[600]!,
        'displayText': '',
        'glowColor': Colors.grey[400]!,
      };
    }
  }

  Widget _buildLevelCircle(ZigzagLevelData level, Map<String, dynamic> styles) {
    return Container(
      width: widget.levelSize,
      height: widget.levelSize,
      decoration: BoxDecoration(
        color: styles['color'],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: styles['glowColor'].withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
          if (level.isUnlocked)
            BoxShadow(
              color: styles['glowColor'].withOpacity(0.6),
              blurRadius: 20,
              offset: Offset(0, 0),
            ),
        ],
        gradient: level.isUnlocked
            ? RadialGradient(
          colors: [
            styles['color'].withOpacity(0.8),
            styles['color'],
          ],
          stops: [0.0, 1.0],
        )
            : null,
      ),
      child: Center(
        child: level.isCompleted
            ? Icon(styles['icon'], color: styles['iconColor'], size: 30)
            : level.isUnlocked
            ? Text(
          styles['displayText'],
          style: TextStyle(
            color: styles['iconColor'],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
            : Icon(styles['icon'], color: styles['iconColor'], size: 25),
      ),
    );
  }

  Widget _buildStarsDisplay(ZigzagLevelData level) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          bool isStarEarned = index < level.stars;
          return Icon(
            isStarEarned ? Icons.star : Icons.star_border,
            color: isStarEarned ? Colors.yellow : Colors.white.withOpacity(0.5),
            size: 16,
          );
        }),
      ),
    );
  }

  Widget _buildLevelTitle(ZigzagLevelData level) {
    return Container(
      width: widget.levelSize + 10,
      child: Text(
        level.title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// Custom painter for zigzag connectors
class ZigzagConnectorPainter extends CustomPainter {
  final bool startLeft;
  final bool endLeft;
  final Color color;
  final double strokeWidth;

  ZigzagConnectorPainter({
    required this.startLeft,
    required this.endLeft,
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Calculate start and end points
    double startX = startLeft ? size.width * 0.25 : size.width * 0.75;
    double endX = endLeft ? size.width * 0.25 : size.width * 0.75;

    // Create curved zigzag path
    path.moveTo(startX, 0);

    // Add a smooth curve
    path.quadraticBezierTo(
      size.width * 0.5, // Control point X (center)
      size.height * 0.5, // Control point Y (middle)
      endX, // End X
      size.height, // End Y
    );

    canvas.drawPath(path, paint);

    // Add small dots along the path for decoration
    _drawPathDots(canvas, path, paint);
  }

  void _drawPathDots(Canvas canvas, Path path, Paint paint) {
    final dotPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Draw small dots along the path
    for (double t = 0.2; t <= 0.8; t += 0.3) {
      final metrics = path.computeMetrics().first;
      final position = metrics.getTangentForOffset(metrics.length * t)?.position;
      if (position != null) {
        canvas.drawCircle(position, 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Usage examples
class ZigzagModuleExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sampleLevels = [
      ZigzagLevelData(
        id: 1,
        title: '1. Acquire',
        isCompleted: true,
        isUnlocked: true,
        stars: 3,
      ),
      ZigzagLevelData(
        id: 2,
        title: '2. Deepen',
        isCompleted: true,
        isUnlocked: true,
        stars: 2,
      ),
      ZigzagLevelData(
        id: 3,
        title: '3. Create',
        isCompleted: false,
        isUnlocked: true,
        stars: 0,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Learning Path',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),

                // Example 1: Basic zigzag
                ZigzagModuleWidget(
                  levels: sampleLevels,
                  onLevelTap: (level) {
                    print('Level ${level.id} tapped: ${level.title}');
                  },
                ),

                SizedBox(height: 50),

                // Example 2: Custom styling
                ZigzagModuleWidget(
                  levels: sampleLevels,
                  levelSize: 80,
                  levelSpacing: 40,
                  showConnectors: true,
                  pathColor: Colors.white,
                  showAnimation: false,
                  onLevelTap: (level) {
                    print('Custom level tapped: ${level.title}');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}