
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../json/JsonDataManager2.dart';
import '../json/JsonDataManager4.dart';
import '../json/JsonDataManager5.dart';
import '../models/JsonModel.dart';
import 'ActivityScreen.dart';

class LevelScenariosScreen extends StatefulWidget {
  final int levelId;
  final String levelName;
  final String moduleID;

  const LevelScenariosScreen({
    super.key,
    required this.levelId,
    required this.levelName, required this.moduleID,
  });

  @override
  State<LevelScenariosScreen> createState() => _LevelScenariosScreenState();
}

class _LevelScenariosScreenState extends State<LevelScenariosScreen>
 with TickerProviderStateMixin {
  PageController _pageController = PageController();
  List<Scenario> scenarios = [];
  int currentScenarioIndex = 0;
  Map<int, int> userAnswers = {}; // scenario_id -> selected_option
  bool isLoading = true;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // User data
  int userCoins = 0;
  int correctAnswersCount = 0;
  int totalAnswersCount = 0;

  late AnimationController _slideController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
    _loadScenarios();
    print('\n🎮 === LevelScenariosScreen STARTED ===');
    print('🎮 Received Parameters:');
    print('   📋 levelId: ${widget.levelId}');
    print('   📋 levelName: ${widget.levelName}');
    print('   📋 moduleID: ${widget.moduleID}');
    print('🎮 =====================================');

    print('Module detail are   ${widget.levelName  }  and ${widget.levelId}   and ${widget.moduleID}');
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DatabaseReference userRef = _database.child('Progress').child(user.uid);
        DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
          setState(() {
            userCoins = userData['coins'] ?? 0;
            correctAnswersCount = userData['correctAnswers'] ?? 0;
            totalAnswersCount = userData['totalAnswers'] ?? 0;
          });
        }
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  Future<void> _updateUserProgress(bool isCorrect, int scenarioId , String title) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DatabaseReference userRef = _database.child('Progress').child(user.uid);

      // Update counters
      totalAnswersCount++;
      if (isCorrect) {
        correctAnswersCount++;
        userCoins += 10; // Award 10 coins for correct answer
      }

      // Update user document using transaction for atomic updates
      await userRef.update({
        'coins': userCoins,
        'correctAnswers': correctAnswersCount,
        'totalAnswers': totalAnswersCount,
        'lastActivity': ServerValue.timestamp,
      });

      // Update scenario progress
      DatabaseReference scenarioRef = userRef
          .child('scenarios')
          .child(scenarioId.toString());

      DataSnapshot scenarioSnapshot = await scenarioRef.get();
      int currentAttempts = 0;
      if (scenarioSnapshot.exists) {
        Map<String, dynamic> scenarioData = Map<String, dynamic>.from(scenarioSnapshot.value as Map);
        currentAttempts = scenarioData['attempts'] ?? 0;
      }

      await scenarioRef.set({
        'scenarioId': scenarioId,
        'levelId': widget.levelId,
        'isCorrect': isCorrect,
        'timestamp': ServerValue.timestamp,
        'attempts': currentAttempts + 1,
      });

      // Update level progress
      await _updateLevelProgress(isCorrect);

      print('✅ User progress updated - Coins: $userCoins, Correct: $correctAnswersCount/$totalAnswersCount');
    } catch (e) {
      print('❌ Error updating user progress: $e');
    }
  }

  Future<void> _updateLevelProgress(bool isCorrect) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DatabaseReference levelRef = _database
          .child('Progress')
          .child(user.uid)
          .child('levels')
          .child(widget.levelId.toString());

      DataSnapshot levelSnapshot = await levelRef.get();
      Map<String, dynamic> levelData = {};

      if (levelSnapshot.exists) {
        levelData = Map<String, dynamic>.from(levelSnapshot.value as Map);
      }

      int levelCorrectAnswers = (levelData['correctAnswers'] ?? 0);
      int levelTotalAnswers = (levelData['totalAnswers'] ?? 0);

      if (isCorrect) {
        levelCorrectAnswers++;
      }
      levelTotalAnswers++;

      await levelRef.set({
        'levelId': widget.levelId,
        'levelName': widget.levelName,
        'correctAnswers': levelCorrectAnswers,
        'totalAnswers': levelTotalAnswers,
        'lastPlayed': ServerValue.timestamp,
        'isCompleted': levelTotalAnswers >= scenarios.length,
      });

    } catch (e) {
      print('❌ Error updating level progress: $e');
    }
  }

  Future<void> _awardLevelCompletionBonus(int stars) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      int bonusCoins = 0;
      switch (stars) {
        case 3:
          bonusCoins = 50; // 3 stars = 50 bonus coins
          break;
        case 2:
          bonusCoins = 30; // 2 stars = 30 bonus coins
          break;
        case 1:
          bonusCoins = 20; // 1 star = 20 bonus coins
          break;
        default:
          bonusCoins = 10; // Completion bonus = 10 coins
      }

      userCoins += bonusCoins;

      DatabaseReference userRef = _database.child('Progress').child(user.uid);

      // Get current values for incremental updates
      DataSnapshot snapshot = await userRef.get();
      Map<String, dynamic> userData = {};
      if (snapshot.exists) {
        userData = Map<String, dynamic>.from(snapshot.value as Map);
      }

      int currentLevelsCompleted = userData['levelsCompleted'] ?? 0;
      int currentStarsEarned = userData['starsEarned'] ?? 0;

      await userRef.update({
        'coins': userCoins,
        'levelsCompleted': currentLevelsCompleted + 1,
        'starsEarned': currentStarsEarned + stars,
      });

      print('🏆 Level completion bonus awarded: $bonusCoins coins');
    } catch (e) {
      print('❌ Error awarding level completion bonus: $e');
    }
  }

  // Real-time listener for coin updates
  void _setupCoinListener() {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference coinRef = _database
          .child('Progress')
          .child(user.uid)
          .child('coins');

      coinRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          setState(() {
            userCoins = event.snapshot.value as int? ?? 0;
          });
        }
      });
    }
  }

  void _loadScenarios() {
    try {
      print('\n🔧 Loading scenarios for module: ${widget.moduleID}');

      dynamic educationModule;

      // ✅ Use moduleID to determine which JsonDataManager to load
      switch (widget.moduleID) {
        case 'human_centered_mindset':
          print('📂 Loading JsonDataManager2 for human_centered_mindset');
          educationModule = JsonDataManager2.getModule();
          break;
        case 'ai_ethics':  // ✅ ADD THIS CASE
          print('📂 Loading JsonDataManager5 for ai_ethics');
          educationModule = JsonDataManager5.getModule();
          break;
        case 'ai_pedagogy':
          print('📂 Loading JsonDataManager4 for ai_pedagogy');
          educationModule = JsonDataManager4.getModule();
          break;

        default:
          print('❌ Unknown moduleID: ${widget.moduleID}, defaulting to JsonDataManager2');
          educationModule = JsonDataManager2.getModule();
          break;
      }

      print('🎯 Loaded module: ${educationModule?.moduleName}');

      final level = educationModule.getLevelByNumber(widget.levelId);

      if (level != null) {
        setState(() {
          scenarios = level.scenarios;
          isLoading = false;
        });
        print('📚 Loaded ${scenarios.length} scenarios for ${level.level}');
        print('✅ SUCCESS: Correct scenarios loaded for ${widget.moduleID}');

        // Setup real-time coin listener after scenarios are loaded
        _setupCoinListener();
      } else {
        print('❌ Level ${widget.levelId} not found in module ${educationModule?.moduleName}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading scenarios: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4A90E2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.levelName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Coins indicator with real-time updates
          StreamBuilder<DatabaseEvent>(
            stream: _auth.currentUser != null
                ? _database.child('Progress').child(_auth.currentUser!.uid).child('coins').onValue
                : null,
            builder: (context, snapshot) {
              int displayCoins = userCoins;
              if (snapshot.hasData && snapshot.data!.snapshot.exists) {
                displayCoins = snapshot.data!.snapshot.value as int? ?? 0;
              }

              return Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      displayCoins.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Progress indicator
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${currentScenarioIndex + 1}/${scenarios.length}',
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
            colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
          ),
        ),
        child: isLoading
            ? _buildLoadingView()
            : scenarios.isEmpty
            ? _buildEmptyView()
            : _buildGameplayView(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Loading scenarios...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.white.withOpacity(0.7),
          ),
          SizedBox(height: 16),
          Text(
            'No scenarios found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameplayView() {
    return Column(
      children: [
        // Progress bar
        _buildProgressBar(),

        // Scenarios ViewPager
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentScenarioIndex = index;
              });
            },
            itemCount: scenarios.length,
            itemBuilder: (context, index) {
              return _buildScenarioPage(scenarios[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      margin: EdgeInsets.all(16),
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: scenarios.isNotEmpty
            ? (currentScenarioIndex + 1) / scenarios.length
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

  Widget _buildScenarioPage(Scenario scenario, int index) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scenario Card
          _buildScenarioCard(scenario),
          SizedBox(height: 20),

          // Options
          _buildOptionsSection(scenario),
          SizedBox(height: 20),

          // Navigation buttons
          _buildNavigationButtons(scenario, index),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(Scenario scenario) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
          // Title
          Text(
            scenario.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          SizedBox(height: 12),

          // Description
          Text(
            scenario.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),

          // Question if exists
          if (scenario.question != null) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF4A90E2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFF4A90E2).withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: Color(0xFF4A90E2),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      scenario.question!,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF4A90E2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionsSection(Scenario scenario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your answer:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),

        ...scenario.options.asMap().entries.map((entry) {
          int optionIndex = entry.key + 1; // 1-based indexing
          String optionText = entry.value;
          bool isSelected = userAnswers[scenario.id] == optionIndex;

          return _buildOptionCard(
            scenario,
            optionIndex,
            optionText,
            isSelected,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOptionCard(
      Scenario scenario,
      int optionIndex,
      String optionText,
      bool isSelected,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectOption(scenario, optionIndex),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Color(0xFF4A90E2)
                    : Colors.white.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(0xFF4A90E2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Color(0xFF4A90E2)
                          : Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionIndex.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      color: isSelected ? Colors.black87 : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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

  Widget _buildNavigationButtons(Scenario scenario, int index) {
    bool hasAnswer = userAnswers.containsKey(scenario.id);
    bool isLastScenario = index == scenarios.length - 1;

    return Row(
      children: [
        // Previous button
        if (index > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: () => _goToPreviousScenario(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  SizedBox(width: 8),
                  Text('Previous', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

        if (index > 0) SizedBox(width: 12),

        // Next/Submit button
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: hasAnswer
                ? () => _handleNextAction(scenario, index)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: hasAnswer
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              foregroundColor: hasAnswer
                  ? Color(0xFF4A90E2)
                  : Colors.white.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastScenario ? 'Complete Level' : 'Check Answer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  isLastScenario ? Icons.check_circle : Icons.arrow_forward,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selectOption(Scenario scenario, int optionIndex) {
    setState(() {
      userAnswers[scenario.id] = optionIndex;
    });

    print('✅ Selected option $optionIndex for scenario ${scenario.id}');
  }

  void _goToPreviousScenario() {
    if (currentScenarioIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNextAction(Scenario scenario, int index , ) async {
    int userAnswer = userAnswers[scenario.id] ?? 0;
    bool isCorrect = userAnswer == scenario.correctAnswer;

    print('\n🎯 === ANSWER CHECK ===');
    print('Scenario: ${scenario.title}');
    print('User Answer: $userAnswer');
    print('Correct Answer: ${scenario.correctAnswer}');
    print('Is Correct: $isCorrect');
    print('========================\n');

    // Update Firebase Realtime Database with the answer
    await _updateUserProgress(isCorrect, scenario.id, scenario.title);

    // Show feedback and update UI
    setState(() {
      // UI will reflect the updated coin count
    });

    if (isCorrect) {
      // Show correct answer feedback
      _showAnswerFeedback(true, '+10 coins!');

      // Correct answer - go to next scenario or complete level
      if (index == scenarios.length - 1) {
        _completeLevel();
      } else {
        // Delay to show feedback
        await Future.delayed(Duration(milliseconds: 1500));
        _goToNextScenario();
      }
    } else {
      // Show wrong answer feedback
      _showAnswerFeedback(false, 'Try the activity to learn more!');

      // Delay to show feedback
      await Future.delayed(Duration(milliseconds: 1500));

      // Wrong answer - go to activity screen
      _navigateToActivityScreen(scenario);
    }
  }

  void _showAnswerFeedback(bool isCorrect, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                isCorrect ? 'Correct! $message' : 'Incorrect! $message',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _goToNextScenario() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToActivityScreen(Scenario scenario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityScreen(
          scenario: scenario,
          onActivityComplete: () {
            Navigator.pop(context); // Return from activity
            _goToNextScenario(); // Continue to next scenario
          },
        ),
      ),
    );
  }

  void _completeLevel() async {
    // Calculate score and stars
    int correctAnswers = 0;
    for (var scenario in scenarios) {
      int userAnswer = userAnswers[scenario.id] ?? 0;
      if (userAnswer == scenario.correctAnswer) {
        correctAnswers++;
      }
    }

    int stars = _calculateStars(correctAnswers, scenarios.length);

    // Award completion bonus
    await _awardLevelCompletionBonus(stars);

    print('🏆 Level Complete!');
    print('Correct: $correctAnswers/${scenarios.length}');
    print('Stars: $stars');
    print('Total Coins: $userCoins');

    // Show completion dialog
    _showCompletionDialog(correctAnswers, scenarios.length, stars);
  }

  int _calculateStars(int correct, int total) {
    double percentage = correct / total;
    if (percentage >= 0.9) return 3;
    if (percentage >= 0.7) return 2;
    if (percentage >= 0.5) return 1;
    return 0;
  }

  void _showCompletionDialog(int correct, int total, int stars) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.orange, size: 30),
            SizedBox(width: 12),
            Text('Level Complete!'),
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
            // Real-time coin display in dialog
            StreamBuilder<DatabaseEvent>(
              stream: _auth.currentUser != null
                  ? _database.child('Progress').child(_auth.currentUser!.uid).child('coins').onValue
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Total Coins: $displayCoins',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700],
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
              Navigator.pop(context); // Return to level selection
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
