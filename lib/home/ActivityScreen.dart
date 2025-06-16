// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
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
//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   // Activity tracking
//   int correctAnswersCount = 0;
//   int totalCardsAnswered = 0;
//   DateTime activityStartTime = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeActivityTracking();
//   }
//
//   @override
//   void dispose() {
//     _cardController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initializeActivityTracking() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         // Log activity start
//         await _database
//             .child('Progress')
//             .child(user.uid)
//             .child('activities')
//             .child('${widget.scenario.id}_activity')
//             .child('sessions')
//             .push()
//             .set({
//           'scenarioId': widget.scenario.id,
//           'activityName': widget.scenario.activity?.name,
//           'startTime': ServerValue.timestamp,
//           'status': 'started',
//         });
//
//         print('📝 Activity tracking initialized for scenario ${widget.scenario.id}');
//       }
//     } catch (e) {
//       print('❌ Error initializing activity tracking: $e');
//     }
//   }
//
//   Future<void> _updateCardAnswer(int cardIndex, String answer, bool isCorrect) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       totalCardsAnswered++;
//       if (isCorrect) {
//         correctAnswersCount++;
//       }
//
//       // Update card-specific progress
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('cards')
//           .child(cardIndex.toString())
//           .set({
//         'cardIndex': cardIndex,
//         'userAnswer': answer,
//         'isCorrect': isCorrect,
//         'timestamp': ServerValue.timestamp,
//         'attempts': 1, // For future use if we want to track multiple attempts
//       });
//
//       // Update overall activity progress
//       await _updateActivityProgress();
//
//       print('✅ Card $cardIndex answer tracked - Correct: $isCorrect');
//     } catch (e) {
//       print('❌ Error updating card answer: $e');
//     }
//   }
//
//   Future<void> _updateActivityProgress() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       double completionPercentage = (totalCardsAnswered / widget.scenario.activity!.cards!.length) * 100;
//       double accuracyPercentage = totalCardsAnswered > 0
//           ? (correctAnswersCount / totalCardsAnswered) * 100
//           : 0;
//
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('progress')
//           .set({
//         'scenarioId': widget.scenario.id,
//         'activityName': widget.scenario.activity!.name,
//         'totalCards': widget.scenario.activity!.cards!.length,
//         'cardsAnswered': totalCardsAnswered,
//         'correctAnswers': correctAnswersCount,
//         'completionPercentage': completionPercentage,
//         'accuracyPercentage': accuracyPercentage,
//         'lastUpdated': ServerValue.timestamp,
//         'isCompleted': totalCardsAnswered >= widget.scenario.activity!.cards!.length,
//       });
//
//     } catch (e) {
//       print('❌ Error updating activity progress: $e');
//     }
//   }
//
//   Future<void> _completeActivityTracking() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       DateTime endTime = DateTime.now();
//       int durationSeconds = endTime.difference(activityStartTime).inSeconds;
//
//       double finalAccuracy = totalCardsAnswered > 0
//           ? (correctAnswersCount / totalCardsAnswered) * 100
//           : 0;
//
//       // Update completion data
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('completion')
//           .set({
//         'completedAt': ServerValue.timestamp,
//         'durationSeconds': durationSeconds,
//         'finalAccuracy': finalAccuracy,
//         'totalCorrect': correctAnswersCount,
//         'totalCards': widget.scenario.activity!.cards!.length,
//         'status': 'completed',
//       });
//
//       // Update user's overall activity stats
//       await _updateUserActivityStats();
//
//       // Award coins for activity completion
//       await _awardActivityCoins();
//
//       print('🏆 Activity completed - Accuracy: ${finalAccuracy.toStringAsFixed(1)}%');
//     } catch (e) {
//       print('❌ Error completing activity tracking: $e');
//     }
//   }
//
//   Future<void> _updateUserActivityStats() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       DatabaseReference userStatsRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child('stats');
//
//       // Get current stats
//       DataSnapshot snapshot = await userStatsRef.get();
//       Map<String, dynamic> stats = {};
//       if (snapshot.exists) {
//         stats = Map<String, dynamic>.from(snapshot.value as Map);
//       }
//
//       int currentActivitiesCompleted = stats['activitiesCompleted'] ?? 0;
//       int currentTotalActivityCards = stats['totalActivityCards'] ?? 0;
//       int currentCorrectActivityAnswers = stats['correctActivityAnswers'] ?? 0;
//
//       await userStatsRef.update({
//         'activitiesCompleted': currentActivitiesCompleted + 1,
//         'totalActivityCards': currentTotalActivityCards + widget.scenario.activity!.cards!.length,
//         'correctActivityAnswers': currentCorrectActivityAnswers + correctAnswersCount,
//         'lastActivityCompleted': ServerValue.timestamp,
//       });
//
//     } catch (e) {
//       print('❌ Error updating user activity stats: $e');
//     }
//   }
//
//   Future<void> _awardActivityCoins() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       // Calculate coins based on performance
//       int baseCoins = 5; // Base completion reward
//       int accuracyBonus = (correctAnswersCount * 2); // 2 coins per correct answer
//       int totalCoins = baseCoins + accuracyBonus;
//
//       // Get current user coins
//       DatabaseReference coinRef = _database.child('Progress').child(user.uid).child('coins');
//       DataSnapshot coinSnapshot = await coinRef.get();
//       int currentCoins = 0;
//       if (coinSnapshot.exists) {
//         currentCoins = coinSnapshot.value as int? ?? 0;
//       }
//
//       // Update coins
//       await coinRef.set(currentCoins + totalCoins);
//
//       // Log the coin transaction
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('coinTransactions')
//           .push()
//           .set({
//         'type': 'activity_completion',
//         'scenarioId': widget.scenario.id,
//         'amount': totalCoins,
//         'baseReward': baseCoins,
//         'accuracyBonus': accuracyBonus,
//         'timestamp': ServerValue.timestamp,
//       });
//
//       print('💰 Activity coins awarded: $totalCoins (Base: $baseCoins + Accuracy: $accuracyBonus)');
//     } catch (e) {
//       print('❌ Error awarding activity coins: $e');
//     }
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
//           activity!.name,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           // Progress indicator
//           Container(
//             margin: EdgeInsets.only(right: 8),
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.green.withOpacity(0.8),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white, size: 16),
//                 SizedBox(width: 4),
//                 Text(
//                   '$correctAnswersCount/$totalCardsAnswered',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Card counter
//           Container(
//             margin: EdgeInsets.only(right: 16),
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '${currentCardIndex + 1}/${activity.cards!.length}',
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
//                 itemCount: activity.cards!.length,
//                 itemBuilder: (context, index) {
//                   return _buildActivityCard(activity.cards![index], index);
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
//         widthFactor: widget.scenario.activity!.cards!.isNotEmpty
//             ? (currentCardIndex + 1) / widget.scenario.activity!.cards!.length
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
//                     // Show coin indicator for correct answers
//                     if (showResult && isCorrect) ...[
//                       SizedBox(width: 8),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.monetization_on, color: Colors.white, size: 12),
//                             SizedBox(width: 2),
//                             Text(
//                               '+2',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
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
//     bool isLastCard = index == widget.scenario.activity!.cards!.length - 1;
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
//   void _selectCardAnswer(int index, String answer, ActivityCard card) async {
//     bool isCorrect = answer == card.correct;
//
//     setState(() {
//       cardAnswers[index] = answer;
//     });
//
//     // Update Firebase with the card answer
//     await _updateCardAnswer(index, answer, isCorrect);
//
//     // Show feedback
//     Future.delayed(Duration(milliseconds: 500), () {
//       _showCardFeedback(card, isCorrect);
//     });
//   }
//
//   void _showCardFeedback(ActivityCard card, bool isCorrect) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Icon(
//               isCorrect ? Icons.check_circle : Icons.info_outline,
//               color: isCorrect ? Colors.green : Colors.orange,
//             ),
//             SizedBox(width: 8),
//             Text(isCorrect ? 'Correct!' : 'Feedback'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(card.feedback),
//             if (isCorrect) ...[
//               SizedBox(height: 12),
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.amber.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.amber),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.monetization_on, color: Colors.amber, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       '+2 coins earned!',
//                       style: TextStyle(
//                         color: Colors.amber[700],
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
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
//   void _completeActivity() async {
//     // Complete activity tracking in Firebase
//     await _completeActivityTracking();
//
//     double accuracy = totalCardsAnswered > 0
//         ? (correctAnswersCount / totalCardsAnswered) * 100
//         : 0;
//
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
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(widget.scenario.activity!.completionMessage!),
//             SizedBox(height: 16),
//             // Show performance summary
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Correct Answers:'),
//                       Text(
//                         '$correctAnswersCount/${widget.scenario.activity!.cards!.length}',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Accuracy:'),
//                       Text(
//                         '${accuracy.toStringAsFixed(1)}%',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 12),
//             // Show coins earned
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.amber.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.amber),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.monetization_on, color: Colors.amber),
//                   SizedBox(width: 8),
//                   Text(
//                     '+${5 + (correctAnswersCount * 2)} coins earned!',
//                     style: TextStyle(
//                       color: Colors.amber[700],
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
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


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// import '../models/JsonModel.dart';
//
// class EnhancedActivityScreen extends StatefulWidget {
//   final Scenario scenario;
//   final VoidCallback onActivityComplete;
//
//   const EnhancedActivityScreen({
//     super.key,
//     required this.scenario,
//     required this.onActivityComplete,
//   });
//
//   @override
//   State<EnhancedActivityScreen> createState() => _EnhancedActivityScreenState();
// }
//
// class _EnhancedActivityScreenState extends State<EnhancedActivityScreen>
//     with TickerProviderStateMixin {
//
//   // Controllers and Animation
//   PageController _cardController = PageController();
//   PageController _simulationController = PageController();
//   late AnimationController _progressAnimationController;
//   late Animation<double> _progressAnimation;
//
//   // Activity State
//   int currentIndex = 0;
//   Map<int, String> cardAnswers = {}; // For Mini Card Activities
//   Map<int, int> simulationChoices = {}; // For Interactive Simulations
//   String currentPath = ""; // Track simulation path (e.g., "A-B-A")
//
//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   // Progress tracking
//   int correctAnswersCount = 0;
//   int totalItemsAnswered = 0;
//   DateTime activityStartTime = DateTime.now();
//   bool isCompleted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _progressAnimationController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _progressAnimation = Tween<double>(begin: 0.0, end: 1.0)
//         .animate(CurvedAnimation(
//       parent: _progressAnimationController,
//       curve: Curves.easeInOut,
//     ));
//     _initializeActivityTracking();
//   }
//
//   @override
//   void dispose() {
//     _cardController.dispose();
//     _simulationController.dispose();
//     _progressAnimationController.dispose();
//     super.dispose();
//   }
//
//   bool get isSimulationActivity =>
//       widget.scenario.activity?.type == "Interactive Simulation";
//
//   int get totalItems => isSimulationActivity
//       ? widget.scenario.activity?.scenes?.length ?? 0
//       : widget.scenario.activity?.cards?.length ?? 0;
//
//   Future<void> _initializeActivityTracking() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await _database
//             .child('Progress')
//             .child(user.uid)
//             .child('activities')
//             .child('${widget.scenario.id}_activity')
//             .child('sessions')
//             .push()
//             .set({
//           'scenarioId': widget.scenario.id,
//           'activityName': widget.scenario.activity?.name,
//           'activityType': widget.scenario.activity?.type,
//           'startTime': ServerValue.timestamp,
//           'status': 'started',
//         });
//         print('📝 Activity tracking initialized for scenario ${widget.scenario.id}');
//       }
//     } catch (e) {
//       print('❌ Error initializing activity tracking: $e');
//     }
//   }
//
//   Future<void> _updateProgress() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       double completionPercentage = (currentIndex + 1) / totalItems * 100;
//       double accuracyPercentage = totalItemsAnswered > 0
//           ? (correctAnswersCount / totalItemsAnswered) * 100
//           : 0;
//
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('progress')
//           .set({
//         'scenarioId': widget.scenario.id,
//         'activityType': widget.scenario.activity?.type,
//         'totalItems': totalItems,
//         'itemsCompleted': currentIndex + 1,
//         'correctAnswers': correctAnswersCount,
//         'completionPercentage': completionPercentage,
//         'accuracyPercentage': accuracyPercentage,
//         'currentPath': currentPath, // For simulations
//         'lastUpdated': ServerValue.timestamp,
//         'isCompleted': currentIndex + 1 >= totalItems,
//       });
//
//       // Animate progress bar
//       _progressAnimationController.animateTo(completionPercentage / 100);
//     } catch (e) {
//       print('❌ Error updating progress: $e');
//     }
//   }
//
//   Future<void> _awardCoins(int amount, String reason) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       DatabaseReference coinRef = _database.child('Progress').child(user.uid).child('coins');
//       DataSnapshot coinSnapshot = await coinRef.get();
//       int currentCoins = coinSnapshot.exists ? (coinSnapshot.value as int? ?? 0) : 0;
//
//       await coinRef.set(currentCoins + amount);
//
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('coinTransactions')
//           .push()
//           .set({
//         'type': reason,
//         'scenarioId': widget.scenario.id,
//         'amount': amount,
//         'timestamp': ServerValue.timestamp,
//       });
//
//       print('💰 Coins awarded: $amount for $reason');
//     } catch (e) {
//       print('❌ Error awarding coins: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final activity = widget.scenario.activity;
//     if (activity == null) {
//       return Scaffold(
//         body: Center(child: Text('No activity available')),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Color(0xFFE91E63),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFFE91E63),
//               Color(0xFFAD1457),
//               Color(0xFF880E4F),
//               Color(0xFF4A148C),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(activity),
//               _buildProgressSection(),
//               Expanded(
//                 child: isSimulationActivity
//                     ? _buildSimulationView(activity)
//                     : _buildCardActivityView(activity),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(Activity activity) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   activity.name,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (activity.description != null) ...[
//                   SizedBox(height: 4),
//                   Text(
//                     activity.description!,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: 14,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           // Activity type indicator
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: isSimulationActivity
//                   ? Colors.purple.withOpacity(0.8)
//                   : Colors.orange.withOpacity(0.8),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   isSimulationActivity ? Icons.psychology : Icons.quiz,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//                 SizedBox(width: 4),
//                 Text(
//                   isSimulationActivity ? 'Simulation' : 'Cards',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressSection() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         children: [
//           // Progress bar
//           Container(
//             height: 8,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: AnimatedBuilder(
//               animation: _progressAnimation,
//               builder: (context, child) {
//                 return FractionallySizedBox(
//                   alignment: Alignment.centerLeft,
//                   widthFactor: totalItems > 0
//                       ? (currentIndex + 1) / totalItems
//                       : 0.0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.white, Colors.amber],
//                       ),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 12),
//           // Stats row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildStatChip(
//                 icon: Icons.format_list_numbered,
//                 label: '${currentIndex + 1}/$totalItems',
//                 color: Colors.blue,
//               ),
//               _buildStatChip(
//                 icon: Icons.check_circle,
//                 label: '$correctAnswersCount correct',
//                 color: Colors.green,
//               ),
//               if (isSimulationActivity && currentPath.isNotEmpty)
//                 _buildStatChip(
//                   icon: Icons.route,
//                   label: 'Path: $currentPath',
//                   color: Colors.purple,
//                 ),
//               _buildStatChip(
//                 icon: Icons.monetization_on,
//                 label: '${_calculateCurrentCoins()} coins',
//                 color: Colors.amber,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.white, size: 14),
//           SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCardActivityView(Activity activity) {
//     return PageView.builder(
//       controller: _cardController,
//       onPageChanged: (index) {
//         setState(() {
//           currentIndex = index;
//         });
//         _updateProgress();
//       },
//       itemCount: activity.cards?.length ?? 0,
//       itemBuilder: (context, index) {
//         final card = activity.cards![index];
//         return _buildCardPage(card, index);
//       },
//     );
//   }
//
//   Widget _buildCardPage(ActivityCard card, int index) {
//     bool hasAnswer = cardAnswers.containsKey(index);
//
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
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFE91E63).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.psychology,
//                         color: Color(0xFFE91E63),
//                         size: 24,
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'Consider this scenario:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   card.statement,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.black87,
//                     height: 1.6,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Color(0xFFE91E63).withOpacity(0.05),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: Color(0xFFE91E63).withOpacity(0.2),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.help_outline,
//                         color: Color(0xFFE91E63),
//                         size: 20,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         'Is this Fair or Unfair?',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Color(0xFFE91E63),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: 24),
//
//           // Answer options
//           _buildCardAnswerOptions(card, index),
//
//           SizedBox(height: 24),
//
//           // Navigation
//           _buildCardNavigation(index),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCardAnswerOptions(ActivityCard card, int index) {
//     List<String> possibleAnswers = ['Fair', 'Unfair'];
//     if (card.correct.contains('Biased')) {
//       possibleAnswers = ['Fair', 'Biased Outcome', 'Valid Pattern'];
//     }
//
//     bool hasAnswer = cardAnswers.containsKey(index);
//
//     return Column(
//       children: possibleAnswers.map((answer) {
//         bool isSelected = cardAnswers[index] == answer;
//         bool isCorrect = answer == card.correct;
//
//         return Container(
//           margin: EdgeInsets.only(bottom: 16),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: hasAnswer ? null : () => _selectCardAnswer(index, answer, card),
//               borderRadius: BorderRadius.circular(16),
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: hasAnswer
//                       ? (isCorrect
//                       ? Colors.green.withOpacity(0.9)
//                       : isSelected
//                       ? Colors.red.withOpacity(0.9)
//                       : Colors.white)
//                       : (isSelected ? Colors.white : Colors.white.withOpacity(0.9)),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: hasAnswer
//                         ? (isCorrect ? Colors.green : isSelected ? Colors.red : Colors.grey[300]!)
//                         : (isSelected ? Color(0xFFE91E63) : Colors.grey[300]!),
//                     width: 2,
//                   ),
//                   boxShadow: isSelected && !hasAnswer
//                       ? [
//                     BoxShadow(
//                       color: Color(0xFFE91E63).withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: Offset(0, 4),
//                     ),
//                   ]
//                       : null,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 24,
//                       height: 24,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: hasAnswer
//                             ? (isCorrect ? Colors.white : isSelected ? Colors.white : Colors.grey[300])
//                             : (isSelected ? Color(0xFFE91E63) : Colors.transparent),
//                         border: Border.all(
//                           color: hasAnswer
//                               ? Colors.transparent
//                               : (isSelected ? Color(0xFFE91E63) : Colors.grey[400]!),
//                           width: 2,
//                         ),
//                       ),
//                       child: hasAnswer && (isCorrect || isSelected)
//                           ? Icon(
//                         isCorrect ? Icons.check : Icons.close,
//                         color: isCorrect ? Colors.green : Colors.red,
//                         size: 16,
//                       )
//                           : (isSelected
//                           ? Icon(Icons.circle, color: Colors.white, size: 12)
//                           : null),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Text(
//                         answer,
//                         style: TextStyle(
//                           color: hasAnswer
//                               ? (isCorrect || isSelected ? Colors.white : Colors.black87)
//                               : (isSelected ? Color(0xFFE91E63) : Colors.black87),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     if (hasAnswer && isCorrect) ...[
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.monetization_on, color: Colors.white, size: 14),
//                             SizedBox(width: 4),
//                             Text(
//                               '+2',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
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
//   Widget _buildSimulationView(Activity activity) {
//     return PageView.builder(
//       controller: _simulationController,
//       onPageChanged: (index) {
//         setState(() {
//           currentIndex = index;
//         });
//         _updateProgress();
//       },
//       itemCount: activity.scenes?.length ?? 0,
//       itemBuilder: (context, index) {
//         final scene = activity.scenes![index];
//         return _buildSimulationScene(scene, index);
//       },
//     );
//   }
//
//   Widget _buildSimulationScene(Scene scene, int index) {
//     bool hasChoice = simulationChoices.containsKey(index);
//
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Scene header
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.purple[400]!, Colors.purple[600]!],
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               children: [
//                 Icon(Icons.psychology, color: Colors.white, size: 32),
//                 SizedBox(height: 8),
//                 Text(
//                   'Scene ${scene.sceneNumber}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: 24),
//
//           // Scene content
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Situation:',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   scene.description,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.black87,
//                     height: 1.6,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'What would you do?',
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
//           // Choice options
//           _buildSimulationChoices(scene, index),
//
//           SizedBox(height: 24),
//
//           // Navigation
//           _buildSimulationNavigation(index),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSimulationChoices(Scene scene, int sceneIndex) {
//     bool hasChoice = simulationChoices.containsKey(sceneIndex);
//
//     return Column(
//       children: scene.options!.asMap().entries.map((entry) {
//         int optionIndex = entry.key;
//         String option = entry.value;
//         bool isSelected = simulationChoices[sceneIndex] == optionIndex;
//
//         return Container(
//           margin: EdgeInsets.only(bottom: 16),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: hasChoice ? null : () => _selectSimulationChoice(sceneIndex, optionIndex, option),
//               borderRadius: BorderRadius.circular(16),
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.purple[500] : Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: isSelected ? Colors.purple[500]! : Colors.grey[300]!,
//                     width: 2,
//                   ),
//                   boxShadow: isSelected
//                       ? [
//                     BoxShadow(
//                       color: Colors.purple.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: Offset(0, 4),
//                     ),
//                   ]
//                       : null,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 24,
//                       height: 24,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: isSelected ? Colors.white : Colors.transparent,
//                         border: Border.all(
//                           color: isSelected ? Colors.transparent : Colors.grey[400]!,
//                           width: 2,
//                         ),
//                       ),
//                       child: isSelected
//                           ? Icon(Icons.check, color: Colors.purple[500], size: 16)
//                           : Center(
//                         child: Text(
//                           String.fromCharCode(65 + optionIndex), // A, B, C...
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Text(
//                         option,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : Colors.black87,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     if (isSelected) ...[
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.monetization_on, color: Colors.white, size: 14),
//                             SizedBox(width: 4),
//                             Text(
//                               '+3',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
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
//   Widget _buildCardNavigation(int index) {
//     bool hasAnswer = cardAnswers.containsKey(index);
//     bool isLastCard = index == (widget.scenario.activity!.cards!.length - 1);
//
//     return Row(
//       children: [
//         if (index > 0) ...[
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
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.arrow_back, size: 18),
//                   SizedBox(width: 8),
//                   Text('Previous'),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//         ],
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
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   isLastCard ? 'Complete Activity' : 'Next',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (!isLastCard) ...[
//                   SizedBox(width: 8),
//                   Icon(Icons.arrow_forward, size: 18),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSimulationNavigation(int index) {
//     bool hasChoice = simulationChoices.containsKey(index);
//     bool isLastScene = index == (widget.scenario.activity!.scenes!.length - 1);
//
//     return Row(
//       children: [
//         if (index > 0) ...[
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () => _simulationController.previousPage(
//                 duration: Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.arrow_back, size: 18),
//                   SizedBox(width: 8),
//                   Text('Previous'),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: 12),
//         ],
//         Expanded(
//           flex: 2,
//           child: ElevatedButton(
//             onPressed: hasChoice
//                 ? () => isLastScene ? _completeActivity() : _simulationController.nextPage(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//             )
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: hasChoice ? Colors.white : Colors.white.withOpacity(0.3),
//               foregroundColor: hasChoice ? Colors.purple[500] : Colors.white.withOpacity(0.5),
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   isLastScene ? 'Complete Simulation' : 'Next Scene',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (!isLastScene) ...[
//                   SizedBox(width: 8),
//                   Icon(Icons.arrow_forward, size: 18),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _selectCardAnswer(int index, String answer, ActivityCard card) async {
//     bool isCorrect = answer == card.correct;
//
//     setState(() {
//       cardAnswers[index] = answer;
//       totalItemsAnswered++;
//       if (isCorrect) {
//         correctAnswersCount++;
//       }
//     });
//
//     // Update Firebase tracking
//     await _updateCardProgress(index, answer, isCorrect);
//     await _updateProgress();
//
//     // Award coins for correct answer
//     if (isCorrect) {
//       await _awardCoins(2, 'correct_card_answer');
//     }
//
//     // Show feedback after a brief delay
//     Future.delayed(Duration(milliseconds: 500), () {
//       _showCardFeedback(card, isCorrect);
//     });
//   }
//
//   void _selectSimulationChoice(int sceneIndex, int optionIndex, String option) async {
//     setState(() {
//       simulationChoices[sceneIndex] = optionIndex;
//       // Update path (A=0, B=1, C=2, etc.)
//       String choiceLetter = String.fromCharCode(65 + optionIndex);
//       if (currentPath.isEmpty) {
//         currentPath = choiceLetter;
//       } else {
//         currentPath += '-$choiceLetter';
//       }
//       totalItemsAnswered++;
//       correctAnswersCount++; // All simulation choices are considered "correct" participation
//     });
//
//     // Update Firebase tracking
//     await _updateSimulationProgress(sceneIndex, optionIndex, option);
//     await _updateProgress();
//
//     // Award coins for making a choice
//     await _awardCoins(3, 'simulation_choice');
//
//     // Show brief feedback
//     _showSimulationFeedback(option);
//   }
//
//   Future<void> _updateCardProgress(int cardIndex, String answer, bool isCorrect) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('cards')
//           .child(cardIndex.toString())
//           .set({
//         'cardIndex': cardIndex,
//         'userAnswer': answer,
//         'isCorrect': isCorrect,
//         'timestamp': ServerValue.timestamp,
//       });
//     } catch (e) {
//       print('❌ Error updating card progress: $e');
//     }
//   }
//
//   Future<void> _updateSimulationProgress(int sceneIndex, int optionIndex, String option) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('scenes')
//           .child(sceneIndex.toString())
//           .set({
//         'sceneIndex': sceneIndex,
//         'choiceIndex': optionIndex,
//         'choiceText': option,
//         'choiceLetter': String.fromCharCode(65 + optionIndex),
//         'timestamp': ServerValue.timestamp,
//       });
//
//       // Update the path in Firebase
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('simulationPath')
//           .set(currentPath);
//     } catch (e) {
//       print('❌ Error updating simulation progress: $e');
//     }
//   }
//
//   void _showCardFeedback(ActivityCard card, bool isCorrect) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 isCorrect ? Icons.check_circle : Icons.info_outline,
//                 color: isCorrect ? Colors.green : Colors.orange,
//                 size: 24,
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 isCorrect ? 'Excellent!' : 'Good Thinking!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               card.feedback,
//               style: TextStyle(
//                 fontSize: 16,
//                 height: 1.5,
//               ),
//             ),
//             if (isCorrect) ...[
//               SizedBox(height: 16),
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.amber[300]!, Colors.amber[500]!],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.monetization_on, color: Colors.white, size: 20),
//                     SizedBox(width: 8),
//                     Text(
//                       '+2 coins earned!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               backgroundColor: Color(0xFFE91E63),
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text('Continue'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSimulationFeedback(String choice) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.white),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 'Choice recorded: $choice',
//                 style: TextStyle(fontWeight: FontWeight.w500),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.amber,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 '+3 coins',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.purple[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   int _calculateCurrentCoins() {
//     if (isSimulationActivity) {
//       return (simulationChoices.length * 3) + 5; // 3 per choice + completion bonus
//     } else {
//       return (correctAnswersCount * 2) + 5; // 2 per correct answer + completion bonus
//     }
//   }
//
//   void _completeActivity() async {
//     if (isCompleted) return;
//
//     setState(() {
//       isCompleted = true;
//     });
//
//     // Complete Firebase tracking
//     await _completeActivityTracking();
//
//     // Determine ending for simulations
//     String ending = '';
//     if (isSimulationActivity) {
//       final activity = widget.scenario.activity!;
//       if (currentPath == activity.idealPath) {
//         ending = activity.idealEnding ?? 'Great choices! You followed the ideal path.';
//       } else {
//         ending = activity.badEnding ?? 'Your choices led to a different outcome. Consider the alternatives.';
//       }
//     }
//
//     double accuracy = totalItemsAnswered > 0
//         ? (correctAnswersCount / totalItemsAnswered) * 100
//         : 0;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         title: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.green[400]!, Colors.green[600]!],
//                 ),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.celebration,
//                 color: Colors.white,
//                 size: 32,
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               'Activity Complete!',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Completion message
//               if (widget.scenario.activity!.completionMessage != null) ...[
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.blue[200]!),
//                   ),
//                   child: Text(
//                     widget.scenario.activity!.completionMessage!,
//                     style: TextStyle(
//                       fontSize: 16,
//                       height: 1.5,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//               ],
//
//               // Simulation ending
//               if (isSimulationActivity && ending.isNotEmpty) ...[
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: currentPath == widget.scenario.activity!.idealPath
//                         ? Colors.green[50]
//                         : Colors.orange[50],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: currentPath == widget.scenario.activity!.idealPath
//                           ? Colors.green[200]!
//                           : Colors.orange[200]!,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             currentPath == widget.scenario.activity!.idealPath
//                                 ? Icons.star
//                                 : Icons.lightbulb,
//                             color: currentPath == widget.scenario.activity!.idealPath
//                                 ? Colors.green[600]
//                                 : Colors.orange[600],
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               currentPath == widget.scenario.activity!.idealPath
//                                   ? 'Ideal Path Achieved!'
//                                   : 'Alternative Path',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: currentPath == widget.scenario.activity!.idealPath
//                                     ? Colors.green[600]
//                                     : Colors.orange[600],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         ending,
//                         style: TextStyle(fontSize: 14, height: 1.4),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 16),
//               ],
//
//               // Performance summary
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Performance Summary',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     if (!isSimulationActivity) ...[
//                       _buildSummaryRow('Correct Answers', '$correctAnswersCount/$totalItems'),
//                       _buildSummaryRow('Accuracy', '${accuracy.toStringAsFixed(1)}%'),
//                     ] else ...[
//                       _buildSummaryRow('Scenes Completed', '$totalItems/$totalItems'),
//                       _buildSummaryRow('Path Taken', currentPath),
//                       _buildSummaryRow('Ideal Path', widget.scenario.activity!.idealPath ?? 'N/A'),
//                     ],
//                     _buildSummaryRow('Total Coins Earned', '${_calculateCurrentCoins()}'),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Coins earned highlight
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.amber[400]!, Colors.amber[600]!],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.monetization_on, color: Colors.white, size: 24),
//                     SizedBox(width: 8),
//                     Text(
//                       '+${_calculateCurrentCoins()} Total Coins!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           Container(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close dialog
//                 widget.onActivityComplete(); // Call completion callback
//                 Navigator.pop(context); // Return to previous screen
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFE91E63),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 'Continue Learning',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSummaryRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(color: Colors.grey[600]),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _completeActivityTracking() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       DateTime endTime = DateTime.now();
//       int durationSeconds = endTime.difference(activityStartTime).inSeconds;
//       double finalAccuracy = totalItemsAnswered > 0
//           ? (correctAnswersCount / totalItemsAnswered) * 100
//           : 0;
//
//       int totalCoins = _calculateCurrentCoins();
//
//       // Update completion data
//       await _database
//           .child('Progress')
//           .child(user.uid)
//           .child('activities')
//           .child('${widget.scenario.id}_activity')
//           .child('completion')
//           .set({
//         'completedAt': ServerValue.timestamp,
//         'durationSeconds': durationSeconds,
//         'finalAccuracy': finalAccuracy,
//         'totalCorrect': correctAnswersCount,
//         'totalItems': totalItems,
//         'activityType': widget.scenario.activity?.type,
//         'coinsEarned': totalCoins,
//         'status': 'completed',
//         if (isSimulationActivity) ...{
//           'simulationPath': currentPath,
//           'idealPath': widget.scenario.activity?.idealPath,
//           'achievedIdealPath': currentPath == widget.scenario.activity?.idealPath,
//         },
//       });
//
//       // Award final completion bonus coins
//       await _awardCoins(5, 'activity_completion_bonus');
//
//       // Update user's overall stats
//       await _updateUserActivityStats();
//
//       print('🏆 Activity completed - Type: ${widget.scenario.activity?.type}, Accuracy: ${finalAccuracy.toStringAsFixed(1)}%');
//     } catch (e) {
//       print('❌ Error completing activity tracking: $e');
//     }
//   }
//
//   Future<void> _updateUserActivityStats() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       DatabaseReference userStatsRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child('stats');
//
//       DataSnapshot snapshot = await userStatsRef.get();
//       Map<String, dynamic> stats = {};
//       if (snapshot.exists) {
//         stats = Map<String, dynamic>.from(snapshot.value as Map);
//       }
//
//       int currentActivitiesCompleted = stats['activitiesCompleted'] ?? 0;
//       int currentCardActivities = stats['cardActivitiesCompleted'] ?? 0;
//       int currentSimulationActivities = stats['simulationActivitiesCompleted'] ?? 0;
//       int currentTotalItems = stats['totalActivityItems'] ?? 0;
//       int currentCorrectAnswers = stats['correctActivityAnswers'] ?? 0;
//
//       await userStatsRef.update({
//         'activitiesCompleted': currentActivitiesCompleted + 1,
//         if (isSimulationActivity)
//           'simulationActivitiesCompleted': currentSimulationActivities + 1
//         else
//           'cardActivitiesCompleted': currentCardActivities + 1,
//         'totalActivityItems': currentTotalItems + totalItems,
//         'correctActivityAnswers': currentCorrectAnswers + correctAnswersCount,
//         'lastActivityCompleted': ServerValue.timestamp,
//         'lastActivityType': widget.scenario.activity?.type,
//       });
//     } catch (e) {
//       print('❌ Error updating user activity stats: $e');
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/JsonModel.dart';

class EnhancedActivityScreen extends StatefulWidget {
  final Scenario scenario;
  final VoidCallback onActivityComplete;
  final bool isFromScenario; // Track if called from scenario screen

  const EnhancedActivityScreen({
    super.key,
    required this.scenario,
    required this.onActivityComplete,
    this.isFromScenario = false,
  });

  @override
  State<EnhancedActivityScreen> createState() => _EnhancedActivityScreenState();
}

class _EnhancedActivityScreenState extends State<EnhancedActivityScreen>
    with TickerProviderStateMixin {

  // Controllers and Animation
  PageController _cardController = PageController();
  PageController _simulationController = PageController();
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  // Activity State
  int currentIndex = 0;
  Map<int, String> cardAnswers = {}; // For Mini Card Activities
  Map<int, int> simulationChoices = {}; // For Interactive Simulations
  String currentPath = ""; // Track simulation path (e.g., "A-B-A")

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Progress tracking
  int correctAnswersCount = 0;
  int totalItemsAnswered = 0;
  DateTime activityStartTime = DateTime.now();
  bool isCompleted = false;
  bool hasPassedActivity = false; // Track if user passed the activity

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    _initializeActivityTracking();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _simulationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  bool get isSimulationActivity =>
      widget.scenario.activity?.type == "Interactive Simulation";

  int get totalItems => isSimulationActivity
      ? widget.scenario.activity?.scenes?.length ?? 0
      : widget.scenario.activity?.cards?.length ?? 0;

  // Calculate if user passed the activity (70% accuracy for cards, ideal path for simulations)
  bool get didPassActivity {
    if (isSimulationActivity) {
      return currentPath == widget.scenario.activity?.idealPath;
    } else {
      double accuracy = totalItemsAnswered > 0
          ? (correctAnswersCount / totalItemsAnswered) * 100
          : 0;
      return accuracy >= 70.0; // 70% passing grade
    }
  }

  Future<void> _initializeActivityTracking() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if activity was already completed
        DataSnapshot completionSnapshot = await _database
            .child('Progress')
            .child(user.uid)
            .child('activities')
            .child('${widget.scenario.id}_activity')
            .child('completion')
            .get();

        if (completionSnapshot.exists) {
          Map<String, dynamic> completionData =
          Map<String, dynamic>.from(completionSnapshot.value as Map);
          hasPassedActivity = completionData['passed'] ?? false;
        }

        await _database
            .child('Progress')
            .child(user.uid)
            .child('activities')
            .child('${widget.scenario.id}_activity')
            .child('sessions')
            .push()
            .set({
          'scenarioId': widget.scenario.id,
          'activityName': widget.scenario.activity?.name,
          'activityType': widget.scenario.activity?.type,
          'startTime': ServerValue.timestamp,
          'status': 'started',
          'isRetry': hasPassedActivity, // Track if this is a retry
        });
        print('📝 Activity tracking initialized for scenario ${widget.scenario.id}');
      }
    } catch (e) {
      print('❌ Error initializing activity tracking: $e');
    }
  }

  Future<void> _updateProgress() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      double completionPercentage = (currentIndex + 1) / totalItems * 100;
      double accuracyPercentage = totalItemsAnswered > 0
          ? (correctAnswersCount / totalItemsAnswered) * 100
          : 0;

      await _database
          .child('Progress')
          .child(user.uid)
          .child('activities')
          .child('${widget.scenario.id}_activity')
          .child('progress')
          .set({
        'scenarioId': widget.scenario.id,
        'activityType': widget.scenario.activity?.type,
        'totalItems': totalItems,
        'itemsCompleted': currentIndex + 1,
        'correctAnswers': correctAnswersCount,
        'completionPercentage': completionPercentage,
        'accuracyPercentage': accuracyPercentage,
        'currentPath': currentPath, // For simulations
        'lastUpdated': ServerValue.timestamp,
        'isCompleted': currentIndex + 1 >= totalItems,
        'currentlyPassing': didPassActivity,
      });

      // Animate progress bar
      _progressAnimationController.animateTo(completionPercentage / 100);
    } catch (e) {
      print('❌ Error updating progress: $e');
    }
  }

  Future<void> _awardCoins(int amount, String reason) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DatabaseReference coinRef = _database.child('Progress').child(user.uid).child('coins');
      DataSnapshot coinSnapshot = await coinRef.get();
      int currentCoins = coinSnapshot.exists ? (coinSnapshot.value as int? ?? 0) : 0;

      await coinRef.set(currentCoins + amount);

      await _database
          .child('Progress')
          .child(user.uid)
          .child('coinTransactions')
          .push()
          .set({
        'type': reason,
        'scenarioId': widget.scenario.id,
        'amount': amount,
        'timestamp': ServerValue.timestamp,
      });

      print('💰 Coins awarded: $amount for $reason');
    } catch (e) {
      print('❌ Error awarding coins: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.scenario.activity;
    if (activity == null) {
      return Scaffold(
        body: Center(child: Text('No activity available')),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFE91E63),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE91E63),
              Color(0xFFAD1457),
              Color(0xFF880E4F),
              Color(0xFF4A148C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(activity),
              _buildProgressSection(),
              Expanded(
                child: isSimulationActivity
                    ? _buildSimulationView(activity)
                    : _buildCardActivityView(activity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Activity activity) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => _handleBackNavigation(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (activity.description != null) ...[
                  SizedBox(height: 4),
                  Text(
                    activity.description!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Activity type indicator with retry badge
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSimulationActivity
                      ? Colors.purple.withOpacity(0.8)
                      : Colors.orange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSimulationActivity ? Icons.psychology : Icons.quiz,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      isSimulationActivity ? 'Simulation' : 'Cards',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasPassedActivity) ...[
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'RETRY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Progress bar with passing indicator
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: totalItems > 0
                      ? (currentIndex + 1) / totalItems
                      : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: didPassActivity
                            ? [Colors.green, Colors.lightGreen]
                            : [Colors.white, Colors.amber],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),
          // Stats row with passing indicator
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatChip(
                icon: Icons.format_list_numbered,
                label: '${currentIndex + 1}/$totalItems',
                color: Colors.blue,
              ),
              _buildStatChip(
                icon: Icons.check_circle,
                label: '$correctAnswersCount correct',
                color: Colors.green,
              ),
              if (isSimulationActivity && currentPath.isNotEmpty)
                _buildStatChip(
                  icon: Icons.route,
                  label: 'Path: $currentPath',
                  color: Colors.purple,
                ),
              _buildStatChip(
                icon: Icons.monetization_on,
                label: '${_calculateCurrentCoins()} coins',
                color: Colors.amber,
              ),
              // Passing status
              if (totalItemsAnswered > 0)
                _buildStatChip(
                  icon: didPassActivity ? Icons.thumb_up : Icons.warning,
                  label: didPassActivity ? 'Passing' : 'Need 70%',
                  color: didPassActivity ? Colors.green : Colors.orange,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardActivityView(Activity activity) {
    return PageView.builder(
      controller: _cardController,
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
        _updateProgress();
      },
      itemCount: activity.cards?.length ?? 0,
      itemBuilder: (context, index) {
        final card = activity.cards![index];
        return _buildCardPage(card, index);
      },
    );
  }

  Widget _buildCardPage(ActivityCard card, int index) {
    bool hasAnswer = cardAnswers.containsKey(index);

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
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE91E63).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.psychology,
                        color: Color(0xFFE91E63),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Consider this scenario:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  card.statement,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFE91E63).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFE91E63).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Color(0xFFE91E63),
                        size: 20,
                      ),
                      SizedBox(width: 8),
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
              ],
            ),
          ),

          SizedBox(height: 24),

          // Answer options
          _buildCardAnswerOptions(card, index),

          SizedBox(height: 24),

          // Navigation
          _buildCardNavigation(index),
        ],
      ),
    );
  }

  Widget _buildCardAnswerOptions(ActivityCard card, int index) {
    List<String> possibleAnswers = ['Fair', 'Unfair'];
    if (card.correct.contains('Biased')) {
      possibleAnswers = ['Fair', 'Biased Outcome', 'Valid Pattern'];
    }

    bool hasAnswer = cardAnswers.containsKey(index);

    return Column(
      children: possibleAnswers.map((answer) {
        bool isSelected = cardAnswers[index] == answer;
        bool isCorrect = answer == card.correct;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasAnswer ? null : () => _selectCardAnswer(index, answer, card),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: hasAnswer
                      ? (isCorrect
                      ? Colors.green.withOpacity(0.9)
                      : isSelected
                      ? Colors.red.withOpacity(0.9)
                      : Colors.white)
                      : (isSelected ? Colors.white : Colors.white.withOpacity(0.9)),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hasAnswer
                        ? (isCorrect ? Colors.green : isSelected ? Colors.red : Colors.grey[300]!)
                        : (isSelected ? Color(0xFFE91E63) : Colors.grey[300]!),
                    width: 2,
                  ),
                  boxShadow: isSelected && !hasAnswer
                      ? [
                    BoxShadow(
                      color: Color(0xFFE91E63).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasAnswer
                            ? (isCorrect ? Colors.white : isSelected ? Colors.white : Colors.grey[300])
                            : (isSelected ? Color(0xFFE91E63) : Colors.transparent),
                        border: Border.all(
                          color: hasAnswer
                              ? Colors.transparent
                              : (isSelected ? Color(0xFFE91E63) : Colors.grey[400]!),
                          width: 2,
                        ),
                      ),
                      child: hasAnswer && (isCorrect || isSelected)
                          ? Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 16,
                      )
                          : (isSelected
                          ? Icon(Icons.circle, color: Colors.white, size: 12)
                          : null),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        answer,
                        style: TextStyle(
                          color: hasAnswer
                              ? (isCorrect || isSelected ? Colors.white : Colors.black87)
                              : (isSelected ? Color(0xFFE91E63) : Colors.black87),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hasAnswer && isCorrect) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monetization_on, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '+2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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

  Widget _buildSimulationView(Activity activity) {
    return PageView.builder(
      controller: _simulationController,
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
        _updateProgress();
      },
      itemCount: activity.scenes?.length ?? 0,
      itemBuilder: (context, index) {
        final scene = activity.scenes![index];
        return _buildSimulationScene(scene, index);
      },
    );
  }

  Widget _buildSimulationScene(Scene scene, int index) {
    bool hasChoice = simulationChoices.containsKey(index);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Scene header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[400]!, Colors.purple[600]!],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(Icons.psychology, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  'Scene ${scene.sceneNumber}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Scene content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Situation:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  scene.description,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'What would you do?',
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

          // Choice options
          _buildSimulationChoices(scene, index),

          SizedBox(height: 24),

          // Navigation
          _buildSimulationNavigation(index),
        ],
      ),
    );
  }

  Widget _buildSimulationChoices(Scene scene, int sceneIndex) {
    bool hasChoice = simulationChoices.containsKey(sceneIndex);

    return Column(
      children: scene.options!.asMap().entries.map((entry) {
        int optionIndex = entry.key;
        String option = entry.value;
        bool isSelected = simulationChoices[sceneIndex] == optionIndex;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: hasChoice ? null : () => _selectSimulationChoice(sceneIndex, optionIndex, option),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple[500] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.purple[500]! : Colors.grey[300]!,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.white : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(Icons.check, color: Colors.purple[500], size: 16)
                          : Center(
                        child: Text(
                          String.fromCharCode(65 + optionIndex), // A, B, C...
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isSelected) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monetization_on, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '+3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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

  Widget _buildCardNavigation(int index) {
    bool hasAnswer = cardAnswers.containsKey(index);
    bool isLastCard = index == (widget.scenario.activity!.cards!.length - 1);

    return Row(
      children: [
        if (index > 0) ...[
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
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  SizedBox(width: 8),
                  Text('Previous'),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
        ],
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
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastCard ? 'Complete Activity' : 'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isLastCard) ...[
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimulationNavigation(int index) {
    bool hasChoice = simulationChoices.containsKey(index);
    bool isLastScene = index == (widget.scenario.activity!.scenes!.length - 1);

    return Row(
      children: [
        if (index > 0) ...[
          Expanded(
            child: ElevatedButton(
              onPressed: () => _simulationController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  SizedBox(width: 8),
                  Text('Previous'),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: hasChoice
                ? () => isLastScene ? _completeActivity() : _simulationController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasChoice ? Colors.white : Colors.white.withOpacity(0.3),
              foregroundColor: hasChoice ? Colors.purple[500] : Colors.white.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastScene ? 'Complete Simulation' : 'Next Scene',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isLastScene) ...[
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ],
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
      totalItemsAnswered++;
      if (isCorrect) {
        correctAnswersCount++;
      }
    });

    // Update Firebase tracking
    await _updateCardProgress(index, answer, isCorrect);
    await _updateProgress();

    // Award coins for correct answer
    if (isCorrect) {
      await _awardCoins(2, 'correct_card_answer');
    }

    // Show feedback after a brief delay
    Future.delayed(Duration(milliseconds: 500), () {
      _showCardFeedback(card, isCorrect);
    });
  }

  void _selectSimulationChoice(int sceneIndex, int optionIndex, String option) async {
    setState(() {
      simulationChoices[sceneIndex] = optionIndex;
      // Update path (A=0, B=1, C=2, etc.)
      String choiceLetter = String.fromCharCode(65 + optionIndex);
      if (currentPath.isEmpty) {
        currentPath = choiceLetter;
      } else {
        currentPath += '-$choiceLetter';
      }
      totalItemsAnswered++;
      correctAnswersCount++; // All simulation choices are considered "correct" participation
    });

    // Update Firebase tracking
    await _updateSimulationProgress(sceneIndex, optionIndex, option);
    await _updateProgress();

    // Award coins for making a choice
    await _awardCoins(3, 'simulation_choice');

    // Show brief feedback
    _showSimulationFeedback(option);
  }

  Future<void> _updateCardProgress(int cardIndex, String answer, bool isCorrect) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

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
      });
    } catch (e) {
      print('❌ Error updating card progress: $e');
    }
  }

  Future<void> _updateSimulationProgress(int sceneIndex, int optionIndex, String option) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      await _database
          .child('Progress')
          .child(user.uid)
          .child('activities')
          .child('${widget.scenario.id}_activity')
          .child('scenes')
          .child(sceneIndex.toString())
          .set({
        'sceneIndex': sceneIndex,
        'choiceIndex': optionIndex,
        'choiceText': option,
        'choiceLetter': String.fromCharCode(65 + optionIndex),
        'timestamp': ServerValue.timestamp,
      });

      // Update the path in Firebase
      await _database
          .child('Progress')
          .child(user.uid)
          .child('activities')
          .child('${widget.scenario.id}_activity')
          .child('simulationPath')
          .set(currentPath);
    } catch (e) {
      print('❌ Error updating simulation progress: $e');
    }
  }

  void _showCardFeedback(ActivityCard card, bool isCorrect) {
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
                color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.feedback,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            if (isCorrect) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[300]!, Colors.amber[500]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '+2 coins earned!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  void _showSimulationFeedback(String choice) {
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+3 coins',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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

  int _calculateCurrentCoins() {
    if (isSimulationActivity) {
      return (simulationChoices.length * 3) + 5; // 3 per choice + completion bonus
    } else {
      return (correctAnswersCount * 2) + 5; // 2 per correct answer + completion bonus
    }
  }

  void _handleBackNavigation() {
    // Show confirmation dialog if activity is not completed
    if (!isCompleted && (cardAnswers.isNotEmpty || simulationChoices.isNotEmpty)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Leave Activity?'),
            ],
          ),
          content: Text(
            'Your progress will be saved, but you\'ll need to complete the activity to proceed to the next scenario.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to previous screen
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              child: Text('Leave'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _completeActivity() async {
    if (isCompleted) return;

    setState(() {
      isCompleted = true;
    });

    // Complete Firebase tracking
    await _completeActivityTracking();

    // Determine ending for simulations
    String ending = '';
    if (isSimulationActivity) {
      final activity = widget.scenario.activity!;
      if (currentPath == activity.idealPath) {
        ending = activity.idealEnding ?? 'Great choices! You followed the ideal path.';
      } else {
        ending = activity.badEnding ?? 'Your choices led to a different outcome. Consider the alternatives.';
      }
    }

    double accuracy = totalItemsAnswered > 0
        ? (correctAnswersCount / totalItemsAnswered) * 100
        : 0;

    bool passed = didPassActivity;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: passed
                      ? [Colors.green[400]!, Colors.green[600]!]
                      : [Colors.orange[400]!, Colors.orange[600]!],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                passed ? Icons.celebration : Icons.refresh,
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(height: 12),
            Text(
              passed ? 'Activity Complete!' : 'Activity Finished',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pass/Retry message
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: passed ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: passed ? Colors.green[200]! : Colors.orange[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      passed ? Icons.check_circle : Icons.replay,
                      color: passed ? Colors.green[600] : Colors.orange[600],
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      passed
                          ? 'You passed! You can now proceed to the next scenario.'
                          : 'You need 70% accuracy to proceed. Try the activity again!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: passed ? Colors.green[700] : Colors.orange[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Completion message
              if (widget.scenario.activity!.completionMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    widget.scenario.activity!.completionMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Simulation ending
              if (isSimulationActivity && ending.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: currentPath == widget.scenario.activity!.idealPath
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: currentPath == widget.scenario.activity!.idealPath
                          ? Colors.green[200]!
                          : Colors.orange[200]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            currentPath == widget.scenario.activity!.idealPath
                                ? Icons.star
                                : Icons.lightbulb,
                            color: currentPath == widget.scenario.activity!.idealPath
                                ? Colors.green[600]
                                : Colors.orange[600],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              currentPath == widget.scenario.activity!.idealPath
                                  ? 'Ideal Path Achieved!'
                                  : 'Alternative Path',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: currentPath == widget.scenario.activity!.idealPath
                                    ? Colors.green[600]
                                    : Colors.orange[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        ending,
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Performance summary
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Performance Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    if (!isSimulationActivity) ...[
                      _buildSummaryRow('Correct Answers', '$correctAnswersCount/$totalItems'),
                      _buildSummaryRow('Accuracy', '${accuracy.toStringAsFixed(1)}%'),
                      _buildSummaryRow('Required', '70%'),
                    ] else ...[
                      _buildSummaryRow('Scenes Completed', '$totalItems/$totalItems'),
                      _buildSummaryRow('Path Taken', currentPath),
                      _buildSummaryRow('Ideal Path', widget.scenario.activity!.idealPath ?? 'N/A'),
                    ],
                    _buildSummaryRow('Total Coins Earned', '${_calculateCurrentCoins()}'),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Coins earned highlight
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[400]!, Colors.amber[600]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      '+${_calculateCurrentCoins()} Total Coins!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (!passed) ...[
            // Retry button if failed
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Reset activity state for retry
                  setState(() {
                    currentIndex = 0;
                    cardAnswers.clear();
                    simulationChoices.clear();
                    currentPath = "";
                    correctAnswersCount = 0;
                    totalItemsAnswered = 0;
                    isCompleted = false;
                    activityStartTime = DateTime.now();
                  });
                  // Reset page controllers
                  if (isSimulationActivity) {
                    _simulationController.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  } else {
                    _cardController.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          // Continue/Return button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                if (passed || widget.isFromScenario) {
                  widget.onActivityComplete(); // Call completion callback
                }
                Navigator.pop(context); // Return to previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: passed ? Colors.green : Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                passed
                    ? 'Continue to Next Scenario'
                    : 'Return to Scenario',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeActivityTracking() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DateTime endTime = DateTime.now();
      int durationSeconds = endTime.difference(activityStartTime).inSeconds;
      double finalAccuracy = totalItemsAnswered > 0
          ? (correctAnswersCount / totalItemsAnswered) * 100
          : 0;

      int totalCoins = _calculateCurrentCoins();
      bool passed = didPassActivity;

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
        'totalItems': totalItems,
        'activityType': widget.scenario.activity?.type,
        'coinsEarned': totalCoins,
        'passed': passed,
        'status': 'completed',
        'attempts': (hasPassedActivity ? 1 : 0) + 1, // Track retry attempts
        if (isSimulationActivity) ...{
          'simulationPath': currentPath,
          'idealPath': widget.scenario.activity?.idealPath,
          'achievedIdealPath': currentPath == widget.scenario.activity?.idealPath,
        },
      });

      // Mark scenario as activity completed if passed
      if (passed) {
        await _database
            .child('Progress')
            .child(user.uid)
            .child('scenarios')
            .child('${widget.scenario.id}')
            .child('activityCompleted')
            .set(true);
      }

      // Award final completion bonus coins
      await _awardCoins(5, 'activity_completion_bonus');

      // Update user's overall stats
      await _updateUserActivityStats();

      print('🏆 Activity completed - Type: ${widget.scenario.activity?.type}, Passed: $passed, Accuracy: ${finalAccuracy.toStringAsFixed(1)}%');
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

      DataSnapshot snapshot = await userStatsRef.get();
      Map<String, dynamic> stats = {};
      if (snapshot.exists) {
        stats = Map<String, dynamic>.from(snapshot.value as Map);
      }

      int currentActivitiesCompleted = stats['activitiesCompleted'] ?? 0;
      int currentCardActivities = stats['cardActivitiesCompleted'] ?? 0;
      int currentSimulationActivities = stats['simulationActivitiesCompleted'] ?? 0;
      int currentTotalItems = stats['totalActivityItems'] ?? 0;
      int currentCorrectAnswers = stats['correctActivityAnswers'] ?? 0;
      int currentActivitiesPassed = stats['activitiesPassed'] ?? 0;

      await userStatsRef.update({
        'activitiesCompleted': currentActivitiesCompleted + 1,
        if (didPassActivity)
          'activitiesPassed': currentActivitiesPassed + 1,
        if (isSimulationActivity)
          'simulationActivitiesCompleted': currentSimulationActivities + 1
        else
          'cardActivitiesCompleted': currentCardActivities + 1,
        'totalActivityItems': currentTotalItems + totalItems,
        'correctActivityAnswers': currentCorrectAnswers + correctAnswersCount,
        'lastActivityCompleted': ServerValue.timestamp,
        'lastActivityType': widget.scenario.activity?.type,
        'lastActivityPassed': didPassActivity,
      });
    } catch (e) {
      print('❌ Error updating user activity stats: $e');
    }
  }
}