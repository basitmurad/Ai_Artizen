import 'package:flutter/material.dart';
import 'dart:math' as math;

class UserBadgesWidget extends StatefulWidget {
  final Map<int, Map<String, dynamic>> userProgress;
  final String title;
  final int maxLevels;
  final Function(String badgeType, int levelId)? onBadgeTap;
  final bool showAnimation;
  final EdgeInsets margin;
  final double badgeSize;
  final bool showEmptyState;
  final String emptyStateText;

  const UserBadgesWidget({
    super.key,
    required this.userProgress,
    this.title = 'Your Achievements',
    this.maxLevels = 3,
    this.onBadgeTap,
    this.showAnimation = true,
    this.margin = const EdgeInsets.symmetric(vertical: 20),
    this.badgeSize = 80.0,
    this.showEmptyState = false,
    this.emptyStateText = 'Complete levels to earn badges!',
  });

  @override
  _UserBadgesWidgetState createState() => _UserBadgesWidgetState();
}

class _UserBadgesWidgetState extends State<UserBadgesWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _bounceController;
  final List<AnimationController> _badgeControllers = [];
  final List<Animation<double>> _badgeAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create individual controllers for each potential badge
    for (int i = 0; i < widget.maxLevels; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
      );
      _badgeControllers.add(controller);

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      _badgeAnimations.add(animation);
    }

    if (widget.showAnimation) {
      _startAnimations();
    } else {
      _fadeController.value = 1.0;
      _bounceController.value = 1.0;
      for (var controller in _badgeControllers) {
        controller.value = 1.0;
      }
    }
  }

  void _startAnimations() {
    _fadeController.forward();

    // Stagger badge animations
    List<Widget> earnedBadges = _getEarnedBadges();
    for (int i = 0; i < earnedBadges.length; i++) {
      Future.delayed(Duration(milliseconds: 200 + (i * 150)), () {
        if (mounted && i < _badgeControllers.length) {
          _badgeControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bounceController.dispose();
    for (var controller in _badgeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Widget> _getEarnedBadges() {
    List<Widget> badges = [];
    int badgeIndex = 0;

    for (int levelId = 1; levelId <= widget.maxLevels; levelId++) {
      Map<String, dynamic>? levelProgress = widget.userProgress[levelId];
      bool isCompleted = levelProgress?['isCompleted'] ?? false;

      if (isCompleted) {
        String badgeType = _getBadgeType(levelId);
        badges.add(_buildUserBadge(badgeType, levelId, badgeIndex));
        badgeIndex++;
      }
    }

    return badges;
  }

  String _getBadgeType(int levelId) {
    switch (levelId) {
      case 1:
        return 'Acquire';
      case 2:
        return 'Deepen';
      case 3:
        return 'Create';
      default:
        return 'Level $levelId';
    }
  }

  BadgeConfig _getBadgeConfig(String badgeType) {
    switch (badgeType) {
      case 'Acquire':
        return BadgeConfig(
          color: Color(0xFF4CAF50), // Green
          icon: Icons.lightbulb,
          description: 'Knowledge Seeker',
        );
      case 'Deepen':
        return BadgeConfig(
          color: Color(0xFF2196F3), // Blue
          icon: Icons.psychology,
          description: 'Deep Thinker',
        );
      case 'Create':
        return BadgeConfig(
          color: Color(0xFFFF9800), // Orange
          icon: Icons.create,
          description: 'Creator',
        );
      default:
        return BadgeConfig(
          color: Color(0xFF9C27B0), // Purple
          icon: Icons.star,
          description: 'Achiever',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> badges = _getEarnedBadges();

    if (badges.isEmpty && !widget.showEmptyState) {
      return SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        margin: widget.margin,
        child: Column(
          children: [
            _buildTitle(),
            SizedBox(height: 15),
            badges.isEmpty ? _buildEmptyState() : _buildBadgesGrid(badges),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            color: Colors.white.withOpacity(0.6),
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            widget.emptyStateText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesGrid(List<Widget> badges) {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: badges,
    );
  }

  Widget _buildUserBadge(String badgeType, int levelId, int animationIndex) {
    final config = _getBadgeConfig(badgeType);
    final animation = animationIndex < _badgeAnimations.length
        ? _badgeAnimations[animationIndex]
        : _badgeAnimations.last;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Transform.rotate(
            angle: (1 - animation.value) * math.pi * 0.5,
            child: GestureDetector(
              onTap: () {
                _animateBadgeTap(animationIndex);
                widget.onBadgeTap?.call(badgeType, levelId);
              },
              child: SizedBox(
                width: widget.badgeSize,
                height: widget.badgeSize + 20,
                child: Column(
                  children: [
                    _buildBadgeCircle(config, levelId),
                    SizedBox(height: 8),
                    _buildBadgeText(badgeType, config.description),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadgeCircle(BadgeConfig config, int levelId) {
    Map<String, dynamic>? levelProgress = widget.userProgress[levelId];
    int starsEarned = levelProgress?['starsEarned'] ??
        levelProgress?['stars'] ??
        _calculateStarsFromProgress(levelProgress);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: config.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: config.color.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        gradient: RadialGradient(
          colors: [
            config.color.withOpacity(0.8),
            config.color,
            config.color.withOpacity(0.9),
          ],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              config.icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          if (starsEarned > 0) _buildStarsOverlay(starsEarned),
        ],
      ),
    );
  }

  Widget _buildStarsOverlay(int starsEarned) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          '$starsEarned',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeText(String badgeType, String description) {
    return Column(
      children: [
        Text(
          badgeType,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _animateBadgeTap(int index) {
    if (index < _badgeControllers.length) {
      _badgeControllers[index].reverse().then((_) {
        _badgeControllers[index].forward();
      });
    }
  }

  int _calculateStarsFromProgress(Map<String, dynamic>? levelProgress) {
    if (levelProgress?['isCompleted'] == true) {
      int correctAnswers = levelProgress?['correctAnswers'] ?? 0;
      int totalAnswers = levelProgress?['totalAnswers'] ?? 0;

      if (totalAnswers > 0) {
        double percentage = correctAnswers / totalAnswers;
        if (percentage >= 0.9) return 3;
        if (percentage >= 0.7) return 2;
        if (percentage >= 0.5) return 1;
      }
      return 1;
    }
    return 0;
  }
}

class BadgeConfig {
  final Color color;
  final IconData icon;
  final String description;

  BadgeConfig({
    required this.color,
    required this.icon,
    required this.description,
  });
}

// Usage Examples
