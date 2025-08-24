import 'package:flutter/material.dart';

class ModuleHeaderWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final int completedLevels;
  final int totalLevels;
  final VoidCallback? onTap;
  final bool showAnimation;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const ModuleHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.completedLevels,
    required this.totalLevels,
    this.onTap,
    this.showAnimation = true,
    this.margin = const EdgeInsets.symmetric(vertical: 15),
    this.padding = const EdgeInsets.all(20),
  });

  @override
  _ModuleHeaderWidgetState createState() => _ModuleHeaderWidgetState();
}

class _ModuleHeaderWidgetState extends State<ModuleHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.totalLevels > 0 ? widget.completedLevels / widget.totalLevels : 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    if (widget.showAnimation) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get progress => widget.totalLevels > 0 ? widget.completedLevels / widget.totalLevels : 0.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                margin: widget.margin,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.primaryColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildHeaderRow(),
                    SizedBox(height: 15),
                    _buildAnimatedProgressBar(),
                    SizedBox(height: 8),
                    _buildProgressText(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        _buildIconContainer(),
        SizedBox(width: 12),
        Expanded(
          child: _buildTitleColumn(),
        ),
        if (progress == 1.0) _buildCompletionBadge(),
      ],
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        widget.icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildTitleColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2),
        Text(
          widget.subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            'Complete',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return _buildProgressBar(_progressAnimation.value);
      },
    );
  }

  Widget _buildProgressBar(double animatedProgress) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          // Animated progress fill
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedProgress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
          // Progress indicator dots
          if (widget.totalLevels > 1) _buildProgressDots(),
        ],
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      children: List.generate(widget.totalLevels, (index) {
        bool isCompleted = index < widget.completedLevels;
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? widget.primaryColor
                      : Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProgressText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.completedLevels}/${widget.totalLevels} levels completed',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Usage Examples
class ModuleHeaderExamples extends StatelessWidget {
  const ModuleHeaderExamples({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Example 1: In Progress Module
                ModuleHeaderWidget(
                  title: 'Human-Centered Mindset',
                  subtitle: 'Building empathy and understanding in AI implementation',
                  icon: Icons.favorite,
                  primaryColor: Color(0xFF4A90E2),
                  completedLevels: 2,
                  totalLevels: 3,
                  onTap: () => print('Module tapped!'),
                ),

                // Example 2: Completed Module
                ModuleHeaderWidget(
                  title: 'Data Science Fundamentals',
                  subtitle: 'Master the basics of data analysis and visualization',
                  icon: Icons.analytics,
                  primaryColor: Color(0xFF4CAF50),
                  completedLevels: 5,
                  totalLevels: 5,
                  onTap: () => print('Completed module tapped!'),
                ),

                // Example 3: Just Started Module
                ModuleHeaderWidget(
                  title: 'Machine Learning Ethics',
                  subtitle: 'Understanding bias and fairness in AI systems',
                  icon: Icons.balance,
                  primaryColor: Color(0xFFFF9800),
                  completedLevels: 1,
                  totalLevels: 4,
                  showAnimation: false, // No animation
                ),

                // Example 4: Not Started Module
                ModuleHeaderWidget(
                  title: 'Advanced AI Concepts',
                  subtitle: 'Deep dive into neural networks and algorithms',
                  icon: Icons.psychology,
                  primaryColor: Color(0xFF9C27B0),
                  completedLevels: 0,
                  totalLevels: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}