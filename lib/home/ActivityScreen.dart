// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../models/JsonModel.dart';
//
// class ActivityScreen extends StatefulWidget {
//   final Scenario scenario;
//   final VoidCallback onActivityComplete;
//
//   const ActivityScreen({
//     super.key,
//     required this.scenario,
//     required this.onActivityComplete,
//   });
//
//   @override
//   State<ActivityScreen> createState() => _ActivityScreenState();
// }
//
// class _ActivityScreenState extends State<ActivityScreen> {
//   PageController _cardController = PageController();
//   int currentCardIndex = 0;
//   Map<int, String> cardAnswers = {}; // card_index -> answer
//
//   @override
//   void dispose() {
//     _cardController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final activity = widget.scenario.activity;
//
//     return Scaffold(
//       backgroundColor: Color(0xFFE91E63),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           activity.name,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           Container(
//             margin: EdgeInsets.only(right: 16),
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '${currentCardIndex + 1}/${activity.cards.length}',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFE91E63), Color(0xFFAD1457), Color(0xFF880E4F)],
//           ),
//         ),
//         child: Column(
//           children: [
//             // Progress bar
//             _buildActivityProgressBar(),
//
//             // Activity cards
//             Expanded(
//               child: PageView.builder(
//                 controller: _cardController,
//                 onPageChanged: (index) {
//                   setState(() {
//                     currentCardIndex = index;
//                   });
//                 },
//                 itemCount: activity.cards.length,
//                 itemBuilder: (context, index) {
//                   return _buildActivityCard(activity.cards[index], index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActivityProgressBar() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       height: 8,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: FractionallySizedBox(
//         alignment: Alignment.centerLeft,
//         widthFactor: widget.scenario.activity.cards.isNotEmpty
//             ? (currentCardIndex + 1) / widget.scenario.activity.cards.length
//             : 0.0,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActivityCard(ActivityCard card, int index) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Card content
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Consider this scenario:',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   card.statement,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.black87,
//                     height: 1.5,
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Text(
//                   'Is this Fair or Unfair?',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Color(0xFFE91E63),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: 24),
//
//           // Answer options
//           _buildAnswerOptions(card, index),
//
//           SizedBox(height: 24),
//
//           // Navigation
//           _buildActivityNavigation(index),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnswerOptions(ActivityCard card, int index) {
//     // Extract possible answers from the correct field
//     List<String> possibleAnswers = ['Fair', 'Unfair'];
//     if (card.correct.contains('Biased')) {
//       possibleAnswers = ['Fair', 'Biased Outcome', 'Valid Pattern'];
//     }
//
//     return Column(
//       children: possibleAnswers.map((answer) {
//         bool isSelected = cardAnswers[index] == answer;
//         bool isCorrect = answer == card.correct;
//         bool showResult = cardAnswers.containsKey(index);
//
//         return Container(
//           margin: EdgeInsets.only(bottom: 12),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: showResult ? null : () => _selectCardAnswer(index, answer, card),
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: showResult
//                       ? (isCorrect
//                       ? Colors.green.withOpacity(0.8)
//                       : isSelected
//                       ? Colors.red.withOpacity(0.8)
//                       : Colors.white.withOpacity(0.1))
//                       : (isSelected
//                       ? Colors.white
//                       : Colors.white.withOpacity(0.1)),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: showResult
//                         ? (isCorrect ? Colors.green : Colors.white.withOpacity(0.3))
//                         : (isSelected ? Color(0xFFE91E63) : Colors.white.withOpacity(0.3)),
//                     width: 2,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       showResult
//                           ? (isCorrect ? Icons.check_circle : Icons.cancel)
//                           : (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
//                       color: showResult
//                           ? Colors.white
//                           : (isSelected ? Color(0xFFE91E63) : Colors.white),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         answer,
//                         style: TextStyle(
//                           color: showResult || isSelected ? Colors.white : Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildActivityNavigation(int index) {
//     bool hasAnswer = cardAnswers.containsKey(index);
//     bool isLastCard = index == widget.scenario.activity.cards.length - 1;
//
//     return Row(
//       children: [
//         if (index > 0)
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () => _cardController.previousPage(
//                 duration: Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text('Previous'),
//             ),
//           ),
//
//         if (index > 0) SizedBox(width: 12),
//
//         Expanded(
//           flex: 2,
//           child: ElevatedButton(
//             onPressed: hasAnswer
//                 ? () => isLastCard ? _completeActivity() : _cardController.nextPage(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//             )
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: hasAnswer ? Colors.white : Colors.white.withOpacity(0.3),
//               foregroundColor: hasAnswer ? Color(0xFFE91E63) : Colors.white.withOpacity(0.5),
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               isLastCard ? 'Complete Activity' : 'Next',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _selectCardAnswer(int index, String answer, ActivityCard card) {
//     setState(() {
//       cardAnswers[index] = answer;
//     });
//
//     // Show feedback
//     Future.delayed(Duration(milliseconds: 500), () {
//       _showCardFeedback(card);
//     });
//   }
//
//   void _showCardFeedback(ActivityCard card) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text('Feedback'),
//         content: Text(card.feedback),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Continue'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _completeActivity() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green),
//             SizedBox(width: 8),
//             Text('Activity Complete!'),
//           ],
//         ),
//         content: Text(widget.scenario.activity.completionMessage),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               widget.onActivityComplete(); // Call completion callback
//             },
//             child: Text('Continue'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/JsonModel.dart';

class ActivityScreen extends StatefulWidget {
  final Scenario scenario;
  final VoidCallback onActivityComplete;

  const ActivityScreen({
    super.key,
    required this.scenario,
    required this.onActivityComplete,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  PageController _cardController = PageController();
  int currentCardIndex = 0;
  Map<int, String> cardAnswers = {}; // card_index -> answer

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Activity tracking
  int correctAnswersCount = 0;
  int totalCardsAnswered = 0;
  DateTime activityStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeActivityTracking();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _initializeActivityTracking() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Log activity start
        await _database
            .child('Progress')
            .child(user.uid)
            .child('activities')
            .child('${widget.scenario.id}_activity')
            .child('sessions')
            .push()
            .set({
          'scenarioId': widget.scenario.id,
          'activityName': widget.scenario.activity.name,
          'startTime': ServerValue.timestamp,
          'status': 'started',
        });

        print('📝 Activity tracking initialized for scenario ${widget.scenario.id}');
      }
    } catch (e) {
      print('❌ Error initializing activity tracking: $e');
    }
  }

  Future<void> _updateCardAnswer(int cardIndex, String answer, bool isCorrect) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      totalCardsAnswered++;
      if (isCorrect) {
        correctAnswersCount++;
      }

      // Update card-specific progress
      await _database
          .child('Progress')
          .child(user.uid)
          .child('activities')
          .child('${widget.scenario.id}_activity')
          .child('cards')
          .child(cardIndex.toString())
          .set({
        'cardIndex': cardIndex,
        'userAnswer': answer,
        'isCorrect': isCorrect,
        'timestamp': ServerValue.timestamp,
        'attempts': 1, // For future use if we want to track multiple attempts
      });

      // Update overall activity progress
      await _updateActivityProgress();

      print('✅ Card $cardIndex answer tracked - Correct: $isCorrect');
    } catch (e) {
      print('❌ Error updating card answer: $e');
    }
  }

  Future<void> _updateActivityProgress() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      double completionPercentage = (totalCardsAnswered / widget.scenario.activity.cards.length) * 100;
      double accuracyPercentage = totalCardsAnswered > 0
          ? (correctAnswersCount / totalCardsAnswered) * 100
          : 0;

      await _database
          .child('Progress')
          .child(user.uid)
          .child('activities')
          .child('${widget.scenario.id}_activity')
          .child('progress')
          .set({
        'scenarioId': widget.scenario.id,
        'activityName': widget.scenario.activity.name,
        'totalCards': widget.scenario.activity.cards.length,
        'cardsAnswered': totalCardsAnswered,
        'correctAnswers': correctAnswersCount,
        'completionPercentage': completionPercentage,
        'accuracyPercentage': accuracyPercentage,
        'lastUpdated': ServerValue.timestamp,
        'isCompleted': totalCardsAnswered >= widget.scenario.activity.cards.length,
      });

    } catch (e) {
      print('❌ Error updating activity progress: $e');
    }
  }

  Future<void> _completeActivityTracking() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DateTime endTime = DateTime.now();
      int durationSeconds = endTime.difference(activityStartTime).inSeconds;

      double finalAccuracy = totalCardsAnswered > 0
          ? (correctAnswersCount / totalCardsAnswered) * 100
          : 0;

      // Update completion data
      await _database
          .child('Progress')
          .child(user.uid)
          .child('activities')
          .child('${widget.scenario.id}_activity')
          .child('completion')
          .set({
        'completedAt': ServerValue.timestamp,
        'durationSeconds': durationSeconds,
        'finalAccuracy': finalAccuracy,
        'totalCorrect': correctAnswersCount,
        'totalCards': widget.scenario.activity.cards.length,
        'status': 'completed',
      });

      // Update user's overall activity stats
      await _updateUserActivityStats();

      // Award coins for activity completion
      await _awardActivityCoins();

      print('🏆 Activity completed - Accuracy: ${finalAccuracy.toStringAsFixed(1)}%');
    } catch (e) {
      print('❌ Error completing activity tracking: $e');
    }
  }

  Future<void> _updateUserActivityStats() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DatabaseReference userStatsRef = _database
          .child('Progress')
          .child(user.uid)
          .child('stats');

      // Get current stats
      DataSnapshot snapshot = await userStatsRef.get();
      Map<String, dynamic> stats = {};
      if (snapshot.exists) {
        stats = Map<String, dynamic>.from(snapshot.value as Map);
      }

      int currentActivitiesCompleted = stats['activitiesCompleted'] ?? 0;
      int currentTotalActivityCards = stats['totalActivityCards'] ?? 0;
      int currentCorrectActivityAnswers = stats['correctActivityAnswers'] ?? 0;

      await userStatsRef.update({
        'activitiesCompleted': currentActivitiesCompleted + 1,
        'totalActivityCards': currentTotalActivityCards + widget.scenario.activity.cards.length,
        'correctActivityAnswers': currentCorrectActivityAnswers + correctAnswersCount,
        'lastActivityCompleted': ServerValue.timestamp,
      });

    } catch (e) {
      print('❌ Error updating user activity stats: $e');
    }
  }

  Future<void> _awardActivityCoins() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      // Calculate coins based on performance
      int baseCoins = 5; // Base completion reward
      int accuracyBonus = (correctAnswersCount * 2); // 2 coins per correct answer
      int totalCoins = baseCoins + accuracyBonus;

      // Get current user coins
      DatabaseReference coinRef = _database.child('Progress').child(user.uid).child('coins');
      DataSnapshot coinSnapshot = await coinRef.get();
      int currentCoins = 0;
      if (coinSnapshot.exists) {
        currentCoins = coinSnapshot.value as int? ?? 0;
      }

      // Update coins
      await coinRef.set(currentCoins + totalCoins);

      // Log the coin transaction
      await _database
          .child('Progress')
          .child(user.uid)
          .child('coinTransactions')
          .push()
          .set({
        'type': 'activity_completion',
        'scenarioId': widget.scenario.id,
        'amount': totalCoins,
        'baseReward': baseCoins,
        'accuracyBonus': accuracyBonus,
        'timestamp': ServerValue.timestamp,
      });

      print('💰 Activity coins awarded: $totalCoins (Base: $baseCoins + Accuracy: $accuracyBonus)');
    } catch (e) {
      print('❌ Error awarding activity coins: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.scenario.activity;

    return Scaffold(
      backgroundColor: Color(0xFFE91E63),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          activity.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Progress indicator
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  '$correctAnswersCount/$totalCardsAnswered',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Card counter
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${currentCardIndex + 1}/${activity.cards.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE91E63), Color(0xFFAD1457), Color(0xFF880E4F)],
          ),
        ),
        child: Column(
          children: [
            // Progress bar
            _buildActivityProgressBar(),

            // Activity cards
            Expanded(
              child: PageView.builder(
                controller: _cardController,
                onPageChanged: (index) {
                  setState(() {
                    currentCardIndex = index;
                  });
                },
                itemCount: activity.cards.length,
                itemBuilder: (context, index) {
                  return _buildActivityCard(activity.cards[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityProgressBar() {
    return Container(
      margin: EdgeInsets.all(16),
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widget.scenario.activity.cards.isNotEmpty
            ? (currentCardIndex + 1) / widget.scenario.activity.cards.length
            : 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(ActivityCard card, int index) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Card content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consider this scenario:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  card.statement,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Is this Fair or Unfair?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFE91E63),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Answer options
          _buildAnswerOptions(card, index),

          SizedBox(height: 24),

          // Navigation
          _buildActivityNavigation(index),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(ActivityCard card, int index) {
    // Extract possible answers from the correct field
    List<String> possibleAnswers = ['Fair', 'Unfair'];
    if (card.correct.contains('Biased')) {
      possibleAnswers = ['Fair', 'Biased Outcome', 'Valid Pattern'];
    }

    return Column(
      children: possibleAnswers.map((answer) {
        bool isSelected = cardAnswers[index] == answer;
        bool isCorrect = answer == card.correct;
        bool showResult = cardAnswers.containsKey(index);

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: showResult ? null : () => _selectCardAnswer(index, answer, card),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: showResult
                      ? (isCorrect
                      ? Colors.green.withOpacity(0.8)
                      : isSelected
                      ? Colors.red.withOpacity(0.8)
                      : Colors.white.withOpacity(0.1))
                      : (isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: showResult
                        ? (isCorrect ? Colors.green : Colors.white.withOpacity(0.3))
                        : (isSelected ? Color(0xFFE91E63) : Colors.white.withOpacity(0.3)),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      showResult
                          ? (isCorrect ? Icons.check_circle : Icons.cancel)
                          : (isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                      color: showResult
                          ? Colors.white
                          : (isSelected ? Color(0xFFE91E63) : Colors.white),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        answer,
                        style: TextStyle(
                          color: showResult || isSelected ? Colors.white : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Show coin indicator for correct answers
                    if (showResult && isCorrect) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monetization_on, color: Colors.white, size: 12),
                            SizedBox(width: 2),
                            Text(
                              '+2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityNavigation(int index) {
    bool hasAnswer = cardAnswers.containsKey(index);
    bool isLastCard = index == widget.scenario.activity.cards.length - 1;

    return Row(
      children: [
        if (index > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: () => _cardController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Previous'),
            ),
          ),

        if (index > 0) SizedBox(width: 12),

        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: hasAnswer
                ? () => isLastCard ? _completeActivity() : _cardController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasAnswer ? Colors.white : Colors.white.withOpacity(0.3),
              foregroundColor: hasAnswer ? Color(0xFFE91E63) : Colors.white.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isLastCard ? 'Complete Activity' : 'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectCardAnswer(int index, String answer, ActivityCard card) async {
    bool isCorrect = answer == card.correct;

    setState(() {
      cardAnswers[index] = answer;
    });

    // Update Firebase with the card answer
    await _updateCardAnswer(index, answer, isCorrect);

    // Show feedback
    Future.delayed(Duration(milliseconds: 500), () {
      _showCardFeedback(card, isCorrect);
    });
  }

  void _showCardFeedback(ActivityCard card, bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.info_outline,
              color: isCorrect ? Colors.green : Colors.orange,
            ),
            SizedBox(width: 8),
            Text(isCorrect ? 'Correct!' : 'Feedback'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(card.feedback),
            if (isCorrect) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '+2 coins earned!',
                      style: TextStyle(
                        color: Colors.amber[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _completeActivity() async {
    // Complete activity tracking in Firebase
    await _completeActivityTracking();

    double accuracy = totalCardsAnswered > 0
        ? (correctAnswersCount / totalCardsAnswered) * 100
        : 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Activity Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.scenario.activity.completionMessage),
            SizedBox(height: 16),
            // Show performance summary
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Correct Answers:'),
                      Text(
                        '$correctAnswersCount/${widget.scenario.activity.cards.length}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Accuracy:'),
                      Text(
                        '${accuracy.toStringAsFixed(1)}%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            // Show coins earned
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    '+${5 + (correctAnswersCount * 2)} coins earned!',
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              widget.onActivityComplete(); // Call completion callback
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}