import 'dart:async';

import 'package:artizen/home/NewDashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/AIArtizenDashboard.dart';
import '../main.dart';
import 'AuthenticationScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo scale animation
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Text fade animation
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Slide animation for tagline
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _logoController.forward();

    Timer(Duration(milliseconds: 500), () {
      _textController.forward();
    });

    // Check authentication after animations complete
    Timer(Duration(seconds: 4), () {
      _checkAuthenticationAndNavigate();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // Check if user is authenticated and navigate accordingly
  Future<void> _checkAuthenticationAndNavigate() async {
    try {
      // Get current user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // User is logged in, check if email is verified (optional)
        if (currentUser.emailVerified || !_requireEmailVerification()) {
          // Navigate to dashboard
          _navigateToScreen(NewDashboard());
        } else {
          // Email not verified, navigate to authentication
          _navigateToScreen(AuthenticationScreen());
        }
      } else {
        // No user logged in, navigate to authentication
        _navigateToScreen(AuthenticationScreen());
      }
    } catch (e) {
      // Error checking authentication, navigate to login as fallback
      print('Error checking authentication: $e');
      _navigateToScreen(AuthenticationScreen());
    }
  }

  // Helper method to determine if email verification is required
  bool _requireEmailVerification() {
    // Set this to true if you want to require email verification
    // Set to false if you want to allow unverified users
    return false;
  }

  // Navigate to the specified screen with fade transition
  void _navigateToScreen(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),

              // Animated Logo
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoAnimation.value,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(75),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.psychology,
                              size: 60,
                              color: Color(0xFF667eea),
                            ),
                            Text(
                              'AI',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF667eea),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 30),

              // Animated App Name
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'AI Artizen',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Animated Tagline
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _textAnimation,
                  child: Text(
                    'Empowering Teachers with AI Literacy',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              Spacer(flex: 2),

              // Loading indicator with authentication status
              FadeTransition(
                opacity: _textAnimation,
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Checking authentication...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative splash screen with stream listener for real-time auth changes
class SplashScreenWithAuthStream extends StatefulWidget {
  @override
  _SplashScreenWithAuthStreamState createState() => _SplashScreenWithAuthStreamState();
}

class _SplashScreenWithAuthStreamState extends State<SplashScreenWithAuthStream>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Offset> _slideAnimation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription<User?> _authSubscription;
  bool _animationCompleted = false;
  bool _navigationDone = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations (same as before)
    _logoController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _logoController.forward();

    Timer(Duration(milliseconds: 500), () {
      _textController.forward();
    });

    // Mark animation as completed after 4 seconds
    Timer(Duration(seconds: 4), () {
      _animationCompleted = true;
      _checkAndNavigate();
    });

    // Listen to auth state changes
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (_animationCompleted && !_navigationDone) {
        _checkAndNavigate();
      }
    });
  }

  void _checkAndNavigate() {
    if (_navigationDone) return;

    User? currentUser = _auth.currentUser;

    _navigationDone = true;

    if (currentUser != null) {
      _navigateToScreen(NewDashboard());
    } else {
      _navigateToScreen(AuthenticationScreen());
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Same build method as the first implementation
    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoAnimation.value,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(75),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.psychology,
                              size: 60,
                              color: Color(0xFF667eea),
                            ),
                            Text(
                              'AI',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF667eea),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'AI Artizen',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _textAnimation,
                  child: Text(
                    'Empowering Teachers with AI Literacy',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Spacer(flex: 2),
              FadeTransition(
                opacity: _textAnimation,
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Checking authentication...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}