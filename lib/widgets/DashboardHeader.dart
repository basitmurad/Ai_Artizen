import 'package:flutter/material.dart';

// Main Dashboard Header Widget
class DashboardHeader extends StatelessWidget {
  final String displayName;
  final String userInitials;
  final int totalCoins;
  final AnimationController coinController;
  final VoidCallback onRefresh;
  final List<Widget>? additionalActions;

  const DashboardHeader({
    Key? key,
    required this.displayName,
    required this.userInitials,
    required this.totalCoins,
    required this.coinController,
    required this.onRefresh,
    this.additionalActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // User Profile Section
          Expanded(
            child: UserProfileSection(
              displayName: displayName,
              userInitials: userInitials,
            ),
          ),
          SizedBox(width: 16),
          // Coins Display
          AnimatedCoinsDisplay(
            totalCoins: totalCoins,
            coinController: coinController,
          ),
          SizedBox(width: 16),
          // Action Buttons
          HeaderActionButtons(
            onRefresh: onRefresh,
            additionalActions: additionalActions,
          ),
        ],
      ),
    );
  }
}

// User Profile Section Widget
class UserProfileSection extends StatelessWidget {
  final String displayName;
  final String userInitials;
  final Widget? customAvatar;

  const UserProfileSection({
    Key? key,
    required this.displayName,
    required this.userInitials,
    this.customAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Avatar
        ProfileAvatar(
          userInitials: userInitials,
          customAvatar: customAvatar,
        ),
        SizedBox(width: 12),
        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' ${_capitalizeFirstLetter(displayName)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// Profile Avatar Widget
class ProfileAvatar extends StatelessWidget {
  final String userInitials;
  final Widget? customAvatar;
  final double size;
  final Color backgroundColor;
  final Color borderColor;

  const ProfileAvatar({
    Key? key,
    required this.userInitials,
    this.customAvatar,
    this.size = 40,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: customAvatar ?? _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Color(0xFF4A90E2),
      child: Center(
        child: Text(
          userInitials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Animated Coins Display Widget
class AnimatedCoinsDisplay extends StatelessWidget {
  final int totalCoins;
  final AnimationController coinController;
  final Color gradientStart;
  final Color gradientEnd;
  final IconData coinIcon;

  const AnimatedCoinsDisplay({
    Key? key,
    required this.totalCoins,
    required this.coinController,
    this.gradientStart = const Color(0xFFFFD700),
    this.gradientEnd = const Color(0xFFFFA500),
    this.coinIcon = Icons.monetization_on,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: coinController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (coinController.value * 0.1),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientStart, gradientEnd],
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
                  coinIcon,
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

// Header Action Buttons Widget
class HeaderActionButtons extends StatelessWidget {
  final VoidCallback onRefresh;
  final List<Widget>? additionalActions;

  const HeaderActionButtons({
    Key? key,
    required this.onRefresh,
    this.additionalActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Refresh button
        HeaderActionButton(
          icon: Icons.refresh,
          onPressed: onRefresh,
        ),
        if (additionalActions != null) ...[
          SizedBox(width: 8),
          ...additionalActions!,
        ],
      ],
    );
  }
}

// Individual Action Button Widget
class HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const HeaderActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: size),
        onPressed: onPressed,
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }
}

class AIArtizenDashboardHeader extends StatelessWidget {
  final String displayName;
  final String userInitials;
  final int totalCoins;
  final AnimationController coinController;
  final VoidCallback onRefresh;

  const AIArtizenDashboardHeader({
    Key? key,
    required this.displayName,
    required this.userInitials,
    required this.totalCoins,
    required this.coinController,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardHeader(
      displayName: displayName,
      userInitials: userInitials,
      totalCoins: totalCoins,
      coinController: coinController,
      onRefresh: onRefresh,
      additionalActions: [
        // You can add more action buttons here in the future
        // HeaderActionButton(
        //   icon: Icons.settings,
        //   onPressed: () => _showSettings(context),
        // ),
      ],
    );
  }
}
// Specialized Dashboard Header for AI Artizen
// class AIArtizenDashboardHeader extends StatelessWidget {
//   final String displayName;
//   final String userInitials;
//   final int totalCoins;
//   final AnimationController coinController;
//   final VoidCallback onRefresh;
//
//   const AIArtizenDashboardHeader({
//     Key? key,
//     required this.displayName,
//     required this.userInitials,
//     required this.totalCoins,
//     required this.coinController,
//     required this.onRefresh,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DashboardHeader(
//       displayName: displayName,
//       userInitials: userInitials,
//       totalCoins: totalCoins,
//       coinController: coinController,
//       onRefresh: onRefresh,
//       additionalActions: [
//         // You can add more action buttons here in the future
//         // HeaderActionButton(
//         //   icon: Icons.settings,
//         //   onPressed: () => _showSettings(context),
//         // ),
//       ],
//     );
//   }
// }