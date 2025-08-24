import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompletionDialog extends StatelessWidget {
  final int correct;
  final int total;
  final int stars;
  final String moduleName;
  final String moduleID;
  final int userCoins;
  final FirebaseAuth auth;
  final DatabaseReference database;

  const CompletionDialog({
    super.key,
    required this.correct,
    required this.total,
    required this.stars,
    required this.moduleName,
    required this.moduleID,
    required this.userCoins,
    required this.auth,
    required this.database,
  });

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.celebration, color: Colors.orange, size: 30),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Level Complete!'),
                Text(
                  moduleName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You answered $correct out of $total questions correctly!',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 30,
              );
            }),
          ),
          SizedBox(height: 16),
          StreamBuilder<DatabaseEvent>(
            stream: user != null
                ? database
                .child('Progress')
                .child(user.uid)
                .child(moduleID)
                .child('coins')
                .onValue
                : null,
            builder: (context, snapshot) {
              int displayCoins = userCoins;
              if (snapshot.hasData && snapshot.data!.snapshot.exists) {
                displayCoins = snapshot.data!.snapshot.value as int? ?? 0;
              }

              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          'Module Coins: $displayCoins',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$moduleName Progress',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Return to previous screen
          },
          child: Text('Continue'),
        ),
      ],
    );
  }
}
