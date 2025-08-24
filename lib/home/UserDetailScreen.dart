import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'LeaderboardDashboard.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;
  final LeaderboardUser user;

  const UserDetailScreen({
    super.key,
    required this.userId,
    required this.user,
  });

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = true;
  final Map<String, ModuleProgress> _moduleProgress = {};
  Map<String, dynamic> _userDetails = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserDetails();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final DatabaseReference progressRef = FirebaseDatabase.instance
          .ref()
          .child('Progress')
          .child(widget.userId);

      final DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(widget.userId);

      // Fetch user basic details
      final DataSnapshot userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        _userDetails = userSnapshot.value as Map<String, dynamic>;
      }

      // Fetch detailed progress data
      final DataSnapshot progressSnapshot = await progressRef.get();
      if (progressSnapshot.exists) {
        Map<dynamic, dynamic> progressData = progressSnapshot.value as Map<dynamic, dynamic>;

        progressData.forEach((moduleKey, moduleData) {
          if (moduleData is Map<dynamic, dynamic>) {
            _moduleProgress[moduleKey.toString()] = ModuleProgress(
              moduleName: moduleKey.toString(),
              coins: moduleData['coins']?.toInt() ?? 0,
              correctAnswers: moduleData['correctAnswers']?.toInt() ?? 0,
              levelsCompleted: moduleData['levelsCompleted']?.toInt() ?? 0,
              streak: moduleData['streak']?.toInt() ?? 0,
              lastActivity: _parseLastActivity(moduleData['lastActivity']),
              totalQuestions: moduleData['totalQuestions']?.toInt() ?? 0,
              averageStars: _calculateModuleStars(moduleData),
            );
          }
        });
      }
    } catch (e) {
      print('Error loading user details: $e');
    }

    setState(() {
      _isLoading = false;
    });

    _animationController.forward();
  }

  DateTime? _parseLastActivity(dynamic lastActivity) {
    if (lastActivity == null) return null;

    try {
      if (lastActivity is int) {
        return DateTime.fromMillisecondsSinceEpoch(lastActivity);
      } else if (lastActivity is String) {
        return DateTime.parse(lastActivity);
      }
    } catch (e) {
      print('Error parsing last activity: $e');
    }
    return null;
  }

  double _calculateModuleStars(Map<dynamic, dynamic> moduleData) {
    int correctAnswers = moduleData['correctAnswers']?.toInt() ?? 0;
    int totalQuestions = moduleData['totalQuestions']?.toInt() ?? 1;

    if (totalQuestions == 0) return 0.0;

    double accuracy = correctAnswers / totalQuestions;
    return (accuracy * 3.0).clamp(0.0, 3.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF7B68EE),
              Color(0xFF6A5ACD),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoading ? _buildLoadingState() : _buildUserDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.username,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Rank #${widget.user.rank} • ${widget.user.totalCoins} coins',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.user.badgeColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.user.badgeColor, width: 2),
            ),
            child: Text(
              '#${widget.user.rank}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Loading user details...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewCard(),
              SizedBox(height: 20),
              _buildStatsCards(),
              SizedBox(height: 20),
              // _buildModuleProgress(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: widget.user.badgeColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'AI Artizen',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: List.generate(3, (index) {
                        return Icon(
                          index < widget.user.averageStars.floor()
                              ? Icons.star
                              : index < widget.user.averageStars
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewStat('Total Coins', '${widget.user.totalCoins}', '🪙'),
              _buildOverviewStat('Correct Answers', '${widget.user.correctAnswers}', '✅'),
              _buildOverviewStat('Current Streak', '${widget.user.streak}', '🔥'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value, String emoji) {
    return Column(
      children: [
        Text(
          '$emoji $value',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Accuracy',
            '${(widget.user.correctAnswers / max(1, widget.user.correctAnswers + 10) * 100).toStringAsFixed(1)}%',
            Icons.tablet,
            Colors.green,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Modules',
            '${widget.user.completedModules}',
            Icons.school,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildModuleProgress() {
  //   if (_moduleProgress.isEmpty) {
  //     return Container(
  //       padding: EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         color: Colors.white.withOpacity(0.15),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Center(
  //         child: Text(
  //           'No module progress available',
  //           style: TextStyle(
  //             color: Colors.white.withOpacity(0.8),
  //             fontSize: 16,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Module Progress',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       SizedBox(height: 12),
  //       ..._moduleProgress.entries.map((entry) => _buildModuleCard(entry.value)),
  //     ],
  //   );
  // }

  Widget _buildModuleCard(ModuleProgress module) {
    double progressPercentage = module.totalQuestions > 0
        ? (module.correctAnswers / module.totalQuestions).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  module.moduleName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${module.coins} 🪙',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress: ${(progressPercentage * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progressPercentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Row(
                children: List.generate(3, (index) {
                  return Icon(
                    index < module.averageStars.floor()
                        ? Icons.star
                        : index < module.averageStars
                        ? Icons.star_half
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${module.correctAnswers}/${module.totalQuestions} correct',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              Text(
                'Streak: ${module.streak}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (module.lastActivity != null) ...[
            SizedBox(height: 4),
            Text(
              'Last active: ${_formatLastActivity(module.lastActivity!)}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatLastActivity(DateTime lastActivity) {
    final now = DateTime.now();
    final difference = now.difference(lastActivity);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class ModuleProgress {
  final String moduleName;
  final int coins;
  final int correctAnswers;
  final int levelsCompleted;
  final int streak;
  final DateTime? lastActivity;
  final int totalQuestions;
  final double averageStars;

  ModuleProgress({
    required this.moduleName,
    required this.coins,
    required this.correctAnswers,
    required this.levelsCompleted,
    required this.streak,
    this.lastActivity,
    required this.totalQuestions,
    required this.averageStars,
  });
}