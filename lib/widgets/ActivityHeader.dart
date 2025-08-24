import 'package:artizen/models/JsonModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityHeader extends StatelessWidget {
  final Activity activity;
  final bool isSimulationActivity;
  final bool hasPassedActivity;
  final int userCoins;
  final String moduleID;
  final FirebaseAuth auth;
  final DatabaseReference database;
  final VoidCallback onBack;
  final String moduleName;

  const ActivityHeader({
    Key? key,
    required this.activity,
    required this.isSimulationActivity,
    required this.hasPassedActivity,
    required this.userCoins,
    required this.moduleID,
    required this.auth,
    required this.database,
    required this.onBack,
    required this.moduleName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),

          // Title, description and badges - full width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  moduleName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (activity.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    activity.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Badges below description
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Coins
                    StreamBuilder<DatabaseEvent>(
                      stream: auth.currentUser != null
                          ? database
                          .child('Progress')
                          .child(auth.currentUser!.uid)
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
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayCoins.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Activity type
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSimulationActivity
                              ? Colors.purple
                              : Colors.orange,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isSimulationActivity ? 'Simulation' : 'Cards',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Retry badge
                    if (hasPassedActivity)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'RETRY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}