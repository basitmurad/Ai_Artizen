
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'UserDetailScreen.dart';

class LeaderboardDashboard extends StatefulWidget {
  const LeaderboardDashboard({super.key});

  @override
  _LeaderboardDashboardState createState() => _LeaderboardDashboardState();
}

class _LeaderboardDashboardState extends State<LeaderboardDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = true;
  List<LeaderboardUser> _leaderboardData = [];
  Map<String, String> _userIdMap = {}; // Store userId for each user

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadLeaderboardData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
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

  Future<void> _loadLeaderboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch leaderboard data from Firebase Realtime Database
      List<LeaderboardUser> tempLeaderboardData = await _fetchLeaderboardFromRealtimeDB();

      _leaderboardData = tempLeaderboardData;
    } catch (e) {
      print('Error loading leaderboard data: $e');
      // Show error or keep empty list
      _leaderboardData = [];
    }

    setState(() {
      _isLoading = false;
    });

    _animationController.forward();
  }

  Future<List<LeaderboardUser>> _fetchLeaderboardFromRealtimeDB() async {
    final DatabaseReference progressRef = FirebaseDatabase.instance.ref().child('Progress');
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    List<LeaderboardUser> leaderboardUsers = [];

    try {
      // Fetch all progress data
      final DataSnapshot progressSnapshot = await progressRef.get();

      if (progressSnapshot.exists) {
        Map<dynamic, dynamic> progressData = progressSnapshot.value as Map<dynamic, dynamic>;

        List<MapEntry<String, Map<dynamic, dynamic>>> userProgressList = [];

        // Extract user IDs and their progress data
        progressData.forEach((userId, userProgressMap) {
          print("User ID: $userId");

          if (userProgressMap is Map<dynamic, dynamic>) {
            // Aggregate data from all modules for this user
            Map<dynamic, dynamic> aggregatedUserData = {
              'coins': 0,
              'correctAnswers': 0,
              'levelsCompleted': 0,
              'lastActivity': null,
              'streak': 0,
              'moduleName': 'Multiple Modules',
            };

            // Iterate through all modules for this user
            userProgressMap.forEach((moduleKey, moduleData) {
              if (moduleData is Map<dynamic, dynamic>) {
                print("Found module '$moduleKey' for user: $userId");

                // Aggregate coins
                if (moduleData['coins'] != null) {
                  aggregatedUserData['coins'] = (aggregatedUserData['coins'] ?? 0) + (moduleData['coins'] ?? 0);
                }

                // Aggregate correct answers
                if (moduleData['correctAnswers'] != null) {
                  aggregatedUserData['correctAnswers'] = (aggregatedUserData['correctAnswers'] ?? 0) + (moduleData['correctAnswers'] ?? 0);
                }

                // Aggregate levels completed
                if (moduleData['levelsCompleted'] != null) {
                  aggregatedUserData['levelsCompleted'] = (aggregatedUserData['levelsCompleted'] ?? 0) + (moduleData['levelsCompleted'] ?? 0);
                }

                // Keep the most recent activity
                if (moduleData['lastActivity'] != null) {
                  int currentActivity = 0;
                  try {
                    if (moduleData['lastActivity'] is int) {
                      currentActivity = moduleData['lastActivity'];
                    } else if (moduleData['lastActivity'] is String) {
                      currentActivity = DateTime.parse(moduleData['lastActivity']).millisecondsSinceEpoch;
                    }

                    if (aggregatedUserData['lastActivity'] == null ||
                        currentActivity > (aggregatedUserData['lastActivity'] ?? 0)) {
                      aggregatedUserData['lastActivity'] = currentActivity;
                    }
                  } catch (e) {
                    print('Error parsing lastActivity for user $userId, module $moduleKey: $e');
                  }
                }

                // Use the highest streak among all modules
                if (moduleData['streak'] != null) {
                  int moduleStreak = moduleData['streak']?.toInt() ?? 0;
                  if (moduleStreak > (aggregatedUserData['streak'] ?? 0)) {
                    aggregatedUserData['streak'] = moduleStreak;
                  }
                }
              }
            });

            // Only add users who have some progress (coins > 0)
            if ((aggregatedUserData['coins'] ?? 0) > 0) {
              print("Aggregated data for user $userId: ${aggregatedUserData['coins']} coins, ${aggregatedUserData['correctAnswers']} correct answers");
              userProgressList.add(MapEntry(userId.toString(), aggregatedUserData));
            } else {
              print("No progress data found for user: $userId");
            }
          }
        });

        print("Total users found with progress data: ${userProgressList.length}");

        // Sort by coins in descending order (highest coins first)
        userProgressList.sort((a, b) =>
            (b.value['coins'] ?? 0).compareTo(a.value['coins'] ?? 0)
        );

        print('Found ${userProgressList.length} users with progress data');

        // Fetch user information for ALL users
        for (int i = 0; i < userProgressList.length; i++) {
          final userEntry = userProgressList[i];
          final userId = userEntry.key;
          final progressData = userEntry.value;

          print('Processing user $userId with ${progressData['coins']} coins');

          // Default user info
          String username = 'User${userId.substring(0, min(8, userId.length))}';
          String avatar = '👤';

          // Fetch user info from Users node
          try {
            final DataSnapshot userSnapshot = await usersRef.child(userId).get();
            if (userSnapshot.exists) {
              final userData = userSnapshot.value as Map<dynamic, dynamic>?;
              if (userData != null) {
                print("User data for $userId: $userData");

                // Try different possible username fields
                username = userData['username']?.toString() ??
                    userData['displayName']?.toString() ??
                    userData['name']?.toString() ??
                    username;

                print("Extracted username: $username for user ID: $userId");
              }
            } else {
              print("No user data found for user ID: $userId");
            }
          } catch (e) {
            print('Error fetching user $userId: $e');
          }

          // Extract progress data with null safety
          int totalCoins = progressData['coins']?.toInt() ?? 0;
          int correctAnswers = progressData['correctAnswers']?.toInt() ?? 0;
          int levelsCompleted = progressData['levelsCompleted']?.toInt() ?? 0;

          // Calculate average stars
          double averageStars = 0.0;
          if (correctAnswers > 0) {
            // Calculate based on correct answers (adjust formula as needed)
            averageStars = (correctAnswers / (correctAnswers + 1)) * 3.0;
            averageStars = double.parse(averageStars.toStringAsFixed(1));
          }

          // Calculate streak
          int streak = 0;
          if (progressData['lastActivity'] != null) {
            try {
              final lastActivityValue = progressData['lastActivity'];
              DateTime lastActivity;

              if (lastActivityValue is int) {
                lastActivity = DateTime.fromMillisecondsSinceEpoch(lastActivityValue);
              } else if (lastActivityValue is String) {
                lastActivity = DateTime.parse(lastActivityValue);
              } else {
                lastActivity = DateTime.now();
              }

              final daysSinceLastActivity = DateTime.now().difference(lastActivity).inDays;

              // If active within last day, maintain streak, otherwise reset
              if (daysSinceLastActivity <= 1) {
                streak = progressData['streak']?.toInt() ?? 1;
              }
            } catch (e) {
              print('Error calculating streak for user $userId: $e');
            }
          }

          // Use the streak from aggregated data if no calculation was done above
          if (streak == 0) {
            streak = progressData['streak']?.toInt() ?? 0;
          }

          // Determine badge color based on rank
          Color badgeColor;
          if (i == 0) {
            badgeColor = Color(0xFFFFD700); // Gold for 1st place
          } else if (i == 1) {
            badgeColor = Color(0xFFC0C0C0); // Silver for 2nd place
          } else if (i == 2) {
            badgeColor = Color(0xFFCD7F32); // Bronze for 3rd place
          } else if (i < 10) {
            badgeColor = Color(0xFF6A5ACD); // Purple for top 10
          } else if (i < 20) {
            badgeColor = Color(0xFF4A90E2); // Blue for top 20
          } else if (i < 50) {
            badgeColor = Color(0xFF2E7D32); // Green for top 50
          } else {
            badgeColor = Color(0xFF757575); // Gray for others
          }

          final leaderboardUser = LeaderboardUser(
            rank: i + 1,
            username: username,
            totalCoins: totalCoins,
            completedModules: levelsCompleted,
            averageStars: averageStars,
            streak: streak,
            correctAnswers: correctAnswers,
            badgeColor: badgeColor,
          );

          leaderboardUsers.add(leaderboardUser);

          // Store the userId mapping for navigation
          _userIdMap[username] = userId;

          print("Added user to leaderboard: $username (ID: $userId) with $totalCoins coins");
        }
      }
    } catch (e) {
      print('Error fetching from Realtime Database: $e');
    }

    print('Returning ${leaderboardUsers.length} users for leaderboard');
    return leaderboardUsers;
  }

  void _navigateToUserDetail(LeaderboardUser user) {
    final userId = _userIdMap[user.username];
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailScreen(
            userId: userId,
            user: user,
          ),
        ),
      );
    }
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
                child: _isLoading ? _buildLoadingState() : _buildLeaderboard(),
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
              padding: EdgeInsets.all(8),
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
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Top AI Artizens by Coins',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 24,
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
            'Loading leaderboard...',
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

  Widget _buildLeaderboard() {
    if (_leaderboardData.isEmpty) {
      return _buildEmptyState();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              // Always show podium if we have 3 or more users
              if (_leaderboardData.length >= 3) ...[
                _buildPodium(),
                SizedBox(height: 20),
              ],
              // Always show the complete ranking list with ALL users
              _buildRankingList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.6),
          ),
          SizedBox(height: 20),
          Text(
            'No leaderboard data available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete some modules to appear on the leaderboard!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPodium() {
    return Container(
      height: 220,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => _navigateToUserDetail(_leaderboardData[1]),
            child: _buildPodiumPosition(_leaderboardData[1], 2, 120),
          ), // 2nd place
          GestureDetector(
            onTap: () => _navigateToUserDetail(_leaderboardData[0]),
            child: _buildPodiumPosition(_leaderboardData[0], 1, 150),
          ), // 1st place
          GestureDetector(
            onTap: () => _navigateToUserDetail(_leaderboardData[2]),
            child: _buildPodiumPosition(_leaderboardData[2], 3, 100),
          ), // 3rd place
        ],
      ),
    );
  }

  Widget _buildPodiumPosition(LeaderboardUser user, int position, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 8),
        Text(
          user.username,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          '${user.totalCoins} 🪙',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${user.correctAnswers} correct',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: user.badgeColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              '$position',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingList() {
    // Show ALL users in the list (including top 3)
    if (_leaderboardData.isEmpty) return SizedBox.shrink();

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.list, color: Colors.white.withOpacity(0.7), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Complete Rankings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${_leaderboardData.length} users',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: _leaderboardData.length, // Show ALL users
                itemBuilder: (context, index) {
                  final user = _leaderboardData[index];
                  return _buildRankingItem(user, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingItem(LeaderboardUser user, int index) {
    // Add special styling for top 3 users in the list
    bool isTopThree = user.rank <= 3;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isTopThree
            ? user.badgeColor.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTopThree
              ? user.badgeColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.2),
          width: isTopThree ? 2 : 1,
        ),
        boxShadow: isTopThree ? [
          BoxShadow(
            color: user.badgeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ] : null,
      ),
      child: ListTile(
        onTap: () => _navigateToUserDetail(user),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: user.badgeColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.white,
                    width: isTopThree ? 2 : 1
                ),
                boxShadow: isTopThree ? [
                  BoxShadow(
                    color: user.badgeColor.withOpacity(0.4),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Center(
                child: Text(
                  '${user.rank}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTopThree ? 12 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            // Special crown icon for top 3
            if (isTopThree) ...[
              SizedBox(width: 4),
              Icon(
                user.rank == 1 ? Icons.emoji_events :
                user.rank == 2 ? Icons.military_tech : Icons.workspace_premium,
                color: user.badgeColor,
                size: 16,
              ),
            ],
          ],
        ),
        title: Text(
          user.username,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isTopThree ? FontWeight.w800 : FontWeight.bold,
            fontSize: isTopThree ? 17 : 16,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 14),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${user.correctAnswers} correct',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: isTopThree ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.7), size: 14),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${user.averageStars.toStringAsFixed(1)} avg',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: isTopThree ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.whatshot, color: Colors.orange, size: 14),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${user.streak} streak',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: isTopThree ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.school, color: Colors.blue, size: 14),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${user.completedModules} modules',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: isTopThree ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.totalCoins}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isTopThree ? 16 : 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '🪙 coins',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: isTopThree ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderboardUser {
  final int rank;
  final String username;
  final int totalCoins;
  final int completedModules;
  final double averageStars;
  final int streak;
  final int correctAnswers;
  final Color badgeColor;

  LeaderboardUser({
    required this.rank,
    required this.username,
    required this.totalCoins,
    required this.completedModules,
    required this.averageStars,
    required this.streak,
    required this.correctAnswers,
    required this.badgeColor,
  });
}




