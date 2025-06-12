
// dashboard_components.dart

import 'package:flutter/material.dart';

/// Utility class for text formatting and string operations
class DashboardUtils {
  /// Capitalizes the first letter of a given text
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

/// Widget class for loading indicators used in the dashboard
class DashboardLoadingWidget extends StatelessWidget {
  final String message;

  const DashboardLoadingWidget({
    Key? key,
    this.message = 'Loading your progress...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            message,
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
}

/// Widget class for user avatar display
class UserAvatarWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final double size;

  const UserAvatarWidget({
    Key? key,
    required this.userProfile,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: _getAvatarContent(),
      ),
    );
  }

  Widget _getAvatarContent() {
    String initials = userProfile['initials'] ?? 'U';
    return Container(
      color: Color(0xFF4A90E2),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4, // Responsive font size based on avatar size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Widget class for the dashboard header component
class DashboardHeader extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final int totalCoins;
  final AnimationController coinController;
  final VoidCallback onRefresh;

  const DashboardHeader({
    Key? key,
    required this.userProfile,
    required this.totalCoins,
    required this.coinController,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // User Profile Section
          Expanded(
            child: Row(
              children: [
                // Profile Avatar
                UserAvatarWidget(userProfile: userProfile),
                SizedBox(width: 12),
                // User Info with Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ' ${DashboardUtils.capitalizeFirstLetter(userProfile['displayName'] ?? 'User')}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 16),

          // Coins Display
          _buildCoinsDisplay(),

          SizedBox(width: 16),

          // Right Section - Action Buttons
          Row(
            children: [
              // Refresh button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white, size: 20),
                  onPressed: onRefresh,
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ),
              SizedBox(width: 8),
              // Profile menu button can be added here
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoinsDisplay() {
    return AnimatedBuilder(
      animation: coinController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (coinController.value * 0.1),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 4),
                AnimatedBuilder(
                  animation: coinController,
                  builder: (context, child) {
                    int displayCoins = (totalCoins * coinController.value).round();
                    return Text(
                      '$displayCoins',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

