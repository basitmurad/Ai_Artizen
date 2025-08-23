
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/LevelData.dart';

class WrongAnswerScreen extends StatefulWidget {
  final LevelData level;
  final Map<String, dynamic> scenarioData;
  final Map<String, dynamic> completeScenarioData;
  final int selectedOption;
  final String selectedOptionText;
  final int correctAnswer;
  final String correctOptionText;
  final String feedback;
  final String attemptedAt;

  const WrongAnswerScreen({
    super.key,
    required this.level,
    required this.scenarioData,
    required this.completeScenarioData,
    required this.selectedOption,
    required this.selectedOptionText,
    required this.correctAnswer,
    required this.correctOptionText,
    required this.feedback,
    required this.attemptedAt,
  });

  @override
  _WrongAnswerScreenState createState() => _WrongAnswerScreenState();
}

class _WrongAnswerScreenState extends State<WrongAnswerScreen>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Animation controllers
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late AnimationController _choiceAnimationController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _choiceAnimation;

  // Card and choice variables
  PageController _cardPageController = PageController();
  int _currentCardIndex = 0;
  List<Map<String, dynamic>> _activityCards = [];
  List<String?> _userChoices = [];
  List<bool> _isAnswered = [];
  bool _hasActivityData = false;
  bool _showResults = false;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _extractActivityCards();
  }

  void _initializeAnimations() {
    _slideAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );

    _choiceAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _choiceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _choiceAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    _choiceAnimationController.dispose();
    _cardPageController.dispose();
    super.dispose();
  }

  void _extractActivityCards() {
    if (widget.scenarioData.containsKey('activity')) {
      Map<String, dynamic> activity = widget.scenarioData['activity'];

      if (activity.containsKey('cards') && activity['cards'] is List) {
        List<dynamic> cards = activity['cards'];
        _activityCards =
            cards.map((card) => Map<String, dynamic>.from(card)).toList();
        _hasActivityData = true;

        // Initialize user choices and answered status
        _userChoices = List.filled(_activityCards.length, null);
        _isAnswered = List.filled(_activityCards.length, false);
      }
    } else {
      _hasActivityData = false;
    }

    setState(() {});
  }

  // Update Firebase progress when user makes a choice
  Future<void> _updateProgressUser(String choice, int questionIndex) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      final String userId = user.uid;
      final String levelId = widget.level.id.toString();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Get current progress data
      DatabaseEvent event =
          await _database
              .child('progressUser')
              .child(userId)
              .child('levels')
              .child(levelId)
              .once();

      Map<String, dynamic> existingProgress = {};
      if (event.snapshot.exists) {
        existingProgress = Map<String, dynamic>.from(
          event.snapshot.value as Map,
        );
      }

      // Update activity progress
      Map<String, dynamic> activityProgress = {};
      if (existingProgress.containsKey('activityProgress')) {
        activityProgress = Map<String, dynamic>.from(
          existingProgress['activityProgress'],
        );
      }

      // Add this choice to the activity progress
      String questionKey = 'question_${questionIndex + 1}';
      activityProgress[questionKey] = {
        'choice': choice,
        'statement': _activityCards[questionIndex]['statement'] ?? '',
        'correctAnswer': _activityCards[questionIndex]['correct'] ?? '',
        'isCorrect':
            choice.toLowerCase() ==
            (_activityCards[questionIndex]['correct'] ?? '').toLowerCase(),
        'answeredAt': timestamp,
      };

      // Update the complete progress structure
      Map<String, dynamic> updatedProgress = {
        ...existingProgress,
        'levelId': levelId,
        'levelTitle': widget.level.title,
        'activityProgress': activityProgress,
        'totalQuestions': _activityCards.length,
        'answeredQuestions':
            _userChoices.where((choice) => choice != null).length,
        'lastUpdated': timestamp,
        'status':
            _isAnswered.every((answered) => answered)
                ? 'completed'
                : 'in_progress',
      };

      // If all questions are answered, calculate final score
      if (_isAnswered.every((answered) => answered)) {
        int correctCount = 0;
        for (int i = 0; i < _activityCards.length; i++) {
          String correctAnswer =
              _activityCards[i]['correct']?.toLowerCase() ?? '';
          String userAnswer = _userChoices[i]?.toLowerCase() ?? '';
          if (correctAnswer == userAnswer) {
            correctCount++;
          }
        }

        updatedProgress['finalScore'] = correctCount;
        updatedProgress['finalPercentage'] =
            (correctCount / _activityCards.length) * 100;
        updatedProgress['completedAt'] = timestamp;
      }

      // Update Firebase
      await _database
          .child('progressUser')
          .child(userId)
          .child('levels')
          .child(levelId)
          .update(updatedProgress);

      // Also update user's overall progress
      await _updateOverallProgress(userId);

      print('Progress updated successfully for user: $userId, level: $levelId');
    } catch (e) {
      print('Error updating progress: $e');
    }
  }

  // Update overall user progress statistics
  Future<void> _updateOverallProgress(String userId) async {
    try {
      DatabaseEvent event =
          await _database
              .child('progressUser')
              .child(userId)
              .child('levels')
              .once();

      if (!event.snapshot.exists) return;

      Map<String, dynamic> allLevels = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );

      int totalLevels = allLevels.length;
      int completedLevels = 0;
      int totalScore = 0;
      int totalQuestions = 0;
      int totalCorrectAnswers = 0;

      allLevels.forEach((levelId, levelData) {
        Map<String, dynamic> level = Map<String, dynamic>.from(levelData);

        if (level['status'] == 'completed') {
          completedLevels++;
          totalScore += (level['finalScore'] as int? ?? 0);
          totalQuestions += (level['totalQuestions'] as int? ?? 0);
          totalCorrectAnswers += (level['finalScore'] as int? ?? 0);
        }
      });

      Map<String, dynamic> overallProgress = {
        'totalLevelsAttempted': totalLevels,
        'completedLevels': completedLevels,
        'totalQuestions': totalQuestions,
        'totalCorrectAnswers': totalCorrectAnswers,
        'overallPercentage':
            totalQuestions > 0
                ? (totalCorrectAnswers / totalQuestions) * 100
                : 0,
        'lastActivity': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      await _database
          .child('progressUser')
          .child(userId)
          .child('overallProgress')
          .update(overallProgress);
    } catch (e) {
      print('Error updating overall progress: $e');
    }
  }

  void _makeChoice(String choice) {
    if (_isAnswered[_currentCardIndex]) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _userChoices[_currentCardIndex] = choice;
      _isAnswered[_currentCardIndex] = true;
    });

    // Update Firebase progress
    _updateProgressUser(choice, _currentCardIndex);

    _choiceAnimationController.forward().then((_) {
      _choiceAnimationController.reverse();
    });

    // Auto advance to next card after a delay
    Future.delayed(Duration(milliseconds: 1500), () {
      if (_currentCardIndex < _activityCards.length - 1) {
        _cardPageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _calculateResults();
      }
    });
  }

  void _calculateResults() {
    _correctAnswers = 0;
    for (int i = 0; i < _activityCards.length; i++) {
      String correctAnswer = _activityCards[i]['correct']?.toLowerCase() ?? '';
      String userAnswer = _userChoices[i]?.toLowerCase() ?? '';

      if (correctAnswer == userAnswer) {
        _correctAnswers++;
      }
    }

    setState(() {
      _showResults = true;
    });

    // Final update to mark as completed
    _updateProgressUser('completed', -1); // -1 indicates completion update
  }

  void _resetQuiz() {
    setState(() {
      _currentCardIndex = 0;
      _userChoices = List.filled(_activityCards.length, null);
      _isAnswered = List.filled(_activityCards.length, false);
      _showResults = false;
      _correctAnswers = 0;
    });

    _cardPageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFAB47BC)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 2),
                blurRadius: 8,
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
                  Navigator.pop(context);
                },
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Interactive Quiz',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.psychology, color: Colors.white, size: 18),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Level ${widget.level.id}: ${widget.level.title}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFAB47BC)],
          ),
        ),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _showResults ? _buildResultsScreen() : _buildQuizScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizScreen() {
    if (!_hasActivityData) {
      return Center(
        child: Text(
          'No activity data available',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Column(
      children: [
        // Progress indicator
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentCardIndex + 1} of ${_activityCards.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_isAnswered.where((answered) => answered).length}/${_activityCards.length} answered',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),

        // Linear progress bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: (_currentCardIndex + 1) / _activityCards.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),

        // Cards
        Expanded(
          child: PageView.builder(
            controller: _cardPageController,
            onPageChanged: (index) {
              setState(() {
                _currentCardIndex = index;
              });
            },
            itemCount: _activityCards.length,
            itemBuilder: (context, index) {
              return _buildInteractiveCard(_activityCards[index], index);
            },
          ),
        ),

        // Navigation buttons
        if (_currentCardIndex > 0 || _isAnswered.any((answered) => answered))
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentCardIndex > 0)
                  ElevatedButton(
                    onPressed: () {
                      _cardPageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 4),
                        Text('Previous'),
                      ],
                    ),
                  ),

                Spacer(),

                if (_isAnswered.every((answered) => answered))
                  ElevatedButton(
                    onPressed: _calculateResults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('See Results'),
                        SizedBox(width: 4),
                        Icon(Icons.check_circle),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInteractiveCard(Map<String, dynamic> card, int index) {
    String statement = card['statement'] ?? '';
    bool isAnswered = _isAnswered[index];
    String? userChoice = _userChoices[index];

    return Container(
      margin: EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scenario text
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                        SizedBox(width: 8),
                        Text(
                          'Situation to Evaluate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      statement,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Question
              Text(
                'Do you think this situation is fair or unfair?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24),

              // Choice buttons
              AnimatedBuilder(
                animation: _choiceAnimation,
                builder: (context, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: Transform.scale(
                          scale:
                              isAnswered && userChoice == 'fair'
                                  ? _choiceAnimation.value
                                  : 1.0,
                          child: ElevatedButton(
                            onPressed:
                                isAnswered ? null : () => _makeChoice('fair'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isAnswered && userChoice == 'fair'
                                      ? Colors.green
                                      : isAnswered
                                      ? Colors.grey[300]
                                      : Colors.green[400],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation:
                                  isAnswered && userChoice == 'fair' ? 8 : 4,
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.thumb_up, size: 28),
                                SizedBox(height: 8),
                                Text(
                                  'FAIR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 16),

                      Expanded(
                        child: Transform.scale(
                          scale:
                              isAnswered && userChoice == 'unfair'
                                  ? _choiceAnimation.value
                                  : 1.0,
                          child: ElevatedButton(
                            onPressed:
                                isAnswered ? null : () => _makeChoice('unfair'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isAnswered && userChoice == 'unfair'
                                      ? Colors.red
                                      : isAnswered
                                      ? Colors.grey[300]
                                      : Colors.red[400],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation:
                                  isAnswered && userChoice == 'unfair' ? 8 : 4,
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.thumb_down, size: 28),
                                SizedBox(height: 8),
                                Text(
                                  'UNFAIR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              if (isAnswered) ...[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Answer recorded! ${_currentCardIndex < _activityCards.length - 1 ? "Moving to next question..." : "Ready to see results!"}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }

  Widget _buildResultsScreen() {
    double percentage = (_correctAnswers / _activityCards.length) * 100;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Results header
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  percentage >= 70 ? Icons.celebration : Icons.psychology,
                  size: 60,
                  color: percentage >= 70 ? Colors.green : Colors.orange,
                ),
                SizedBox(height: 16),
                Text(
                  'Quiz Complete!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You got $_correctAnswers out of ${_activityCards.length} correct',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: percentage >= 70 ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    '${percentage.toInt()}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Detailed results
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Your Answers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                ...List.generate(_activityCards.length, (index) {
                  String statement = _activityCards[index]['statement'] ?? '';
                  String correctAnswer = _activityCards[index]['correct'] ?? '';
                  String userAnswer = _userChoices[index] ?? '';
                  String feedback = _activityCards[index]['feedback'] ?? '';
                  bool isCorrect =
                      correctAnswer.toLowerCase() == userAnswer.toLowerCase();

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isCorrect ? Colors.green[200]! : Colors.red[200]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Question ${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isCorrect
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          statement,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Your answer: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(userAnswer.toUpperCase()),
                            SizedBox(width: 16),
                            Text(
                              'Correct: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(correctAnswer.toUpperCase()),
                          ],
                        ),
                        if (feedback.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Text(
                            feedback,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetQuiz,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white, width: 2),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
