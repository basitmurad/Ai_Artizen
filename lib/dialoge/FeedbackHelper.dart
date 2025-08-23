import 'package:flutter/material.dart';

class FeedbackHelper {
  /// 🔹 Builds a reusable coin reward widget
  static Widget buildCoinReward({
    required int coins,
    String moduleName = "",
    Color gradientStart = const Color(0xFFFFD54F), // amber[300]
    Color gradientEnd = const Color(0xFFFFB300),   // amber[500]
    double fontSize = 13,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [gradientStart, gradientEnd]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.monetization_on, color: Colors.white, size: 20),
          SizedBox(width: 4),
          Text(
            '+$coins coins ${moduleName.isNotEmpty ? "in \n $moduleName!" : ""}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Show feedback dialog (like for cards)
  static void showCardFeedback(
      BuildContext context, {
        required String feedbackText,
        required bool isCorrect,
        int rewardCoins = 0,
        String moduleName = "",
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCorrect ? Icons.check_circle : Icons.info_outline,
                color: isCorrect ? Colors.green : Colors.orange,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                isCorrect ? 'Excellent!' : 'Good Thinking!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feedbackText,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            if (isCorrect && rewardCoins > 0) ...[
              SizedBox(height: 16),
              buildCoinReward(coins: rewardCoins, moduleName: moduleName),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFE91E63),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  /// 🔹 Show simulation feedback snackbar
  static void showSimulationFeedback(
      BuildContext context, {
        required String choice,
        int rewardCoins = 0,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Choice recorded: $choice',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            if (rewardCoins > 0)
              buildCoinReward(coins: rewardCoins, fontSize: 12),
          ],
        ),
        backgroundColor: Colors.purple[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
