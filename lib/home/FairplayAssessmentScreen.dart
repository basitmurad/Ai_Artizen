import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/LevelData.dart';

class FairplayAssessmentScreen extends StatefulWidget {
  final LevelData level;
  final Map<String, dynamic> scenarioData;
  final Map<String, dynamic> completeScenarioData;
  final int selectedOption;
  final String selectedOptionText;
  final int correctAnswer;
  final String correctOptionText;
  final String feedback;
  final String attemptedAt;

  const FairplayAssessmentScreen({
    Key? key,
    required this.level,
    required this.scenarioData,
    required this.completeScenarioData,
    required this.selectedOption,
    required this.selectedOptionText,
    required this.correctAnswer,
    required this.correctOptionText,
    required this.feedback,
    required this.attemptedAt,
  }) : super(key: key);

  @override
  _FairplayAssessmentScreenState createState() => _FairplayAssessmentScreenState();
}

class _FairplayAssessmentScreenState extends State<FairplayAssessmentScreen>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Animation controllers
  late AnimationController _cardAnimationController;
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;
  late AnimationController _progressAnimationController;

  late Animation<double> _cardAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  // Assessment variables
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _assessmentQuestions = [];
  List<String?> _userAnswers = [];
  List<bool> _isAnswered = [];
  bool _hasAssessmentData = false;
  bool _showResults = false;
  bool _isTransitioning = false;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _extractAssessmentQuestions();
  }

  void _initializeAnimations() {
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );

    _scaleAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _scaleAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _progressAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _cardAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _extractAssessmentQuestions() {
    if (widget.scenarioData.containsKey('activity')) {
      Map<String, dynamic> activity = widget.scenarioData['activity'];

      if (activity.containsKey('cards') && activity['cards'] is List) {
        List<dynamic> cards = activity['cards'];
        _assessmentQuestions =
            cards.map((card) => Map<String, dynamic>.from(card)).toList();
        _hasAssessmentData = true;

        // Initialize user answers and answered status
        _userAnswers = List.filled(_assessmentQuestions.length, null);
        _isAnswered = List.filled(_assessmentQuestions.length, false);
      }
    } else {
      _hasAssessmentData = false;
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
        'statement': _assessmentQuestions[questionIndex]['statement'] ?? '',
        'correctAnswer': _assessmentQuestions[questionIndex]['correct'] ?? '',
        'isCorrect':
        choice.toLowerCase() ==
            (_assessmentQuestions[questionIndex]['correct'] ?? '').toLowerCase(),
        'answeredAt': timestamp,
      };

      // Update the complete progress structure
      Map<String, dynamic> updatedProgress = {
        ...existingProgress,
        'levelId': levelId,
        'levelTitle': widget.level.title,
        'activityProgress': activityProgress,
        'totalQuestions': _assessmentQuestions.length,
        'answeredQuestions':
        _userAnswers.where((choice) => choice != null).length,
        'lastUpdated': timestamp,
        'status':
        _isAnswered.every((answered) => answered)
            ? 'completed'
            : 'in_progress',
      };

      // If all questions are answered, calculate final score
      if (_isAnswered.every((answered) => answered)) {
        int correctCount = 0;
        for (int i = 0; i < _assessmentQuestions.length; i++) {
          String correctAnswer =
              _assessmentQuestions[i]['correct']?.toLowerCase() ?? '';
          String userAnswer = _userAnswers[i]?.toLowerCase() ?? '';
          if (correctAnswer == userAnswer) {
            correctCount++;
          }
        }

        updatedProgress['finalScore'] = correctCount;
        updatedProgress['finalPercentage'] =
            (correctCount / _assessmentQuestions.length) * 100;
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

  void _makeChoice(String choice) async {
    if (_isAnswered[_currentQuestionIndex] || _isTransitioning) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _isTransitioning = true;
    });

    // Scale animation for feedback
    _scaleAnimationController.forward().then((_) {
      _scaleAnimationController.reverse();
    });

    setState(() {
      _userAnswers[_currentQuestionIndex] = choice;
      _isAnswered[_currentQuestionIndex] = true;
    });

    // Update Firebase progress
    await _updateProgressUser(choice, _currentQuestionIndex);

    // Wait for animation to complete
    await Future.delayed(Duration(milliseconds: 1200));

    if (_currentQuestionIndex < _assessmentQuestions.length - 1) {
      // Move to next question with card flip animation
      _cardAnimationController.reverse().then((_) {
        setState(() {
          _currentQuestionIndex++;
          _isTransitioning = false;
        });
        _cardAnimationController.forward();
      });
    } else {
      // Show results
      _calculateResults();
    }
  }

  void _calculateResults() {
    _correctAnswers = 0;
    for (int i = 0; i < _assessmentQuestions.length; i++) {
      String correctAnswer = _assessmentQuestions[i]['correct']?.toLowerCase() ?? '';
      String userAnswer = _userAnswers[i]?.toLowerCase() ?? '';

      if (correctAnswer == userAnswer) {
        _correctAnswers++;
      }
    }

    setState(() {
      _showResults = true;
      _isTransitioning = false;
    });

    _progressAnimationController.forward();

    // Final update to mark as completed
    _updateProgressUser('completed', -1); // -1 indicates completion update
  }

  void _resetAssessment() {
    setState(() {
      _currentQuestionIndex = 0;
      _userAnswers = List.filled(_assessmentQuestions.length, null);
      _isAnswered = List.filled(_assessmentQuestions.length, false);
      _showResults = false;
      _correctAnswers = 0;
      _isTransitioning = false;
    });

    _cardAnimationController.reset();
    _progressAnimationController.reset();
    _cardAnimationController.forward();
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0 && !_isTransitioning) {
      _cardAnimationController.reverse().then((_) {
        setState(() {
          _currentQuestionIndex--;
        });
        _cardAnimationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E293B),
                Color(0xFF334155),
                Color(0xFF475569),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 15,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Fairplay Assessment',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.balance, color: Colors.white, size: 20),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Level ${widget.level.id}: ${widget.level.title}',
                  style: TextStyle(
                    fontSize: 15,
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
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF334155),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _showResults ? _buildResultsScreen() : _buildAssessmentScreen(),
        ),
      ),
    );
  }

  Widget _buildAssessmentScreen() {
    if (!_hasAssessmentData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white70, size: 64),
            SizedBox(height: 16),
            Text(
              'No assessment data available',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      );
    }

    double progress = (_currentQuestionIndex + 1) / _assessmentQuestions.length;

    return Column(
      children: [
        // Modern Progress Section
        Container(
          margin: EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${_assessmentQuestions.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Main Question Card
        Expanded(
          child: Container(
            margin: EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: _cardAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _cardAnimation.value,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: _buildQuestionCard(_assessmentQuestions[_currentQuestionIndex]),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),

        // Navigation Section
        Container(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              // Previous Button
              if (_currentQuestionIndex > 0)
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isTransitioning ? null : _goToPreviousQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Previous', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),

              if (_currentQuestionIndex > 0) SizedBox(width: 16),

              // Progress Indicator Dots
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_assessmentQuestions.length, (index) {
                    bool isActive = index == _currentQuestionIndex;
                    bool isAnswered = _isAnswered[index];

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 12 : 8,
                      height: isActive ? 12 : 8,
                      decoration: BoxDecoration(
                        color: isAnswered
                            ? Color(0xFF10B981)
                            : isActive
                            ? Color(0xFF3B82F6)
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: isActive ? [
                          BoxShadow(
                            color: Color(0xFF3B82F6).withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ] : null,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    String statement = question['statement'] ?? '';
    bool isAnswered = _isAnswered[_currentQuestionIndex];
    String? userChoice = _userAnswers[_currentQuestionIndex];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.gavel, color: Colors.white, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Evaluate this situation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scenario Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scenario Text
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          statement,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Question
                  Center(
                    child: Text(
                      'Is this situation fair or unfair?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Choice Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isAnswered ? null : () => _makeChoice('fair'),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: isAnswered && userChoice == 'fair'
                                  ? LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
                                  : LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (isAnswered && userChoice == 'fair'
                                      ? Color(0xFF10B981)
                                      : Color(0xFF22C55E)).withOpacity(0.3),
                                  blurRadius: isAnswered && userChoice == 'fair' ? 12 : 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.thumb_up_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'FAIR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 20),

                      Expanded(
                        child: GestureDetector(
                          onTap: isAnswered ? null : () => _makeChoice('unfair'),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: isAnswered && userChoice == 'unfair'
                                  ? LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                                  : LinearGradient(colors: [Color(0xFFF87171), Color(0xFFEF4444)]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (isAnswered && userChoice == 'unfair'
                                      ? Color(0xFFEF4444)
                                      : Color(0xFFF87171)).withOpacity(0.3),
                                  blurRadius: isAnswered && userChoice == 'unfair' ? 12 : 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.thumb_down_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'UNFAIR',
                                  style: TextStyle(
                                    color: Colors.white,
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
                  ),

                  if (isAnswered) ...[
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFDCFDF7), Color(0xFFB7F0E8)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFF10B981).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _currentQuestionIndex < _assessmentQuestions.length - 1
                                  ? 'Answer recorded! Moving to the next scenario...'
                                  : 'Assessment complete! Preparing your results...',
                              style: TextStyle(
                                color: Color(0xFF065F46),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    double percentage = (_correctAnswers / _assessmentQuestions.length) * 100;
    bool isExcellent = percentage >= 80;
    bool isGood = percentage >= 60;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Results Header Card
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _progressAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isExcellent
                          ? [Color(0xFF10B981), Color(0xFF059669)]
                          : isGood
                          ? [Color(0xFF3B82F6), Color(0xFF1D4ED8)]
                          : [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: (isExcellent
                            ? Color(0xFF10B981)
                            : isGood
                            ? Color(0xFF3B82F6)
                            : Color(0xFFF59E0B))
                            .withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          isExcellent
                              ? Icons.emoji_events
                              : isGood
                              ? Icons.celebration
                              : Icons.psychology,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Assessment Complete!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'You answered $_correctAnswers out of ${_assessmentQuestions.length} scenarios correctly',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${percentage.toInt()}%',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isExcellent
                                    ? Color(0xFF059669)
                                    : isGood
                                    ? Color(0xFF1D4ED8)
                                    : Color(0xFFD97706),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Accuracy',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  isExcellent
                                      ? 'Excellent'
                                      : isGood
                                      ? 'Good Job'
                                      : 'Keep Learning',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isExcellent
                                        ? Color(0xFF059669)
                                        : isGood
                                        ? Color(0xFF1D4ED8)
                                        : Color(0xFFD97706),
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
              );
            },
          ),

          SizedBox(height: 32),

          // Detailed Review Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.analytics, color: Colors.white, size: 20),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Review Your Responses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: List.generate(_assessmentQuestions.length, (index) {
                      String statement = _assessmentQuestions[index]['statement'] ?? '';
                      String correctAnswer = _assessmentQuestions[index]['correct'] ?? '';
                      String userAnswer = _userAnswers[index] ?? '';
                      String feedback = _assessmentQuestions[index]['feedback'] ?? '';
                      bool isCorrect =
                          correctAnswer.toLowerCase() == userAnswer.toLowerCase();

                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: isCorrect ? Color(0xFFF0FDF4) : Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCorrect ? Color(0xFF22C55E) : Color(0xFFEF4444),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Color(0xFF22C55E).withOpacity(0.1)
                                    : Color(0xFFEF4444).withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: isCorrect ? Color(0xFF22C55E) : Color(0xFFEF4444),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      isCorrect ? Icons.check : Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Scenario ${index + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isCorrect ? Color(0xFF166534) : Color(0xFF991B1B),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isCorrect ? Color(0xFF22C55E) : Color(0xFFEF4444),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      isCorrect ? 'Correct' : 'Incorrect',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    statement,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF374151),
                                      height: 1.5,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey[200]!),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Your Answer',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                userAnswer.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF374151),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF22C55E).withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color(0xFF22C55E).withOpacity(0.2)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Correct Answer',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF166534),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                correctAnswer.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF166534),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (feedback.isNotEmpty) ...[
                                    SizedBox(height: 12),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3B82F6).withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Color(0xFF3B82F6).withOpacity(0.2)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.lightbulb_outline,
                                            color: Color(0xFF1D4ED8),
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              feedback,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF1E40AF),
                                                height: 1.4,
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
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Action Buttons
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _resetAssessment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: Color(0xFF3B82F6).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Retake Assessment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.5), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Return to Levels',
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
            ),
          ),
        ],
      ),
    );
  }
}