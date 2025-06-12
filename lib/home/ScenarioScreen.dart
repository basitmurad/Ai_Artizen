import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/LevelData.dart';
import 'WrongAnswerScreen.dart';

class ScenarioScreen extends StatefulWidget {
  final LevelData level;
  final String moduleTitle;

  ScenarioScreen({required this.level, required this.moduleTitle});

  @override
  _ScenarioScreenState createState() => _ScenarioScreenState();
}

class _ScenarioScreenState extends State<ScenarioScreen> with TickerProviderStateMixin {
  int? selectedOptionIndex;
  bool hasAnswered = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Animation controllers for enhanced UI
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _printCompleteScenarioData();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimationController.repeat(reverse: true);
  }




  @override
  void dispose() {
    _pulseAnimationController.dispose();
    super.dispose();
  }

  // Method to print all scenario data for debugging
  void _printCompleteScenarioData() {
    print('\n' + '='*60);
    print('COMPLETE SCENARIO LEVEL ${widget.level.id} DATA');
    print('='*60);

    // Basic level info
    print('📍 LEVEL BASIC INFO:');
    print('   Level ID: ${widget.level.id}');
    print('   Level Title: ${widget.level.title}');
    print('');

    // Complete scenario data as JSON for full visibility
    print('📋 COMPLETE SCENARIO DATA (JSON FORMAT):');
    try {
      String jsonString = JsonEncoder.withIndent('  ').convert(widget.level.scenarioData);
      print(jsonString);
    } catch (e) {
      print('   Error formatting JSON: $e');
      print('   Raw data: ${widget.level.scenarioData}');
    }
    print('');

    // Detailed breakdown of each component
    print('📝 DETAILED BREAKDOWN:');

    // ID
    if (widget.level.scenarioData.containsKey('id')) {
      print('   ID: ${widget.level.scenarioData['id']}');
    }

    // Title
    if (widget.level.scenarioData.containsKey('title')) {
      print('   Title: ${widget.level.scenarioData['title']}');
    }

    // Description
    if (widget.level.scenarioData.containsKey('description')) {
      print('   Description: ${widget.level.scenarioData['description']}');
    }

    // Question (if exists)
    if (widget.level.scenarioData.containsKey('question')) {
      print('   Question: ${widget.level.scenarioData['question']}');
    }

    // Options
    if (widget.level.scenarioData.containsKey('options')) {
      print('   Options:');
      List<dynamic> options = widget.level.scenarioData['options'];
      for (int i = 0; i < options.length; i++) {
        print('      ${i + 1}. ${options[i]}');
      }
    }

    // Correct Answer
    if (widget.level.scenarioData.containsKey('correctAnswer')) {
      print('   Correct Answer: ${widget.level.scenarioData['correctAnswer']}');
    }

    // Activity data (detailed breakdown)
    if (widget.level.scenarioData.containsKey('activity')) {
      print('   Activity Data:');
      Map<String, dynamic> activity = widget.level.scenarioData['activity'];

      if (activity.containsKey('type')) {
        print('      Type: ${activity['type']}');
      }

      if (activity.containsKey('name')) {
        print('      Name: ${activity['name']}');
      }

      if (activity.containsKey('cards')) {
        print('      Cards:');
        List<dynamic> cards = activity['cards'];
        for (int i = 0; i < cards.length; i++) {
          print('         Card ${i + 1}:');
          Map<String, dynamic> card = cards[i];

          if (card.containsKey('statement')) {
            print('            Statement: ${card['statement']}');
          }

          if (card.containsKey('correct')) {
            print('            Correct: ${card['correct']}');
          }

          if (card.containsKey('feedback')) {
            print('            Feedback: ${card['feedback']}');
          }

          print(''); // Empty line between cards
        }
      }
    }

    // Feedback
    if (widget.level.scenarioData.containsKey('feedback')) {
      print('   General Feedback: ${widget.level.scenarioData['feedback']}');
    }

    // Any other keys
    print('   All Keys in Scenario Data:');
    widget.level.scenarioData.keys.forEach((key) {
      print('      - $key');
    });

    print('='*60);
    print('END COMPLETE SCENARIO DATA');
    print('='*60 + '\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enhanced AppBar with modern design
      // Replace your AppBar section with this fixed version:

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4A90E2),
                Color(0xFF357ABD),
                Color(0xFF2E5984),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
              ),
            ),
            // SIMPLIFIED ALTERNATIVE: Just use Column without complex constraints
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Important: prevents overflow
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'L${widget.level.id}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.psychology,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 2),
                // FIXED: Simple Text widget with proper overflow handling
                Text(
                  widget.level.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Module',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.5),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < widget.level.id
                                ? Colors.amber
                                : Colors.white.withOpacity(0.3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(80.0),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //         colors: [
      //           Color(0xFF4A90E2),
      //           Color(0xFF357ABD),
      //           Color(0xFF2E5984),
      //         ],
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black.withOpacity(0.1),
      //           offset: Offset(0, 2),
      //           blurRadius: 8,
      //           spreadRadius: 0,
      //         ),
      //       ],
      //     ),
      //     child: AppBar(
      //       backgroundColor: Colors.transparent,
      //       elevation: 0,
      //       leading: Container(
      //         margin: EdgeInsets.all(8),
      //         decoration: BoxDecoration(
      //           color: Colors.white.withOpacity(0.2),
      //           borderRadius: BorderRadius.circular(12),
      //         ),
      //         child: IconButton(
      //           icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
      //           onPressed: () {
      //             HapticFeedback.lightImpact();
      //             Navigator.of(context).pop(); // Try this instead
      //           },
      //         ),
      //       ),
      //       title: Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             AnimatedBuilder(
      //               animation: _pulseAnimation,
      //               builder: (context, child) {
      //                 return Transform.scale(
      //                   scale: _pulseAnimation.value,
      //                   child: Row(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       Container(
      //                         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      //                         decoration: BoxDecoration(
      //                           color: Colors.amber,
      //                           borderRadius: BorderRadius.circular(6),
      //                         ),
      //                         child: Text(
      //                           'L${widget.level.id}',
      //                           style: TextStyle(
      //                             fontSize: 10,
      //                             fontWeight: FontWeight.bold,
      //                             color: Colors.black,
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(width: 6),
      //                       Icon(
      //                         Icons.psychology,
      //                         color: Colors.white,
      //                         size: 16,
      //                       ),
      //                     ],
      //                   ),
      //                 );
      //               },
      //             ),
      //             SizedBox(height: 2),
      //             Flexible(
      //               child: Text(
      //                 widget.level.title,
      //                 style: TextStyle(
      //                   fontSize: 14,
      //                   fontWeight: FontWeight.w600,
      //                   color: Colors.white,
      //                 ),
      //                 overflow: TextOverflow.ellipsis,
      //                 maxLines: 1,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       actions: [
      //         Container(
      //           margin: EdgeInsets.only(right: 8),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Container(
      //                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      //                 decoration: BoxDecoration(
      //                   color: Colors.white.withOpacity(0.2),
      //                   borderRadius: BorderRadius.circular(12),
      //                   border: Border.all(
      //                     color: Colors.white.withOpacity(0.3),
      //                     width: 1,
      //                   ),
      //                 ),
      //                 child: Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     Icon(
      //                       Icons.school,
      //                       color: Colors.white,
      //                       size: 12,
      //                     ),
      //                     SizedBox(width: 3),
      //                     Text(
      //                       'Module',
      //                       style: TextStyle(
      //                         fontSize: 9,
      //                         color: Colors.white,
      //                         fontWeight: FontWeight.w500,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(height: 3),
      //               Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: List.generate(5, (index) {
      //                   return Container(
      //                     margin: EdgeInsets.symmetric(horizontal: 0.5),
      //                     width: 4,
      //                     height: 4,
      //                     decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       color: index < widget.level.id
      //                           ? Colors.amber
      //                           : Colors.white.withOpacity(0.3),
      //                     ),
      //                   );
      //                 }),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.track_changes,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Level ${widget.level.id} of 5',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          'AI Ethics',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  'Scenario:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    widget.level.scenarioData['description'] ?? 'Scenario content will be loaded here...',
                    style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[800]),
                  ),
                ),
                SizedBox(height: 20),

                // Question if exists
                if (widget.level.scenarioData.containsKey('question'))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          widget.level.scenarioData['question'],
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                Text(
                  'Choose your response:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                // Options List
                ...List.generate(
                  (widget.level.scenarioData['options'] as List<dynamic>?)?.length ?? 0,
                      (index) {
                    List<dynamic> options = widget.level.scenarioData['options'] as List<dynamic>;
                    bool isSelected = selectedOptionIndex == index;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: hasAnswered ? null : () {
                          setState(() {
                            selectedOptionIndex = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? Color(0xFF4A90E2)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? Color(0xFF4A90E2)
                                        : Colors.white.withOpacity(0.6),
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${index + 1}. ${options[index]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                // Submit button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (selectedOptionIndex != null && !hasAnswered)
                        ? () => _handleSubmit()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF4A90E2),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: selectedOptionIndex != null ? 3 : 0,
                    ),
                    child: Text(
                      'Submit Answer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (selectedOptionIndex == null) return;

    setState(() {
      hasAnswered = true;
    });

    int correctAnswer = widget.level.scenarioData['correctAnswer'] ?? 1;
    bool isCorrect = (selectedOptionIndex! + 1) == correctAnswer;

    if (isCorrect) {
      _handleCorrectAnswer();
    } else {
      _handleWrongAnswer();
    }
  }

  Future<void> _handleCorrectAnswer() async {
    try {
      // Prepare the data to upload
      final String userId = _auth.currentUser!.uid;
      final String timestamp = DateTime.now().toIso8601String();

      // Create comprehensive progress data
      Map<String, dynamic> progressData = {
        'levelId': widget.level.id,
        'levelTitle': widget.level.title,
        'moduleTitle': widget.moduleTitle,
        'score': 3, // 3 stars for correct answer
        'completed': true,
        'isCorrect': true,
        'selectedAnswer': selectedOptionIndex! + 1,
        'selectedAnswerText': (widget.level.scenarioData['options'] as List<dynamic>)[selectedOptionIndex!],
        'correctAnswer': widget.level.scenarioData['correctAnswer'] ?? 1,
        'completedAt': timestamp,
        'attemptsCount': 1,
        'scenarioId': widget.level.scenarioData['id'] ?? widget.level.id,
        'feedback': widget.level.scenarioData['feedback'] ?? 'Excellent work!',
      };

      // Upload to Firebase - Structure: users/{userId}/progress/{moduleTitle}/level_{levelId}
      await _database
          .child('progressUser')
          .child(userId)
          .child('progress')
          .child(widget.moduleTitle.replaceAll(' ', '_').toLowerCase())
          .child('level_${widget.level.id}')
          .set(progressData);

      // Also update overall module progress
      await _updateModuleProgress(userId, timestamp);

      print('✅ Successfully uploaded progress data to Firebase');
      print('📊 Data uploaded: $progressData');

    } catch (e) {
      print('❌ Error uploading to Firebase: $e');
      // Continue with the success dialog even if upload fails
    }

    // Show success dialog with star rating
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Excellent!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You got it right!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Star rating display
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Stars Earned',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '3/3 Stars',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Feedback
            if (widget.level.scenarioData.containsKey('feedback'))
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.level.scenarioData['feedback'] ?? 'Great job!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        actions: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, {
                  'completed': true,
                  'correct': true,
                  'score': 3,
                  'levelId': widget.level.id,
                  'scenarioData': widget.level.scenarioData,
                  'selectedOption': selectedOptionIndex,
                  'completedAt': DateTime.now().toIso8601String(),
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Continue to Next Level',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateModuleProgress(String userId, String timestamp) async {
    try {
      // Get current module progress
      final moduleKey = widget.moduleTitle.replaceAll(' ', '_').toLowerCase();
      final moduleRef = _database
          .child('progressUser')
          .child(userId)
          .child('modules')
          .child(moduleKey);

      // Update module summary
      await moduleRef.update({
        'moduleTitle': widget.moduleTitle,
        'lastCompletedLevel': widget.level.id,
        'lastActivityAt': timestamp,
        'totalLevelsCompleted': ServerValue.increment(1),
      });

      print('✅ Module progress updated successfully');

    } catch (e) {
      print('❌ Error updating module progress: $e');
    }
  }
  Future<void> _handleWrongAnswer() async {
    // COMPREHENSIVE DATA LOGGING BEFORE NAVIGATION
    print('\n' + '🔴'*80);
    print('WRONG ANSWER DETECTED - COMPLETE DATA TRANSMISSION');
    print('All the data ');
    print('🔴'*80);

    // 1. Basic Level Information
    print('📍 BASIC LEVEL INFO:');
    print('   Level ID: ${widget.level.id}');
    print('   Level Title: ${widget.level.title}');
    print('   Module Title: ${widget.moduleTitle}');
    print('');

    // 2. Complete Scenario Data Structure
    print('📋 COMPLETE SCENARIO DATA STRUCTURE:');
    try {
      String jsonString = JsonEncoder.withIndent('  ').convert(widget.level.scenarioData);
      print(jsonString);
    } catch (e) {
      print('   Error formatting JSON: $e');
      print('   Raw data: ${widget.level.scenarioData}');
    }
    print('');

    // 3. Answer Analysis
    print('🎯 ANSWER ANALYSIS:');
    print('   Selected Option Index: $selectedOptionIndex');
    print('   Selected Option (0-based): ${selectedOptionIndex}');
    print('   Selected Option (1-based): ${selectedOptionIndex! + 1}');
    print('   Selected Answer Text: "${(widget.level.scenarioData['options'] as List<dynamic>)[selectedOptionIndex!]}"');
    print('   Correct Answer Index: ${(widget.level.scenarioData['correctAnswer'] ?? 1) - 1}');
    print('   Correct Answer (1-based): ${widget.level.scenarioData['correctAnswer'] ?? 1}');
    print('   Correct Answer Text: "${(widget.level.scenarioData['options'] as List<dynamic>)[(widget.level.scenarioData['correctAnswer'] ?? 1) - 1]}"');
    print('');

    // 4. All Available Options
    print('📝 ALL AVAILABLE OPTIONS:');
    List<dynamic> options = widget.level.scenarioData['options'] as List<dynamic>;
    for (int i = 0; i < options.length; i++) {
      String prefix = i == selectedOptionIndex ? '❌ SELECTED' :
      i == (widget.level.scenarioData['correctAnswer'] ?? 1) - 1 ? '✅ CORRECT' : '⚪ OPTION';
      print('   ${i + 1}. [$prefix] ${options[i]}');
    }
    print('');

    // 5. Scenario Content Details
    print('📖 SCENARIO CONTENT:');
    print('   Description: ${widget.level.scenarioData['description'] ?? 'N/A'}');
    if (widget.level.scenarioData.containsKey('question')) {
      print('   Question: ${widget.level.scenarioData['question']}');
    }
    print('   Feedback: ${_getWrongAnswerFeedback()}');
    print('');

    // 6. Activity Data (if exists)
    if (widget.level.scenarioData.containsKey('activity')) {
      print('🎮 ACTIVITY DATA:');
      Map<String, dynamic> activity = widget.level.scenarioData['activity'];
      print('   Activity Type: ${activity['type'] ?? 'N/A'}');
      print('   Activity Name: ${activity['name'] ?? 'N/A'}');

      if (activity.containsKey('cards')) {
        print('   Activity Cards:');
        List<dynamic> cards = activity['cards'];
        for (int i = 0; i < cards.length; i++) {
          Map<String, dynamic> card = cards[i];
          print('      Card ${i + 1}:');
          print('         Statement: ${card['statement'] ?? 'N/A'}');
          print('         Correct: ${card['correct'] ?? 'N/A'}');
          print('         Feedback: ${card['feedback'] ?? 'N/A'}');
        }
      }
      print('');
    }

    // 7. Metadata
    print('⏰ ATTEMPT METADATA:');
    String timestamp = DateTime.now().toIso8601String();
    print('   Attempt Timestamp: $timestamp');
    print('   User ID: ${_auth.currentUser?.uid ?? 'Not logged in'}');
    print('   Has Answered: $hasAnswered');
    print('');

    // 8. Data Package for WrongAnswerScreen
    Map<String, dynamic> completeDataPackage = {
      // Basic identifiers
      'levelId': widget.level.id,
      'levelTitle': widget.level.title,
      'moduleTitle': widget.moduleTitle,

      // Complete scenario data
      'fullScenarioData': widget.level.scenarioData,
      'rawLevelData': widget.level,

      // Scenario content
      'description': widget.level.scenarioData['description'],
      'question': widget.level.scenarioData.containsKey('question')
          ? widget.level.scenarioData['question'] : null,
      'allOptions': widget.level.scenarioData['options'],

      // Answer details
      'selectedAnswer': selectedOptionIndex! + 1,
      'selectedAnswerIndex': selectedOptionIndex,
      'selectedAnswerText': (widget.level.scenarioData['options'] as List<dynamic>)[selectedOptionIndex!],
      'correctAnswer': widget.level.scenarioData['correctAnswer'] ?? 1,
      'correctAnswerIndex': (widget.level.scenarioData['correctAnswer'] ?? 1) - 1,
      'correctAnswerText': (widget.level.scenarioData['options'] as List<dynamic>)[(widget.level.scenarioData['correctAnswer'] ?? 1) - 1],

      // Feedback and activity data
      'feedback': _getWrongAnswerFeedback(),
      'activityData': widget.level.scenarioData.containsKey('activity')
          ? widget.level.scenarioData['activity'] : null,

      // Metadata
      'attemptTimestamp': timestamp,
      'userId': _auth.currentUser?.uid,

      // Additional context
      'allScenarioKeys': widget.level.scenarioData.keys.toList(),
      'totalOptions': (widget.level.scenarioData['options'] as List<dynamic>).length,
    };

    print('📦 COMPLETE DATA PACKAGE TO BE SENT:');
    try {
      String packageJson = JsonEncoder.withIndent('  ').convert(completeDataPackage);
      print(packageJson);
    } catch (e) {
      print('   Error formatting data package: $e');
      completeDataPackage.forEach((key, value) {
        print('   $key: $value');
      });
    }
    print('');

    print('🔴'*80);
    print('END WRONG ANSWER DATA TRANSMISSION LOG');
    print('🔴'*80 + '\n');


    try {
      // Prepare the data to upload
      final String userId = _auth.currentUser!.uid;
      final String timestamp = DateTime.now().toIso8601String();

      // Create comprehensive progress data
      Map<String, dynamic> progressData = {
        'levelId': widget.level.id,
        'levelTitle': widget.level.title,
        'moduleTitle': widget.moduleTitle,
        'score': 0, // 3 stars for correct answer
        'completed': true,
        'isCorrect': true,
        'selectedAnswer': selectedOptionIndex! + 1,
        'selectedAnswerText': (widget.level.scenarioData['options'] as List<dynamic>)[selectedOptionIndex!],
        'correctAnswer': widget.level.scenarioData['correctAnswer'] ?? 1,
        'completedAt': timestamp,
        'attemptsCount': 1,
        'scenarioId': widget.level.scenarioData['id'] ?? widget.level.id,
        'feedback': widget.level.scenarioData['feedback'] ?? 'Excellent work!',
      };

      // Upload to Firebase - Structure: users/{userId}/progress/{moduleTitle}/level_{levelId}
      await _database
          .child('progressUser')
          .child(userId)
          .child('progress')
          .child(widget.moduleTitle.replaceAll(' ', '_').toLowerCase())
          .child('level_${widget.level.id}')
          .set(progressData);

      // Also update overall module progress
      await _updateModuleProgress(userId, timestamp);

      print('✅ Successfully uploaded progress data to Firebase');
      print('📊 Data uploaded: $progressData');

    } catch (e) {
      print('❌ Error uploading to Firebase: $e');
      // Continue with the success dialog even if upload fails
    }
    // Show wrong answer dialog first, then navigate on continue
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(
              Icons.close_rounded,
              color: Colors.red,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Not Quite Right',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Let\'s learn from this together!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We\'ll review the correct approach and reasoning.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Print navigation log
                print('\n🚀 NAVIGATING TO WRONG ANSWER SCREEN');
                print('   Complete data package ready for transmission');
                print('   Navigation timestamp: ${DateTime.now().toIso8601String()}');

                Navigator.pop(context); // Close dialog

                // Navigate to WrongAnswer screen with comprehensive data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WrongAnswerScreen(
                      // Pass the complete level object
                      level: widget.level,

                      // Pass the complete scenario data map
                      scenarioData: widget.level.scenarioData,

                      // Pass comprehensive scenario details
                      completeScenarioData: completeDataPackage,

                      // Individual parameters (maintaining backward compatibility)
                      selectedOption: selectedOptionIndex!,
                      selectedOptionText: completeDataPackage['selectedAnswerText'],
                      correctAnswer: completeDataPackage['correctAnswer'],
                      correctOptionText: completeDataPackage['correctAnswerText'],
                      feedback: completeDataPackage['feedback'],
                      attemptedAt: completeDataPackage['attemptTimestamp'],
                    ),
                  ),
                ).then((result) {
                  // Handle result when returning from WrongAnswerScreen
                  print('\n🔙 RETURNED FROM WRONG ANSWER SCREEN');
                  print('   Return result: $result');
                  print('   Return timestamp: ${DateTime.now().toIso8601String()}');

                  if (result != null) {
                    print('   Processing return result...');
                    // Navigate back to dashboard or handle result
                    Navigator.pop(context, result);
                  } else {
                    print('   No result returned, staying on current screen');
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Continue to Review',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Enhanced feedback method with better fallback logic
  String _getWrongAnswerFeedback() {
    print('\n🔍 GETTING WRONG ANSWER FEEDBACK:');

    String feedback = '';

    // Try multiple feedback sources
    if (widget.level.scenarioData.containsKey('feedback')) {
      feedback = widget.level.scenarioData['feedback'];
      print('   ✅ Found feedback in main scenario data: "$feedback"');
    } else if (widget.level.scenarioData.containsKey('activity') &&
        widget.level.scenarioData['activity'] is Map &&
        widget.level.scenarioData['activity']['feedback'] != null) {
      feedback = widget.level.scenarioData['activity']['feedback'];
      print('   ✅ Found feedback in activity data: "$feedback"');
    } else if (widget.level.scenarioData.containsKey('wrongAnswerFeedback')) {
      feedback = widget.level.scenarioData['wrongAnswerFeedback'];
      print('   ✅ Found wrong answer specific feedback: "$feedback"');
    } else {
      feedback = 'Consider the human-centered approach when making AI decisions. Review the scenario and think about the ethical implications of each choice.';
      print('   ⚠️ Using default feedback: "$feedback"');
    }

    print('   📝 Final feedback to be used: "$feedback"\n');
    return feedback;
  }
}