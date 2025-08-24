import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String message;
  final Color? indicatorColor;
  final Color? textColor;
  final double? textSize;
  final FontWeight? textWeight;

  const LoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.indicatorColor,
    this.textColor,
    this.textSize = 16.0,
    this.textWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              indicatorColor ?? Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: textSize,
              fontWeight: textWeight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Alternative version with animation
class AnimatedLoadingIndicator extends StatefulWidget {
  final String message;
  final Color? indicatorColor;
  final Color? textColor;
  final double? textSize;
  final FontWeight? textWeight;
  final Duration animationDuration;

  const AnimatedLoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.indicatorColor,
    this.textColor,
    this.textSize = 16.0,
    this.textWeight = FontWeight.w500,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  _AnimatedLoadingIndicatorState createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.indicatorColor ?? Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.message,
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: widget.textSize,
                fontWeight: widget.textWeight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Specialized version for the AI Artizen Dashboard
class DashboardLoadingIndicator extends StatelessWidget {
  final String message;

  const DashboardLoadingIndicator({
    super.key,
    this.message = 'Loading your progress...',
  });

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      message: message,
      indicatorColor: Colors.white,
      textColor: Colors.white,
      textSize: 16.0,
      textWeight: FontWeight.w500,
    );
  }
}