//
// import 'package:artizen/widgets/scenario_card.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../dialoge/CompletionDialog.dart';
// import '../json/JsonDataManager1.dart';
// import '../json/JsonDataManager3.dart';
// import '../json/JsonDataManager4.dart';
// import '../json/JsonDataManager2.dart';
// import '../json/JsonDataManager5.dart';
// import '../models/JsonModel.dart';
// import '../widgets/EmptyScenariosView.dart';
// import '../widgets/GameplayView.dart';
// import '../widgets/LoadingScenariosView.dart';
// import '../widgets/ScenarioNavigationButtons.dart';
// import '../widgets/ScenarioProgressBar.dart';
// import '../widgets/option_card.dart';
// import 'ActivityScreen.dart';
//
// class LevelScenariosScreen extends StatefulWidget {
//   final int levelId;
//   final String levelName;
//   final String moduleID;
//
//
//   const LevelScenariosScreen({
//     super.key,
//     required this.levelId,
//     required this.levelName,
//     required this.moduleID,
//
//   });
//
//   @override
//   State<LevelScenariosScreen> createState() => _LevelScenariosScreenState();
// }
//
// class _LevelScenariosScreenState extends State<LevelScenariosScreen>
//     with TickerProviderStateMixin {
//   PageController _pageController = PageController();
//   List<Scenario> scenarios = [];
//   int currentScenarioIndex = 0;
//   Map<int, int> userAnswers = {}; // scenario_id -> selected_option
//   bool isLoading = true;
//
//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   // User data
//   int userCoins = 0;
//   int correctAnswersCount = 0;
//   int totalAnswersCount = 0;
//
//   late AnimationController _slideController;
//   late AnimationController _fadeController;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _loadUserData();
//     _loadScenarios();
//
//   }
//
//   void _initializeAnimations() {
//     _slideController = AnimationController(
//       duration: Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeController = AnimationController(
//       duration: Duration(milliseconds: 200),
//       vsync: this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _slideController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadUserData() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         // Load module-specific user data
//         DatabaseReference moduleRef = _database
//             .child('Progress')
//             .child(user.uid)
//             .child(widget.moduleID);
//
//         DataSnapshot snapshot = await moduleRef.get();
//
//         if (snapshot.exists) {
//           Map<String, dynamic> moduleData = Map<String, dynamic>.from(
//             snapshot.value as Map,
//           );
//           setState(() {
//             userCoins = moduleData['coins'] ?? 0;
//             correctAnswersCount = moduleData['correctAnswers'] ?? 0;
//             totalAnswersCount = moduleData['totalAnswers'] ?? 0;
//           });
//           print(
//             '✅ Loaded user data for module ${widget.moduleID}: coins=$userCoins, correct=$correctAnswersCount/$totalAnswersCount',
//           );
//         } else {
//           print(
//             '📝 No existing data for module ${widget.moduleID}, starting fresh',
//           );
//         }
//       }
//     } catch (e) {
//       print('❌ Error loading user data: $e');
//     }
//   }
//
//   Future<void> _updateUserProgress(bool isCorrect, int scenarioId, String title) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       int globalLevelId = _getGlobalLevelId(widget.levelId, widget.moduleID);
//
//       DatabaseReference moduleRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(widget.moduleID);
//
//       totalAnswersCount++;
//       if (isCorrect) {
//         correctAnswersCount++;
//         userCoins += 10;
//       }
//
//       await moduleRef.update({
//         'moduleName': _getModuleName(),
//         'coins': userCoins,
//         'correctAnswers': correctAnswersCount,
//         'totalAnswers': totalAnswersCount,
//         'lastActivity': ServerValue.timestamp,
//       });
//
//       // Store scenario progress with global level ID
//       DatabaseReference scenarioRef = moduleRef
//           .child('scenarios')
//           .child(scenarioId.toString());
//
//       DataSnapshot scenarioSnapshot = await scenarioRef.get();
//       int currentAttempts = 0;
//       if (scenarioSnapshot.exists) {
//         Map<String, dynamic> scenarioData = Map<String, dynamic>.from(
//           scenarioSnapshot.value as Map,
//         );
//         currentAttempts = scenarioData['attempts'] ?? 0;
//       }
//
//       await scenarioRef.set({
//         'scenarioId': scenarioId,
//         'scenarioTitle': title,
//         'levelId': globalLevelId, // Use global level ID for consistency
//         'uiLevelId': widget.levelId, // Keep UI level ID for reference
//         'levelName': widget.levelName,
//         'moduleId': widget.moduleID,
//         'isCorrect': isCorrect,
//         'timestamp': ServerValue.timestamp,
//         'attempts': currentAttempts + 1,
//       });
//
//       await _updateLevelProgress(isCorrect);
//
//       print('✅ Module ${widget.moduleID} progress updated - Global Level: $globalLevelId, UI Level: ${widget.levelId}');
//     } catch (e) {
//       print('❌ Error updating user progress: $e');
//     }
//   }
//   Future<void> _updateLevelProgress(bool isCorrect) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       // Use global level ID for consistent tracking
//       int globalLevelId = _getGlobalLevelId(widget.levelId, widget.moduleID);
//
//       DatabaseReference levelRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(widget.moduleID)
//           .child('levels')
//           .child(globalLevelId.toString()); // Use global level ID
//
//       DataSnapshot levelSnapshot = await levelRef.get();
//       Map<String, dynamic> levelData = {};
//
//       if (levelSnapshot.exists) {
//         levelData = Map<String, dynamic>.from(levelSnapshot.value as Map);
//       }
//
//       int levelCorrectAnswers = (levelData['correctAnswers'] ?? 0);
//       int levelTotalAnswers = (levelData['totalAnswers'] ?? 0);
//
//       if (isCorrect) {
//         levelCorrectAnswers++;
//       }
//       levelTotalAnswers++;
//
//       await levelRef.set({
//         'levelId': globalLevelId, // Store global level ID for consistency
//         'uiLevelId': widget.levelId, // Store UI level ID for reference
//         'levelName': widget.levelName,
//         'moduleId': widget.moduleID,
//         'correctAnswers': levelCorrectAnswers,
//         'totalAnswers': levelTotalAnswers,
//         'lastPlayed': ServerValue.timestamp,
//         'isCompleted': levelTotalAnswers >= scenarios.length,
//         'totalScenarios': scenarios.length,
//       });
//
//       print('✅ Level $globalLevelId (UI: ${widget.levelId}) progress updated in module ${widget.moduleID}');
//     } catch (e) {
//       print('❌ Error updating level progress: $e');
//     }
//   }
//   Future<void> _awardLevelCompletionBonus(int stars) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       int globalLevelId = _getGlobalLevelId(widget.levelId, widget.moduleID);
//
//       int bonusCoins = 0;
//       switch (stars) {
//         case 3: bonusCoins = 50; break;
//         case 2: bonusCoins = 30; break;
//         case 1: bonusCoins = 20; break;
//         default: bonusCoins = 10; break;
//       }
//
//       userCoins += bonusCoins;
//
//       DatabaseReference moduleRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(widget.moduleID);
//
//       // Get current module data
//       DataSnapshot snapshot = await moduleRef.get();
//       Map<String, dynamic> moduleData = {};
//       if (snapshot.exists) {
//         moduleData = Map<String, dynamic>.from(snapshot.value as Map);
//       }
//
//       // Count completed levels in this module by checking all level data
//       int completedLevelsCount = 0;
//       Map<String, dynamic> levelsData = moduleData['levels'] ?? {};
//
//       for (var levelEntry in levelsData.entries) {
//         Map<String, dynamic> levelInfo = Map<String, dynamic>.from(levelEntry.value as Map);
//         bool isCompleted = levelInfo['isCompleted'] ?? false;
//         if (isCompleted) {
//           completedLevelsCount++;
//         }
//       }
//
//       // Add the current level completion
//       completedLevelsCount++;
//
//       int currentStarsEarned = moduleData['starsEarned'] ?? 0;
//
//       await moduleRef.update({
//         'coins': userCoins,
//         'levelsCompleted': completedLevelsCount, // Accurate count of completed levels
//         'starsEarned': currentStarsEarned + stars,
//         'lastLevelCompleted': globalLevelId, // Use global level ID
//         'lastLevelCompletedName': widget.levelName,
//         'lastCompletionDate': ServerValue.timestamp,
//       });
//
//       print('🏆 Level completion bonus awarded:');
//       print('   Global Level ID: $globalLevelId');
//       print('   UI Level ID: ${widget.levelId}');
//       print('   Module: ${widget.moduleID}');
//       print('   Levels Completed in Module: $completedLevelsCount');
//       print('   Bonus Coins: $bonusCoins');
//     } catch (e) {
//       print('❌ Error awarding level completion bonus: $e');
//     }
//   }
//
//   void _setupCoinListener() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DatabaseReference coinRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(widget.moduleID)
//           .child('coins');
//
//       coinRef.onValue.listen((DatabaseEvent event) {
//         if (event.snapshot.exists) {
//           setState(() {
//             userCoins = event.snapshot.value as int? ?? 0;
//           });
//         }
//       });
//     }
//   }
//
//   String _getModuleName() {
//     switch (widget.moduleID) {
//       case 'human_centered_mindset':
//         return 'Human-Centered Mindset';
//
//       case 'ai_ethics':
//         return 'AI Ethics';
//
//       case 'ai_foundations_applications':
//         return 'AI Foundations and Applications';
//
//       case 'ai_pedagogy':
//         return 'AI Pedagogy';
//
//       case 'ai_professional_development':
//         return 'AI for Professional Development';
//
//       default:
//         return 'Unknown Module';
//     }
//   }
//
//
//
//
//   int _getGlobalLevelId(int uiLevelId, String moduleID) {
//     switch (moduleID) {
//       case 'human_centered_mindset':
//         return uiLevelId; // UI 1-3 → Global 1-3
//       case 'ai_ethics':
//         return uiLevelId + 3; // UI 1-3 → Global 4-6
//       case 'ai_foundations_applications':
//         return uiLevelId + 6; // UI 1-3 → Global 7-9
//       case 'ai_pedagogy':
//         return uiLevelId + 9; // UI 1-3 → Global 10-12
//       case 'ai_professional_development':
//         return uiLevelId + 12; // UI 1-3 → Global 13-15
//       default:
//         return uiLevelId;
//     }
//   }
//
//   void _loadScenarios() {
//     try {
//       print('\n🔧 Loading scenarios for module: ${widget.moduleID}');
//       print('🔧 UI levelId: ${widget.levelId}');
//
//       // Convert UI level ID to global level ID for proper tracking
//       int globalLevelId = _getGlobalLevelId(widget.levelId, widget.moduleID);
//       print('🔧 Global levelId: $globalLevelId');
//
//       dynamic educationModule;
//
//       // Load the appropriate JSON manager
//       switch (widget.moduleID) {
//         case 'human_centered_mindset':
//           print('📂 Loading JsonDataManager1 for human_centered_mindset');
//           educationModule = JsonDataManager1.getModule();
//           break;
//
//         case 'ai_ethics':
//           print('📂 Loading JsonDataManager2 for ai_ethics');
//           educationModule = JsonDataManager2.getModule();
//           break;
//
//         case 'ai_foundations_applications':
//           print('📂 Loading JsonDataManager3 for ai_foundations_applications');
//           educationModule = JsonDataManager3.getModule();
//           break;
//
//         case 'ai_pedagogy':
//           print('📂 Loading JsonDataManager4 for ai_pedagogy');
//           educationModule = JsonDataManager4.getModule();
//           break;
//
//         case 'ai_professional_development':
//           print('📂 Loading JsonDataManager5 for ai_professional_development');
//           educationModule = JsonDataManager5.getModule();
//           break;
//
//         default:
//           print('❌ Unknown moduleID: ${widget.moduleID}');
//           setState(() {
//             isLoading = false;
//           });
//           return;
//       }
//
//       print('🎯 Loaded module: ${educationModule?.moduleName}');
//
//       // Get level by UI index (0-based)
//       int levelIndex = widget.levelId - 1; // Convert 1-based to 0-based
//
//       if (levelIndex >= 0 && levelIndex < educationModule.levels.length) {
//         final level = educationModule.levels[levelIndex];
//
//         setState(() {
//           scenarios = level.scenarios;
//           isLoading = false;
//         });
//
//         print('📚 Loaded ${scenarios.length} scenarios for ${level.level}');
//         print('✅ SUCCESS: Correct scenarios loaded for ${widget.moduleID}');
//
//         // Debug: Print scenario ID range
//         if (scenarios.isNotEmpty) {
//           print('🎯 Scenario ID range: ${scenarios.first.id} - ${scenarios.last.id}');
//         }
//
//         _setupCoinListener();
//       } else {
//         print('❌ Level index $levelIndex out of range for module ${educationModule?.moduleName}');
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('❌ Error loading scenarios: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF4A90E2),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           widget.levelName,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           // Coins indicator with real-time updates for the specific module
//           StreamBuilder<DatabaseEvent>(
//             stream:
//                 _auth.currentUser != null
//                     ? _database
//                         .child('Progress')
//                         .child(_auth.currentUser!.uid)
//                         .child(widget.moduleID)
//                         .child('coins')
//                         .onValue
//                     : null,
//             builder: (context, snapshot) {
//               int displayCoins = userCoins;
//               if (snapshot.hasData && snapshot.data!.snapshot.exists) {
//                 displayCoins = snapshot.data!.snapshot.value as int? ?? 0;
//               }
//
//               return Container(
//                 margin: EdgeInsets.only(right: 8),
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.amber.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.monetization_on, color: Colors.white, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       displayCoins.toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           // Progress indicator
//           Container(
//             margin: EdgeInsets.only(right: 16),
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '${currentScenarioIndex + 1}/${scenarios.length}',
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
//             colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
//           ),
//         ),
//         child:
//             isLoading
//                 ? LoadingScenariosView()
//                 : scenarios.isEmpty
//                 ? EmptyScenariosView()
//
//                 :GameplayView(
//               scenarios: scenarios,
//               pageController: _pageController,
//               currentScenarioIndex: currentScenarioIndex,
//               onPageChanged: (index) {
//                 setState(() {
//                   currentScenarioIndex = index;
//                 });
//               },
//               scenarioPageBuilder: _buildScenarioPage,
//               progressBar: ScenarioProgressBar(
//                 currentIndex: currentScenarioIndex,
//                 total: scenarios.length,
//               ),
//             ),
//
//       ),
//     );
//   }
//
//
//
//   Widget _buildScenarioPage(Scenario scenario, int index) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Scenario Card
//           ScenarioCard(scenario: scenario),
//
//           // _buildScenarioCard(scenario),
//           SizedBox(height: 20),
//
//           // Options
//           _buildOptionsSection(scenario),
//           SizedBox(height: 20),
//
//           // Navigation buttons
//           ScenarioNavigationButtons(
//             scenario: scenario,
//             index: index,
//             totalScenarios: scenarios.length,
//             hasAnswer: userAnswers.containsKey(scenario.id),
//             onPrevious: _goToPreviousScenario,
//             onNext: () => _handleNextAction(scenario, index),
//           )
//
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildOptionsSection(Scenario scenario) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Choose your answer:',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 12),
//
//         ...scenario.options.asMap().entries.map((entry) {
//           int optionIndex = entry.key + 1; // 1-based indexing
//           String optionText = entry.value;
//           bool isSelected = userAnswers[scenario.id] == optionIndex;
//
//           return OptionCard(
//             scenario: scenario,
//             optionIndex: optionIndex,
//             optionText:  optionText,
//             isSelected: isSelected,
//             onSelect: _selectOption,
//           );
//
//         }).toList(),
//       ],
//     );
//   }
//
//
//
//
//   void _selectOption(Scenario scenario, int optionIndex) {
//     setState(() {
//       userAnswers[scenario.id] = optionIndex;
//     });
//
//     print('✅ Selected option $optionIndex for scenario ${scenario.id}');
//   }
//
//   void _goToPreviousScenario() {
//     if (currentScenarioIndex > 0) {
//       _pageController.previousPage(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void _handleNextAction(Scenario scenario, int index) async {
//     int userAnswer = userAnswers[scenario.id] ?? 0;
//     bool isCorrect = userAnswer == scenario.correctAnswer;
//
//     print('\n🎯 === ANSWER CHECK ===');
//     print('Module: ${widget.moduleID}');
//     print('Scenario: ${scenario.title}');
//     print('User Answer: $userAnswer');
//     print('Correct Answer: ${scenario.correctAnswer}');
//     print('Is Correct: $isCorrect');
//     print('========================\n');
//
//     // Update Firebase Realtime Database with the answer (module-specific)
//     await _updateUserProgress(isCorrect, scenario.id, scenario.title);
//
//     // Show feedback and update UI
//     setState(() {
//       // UI will reflect the updated coin count
//     });
//
//     if (isCorrect) {
//       // Show correct answer feedback
//       _showAnswerFeedback(true, '+10 coins!');
//
//       // Correct answer - go to next scenario or complete level
//       if (index == scenarios.length - 1) {
//         _completeLevel();
//       } else {
//         // Delay to show feedback
//         await Future.delayed(Duration(milliseconds: 1500));
//         _goToNextScenario();
//       }
//     } else {
//       // Show wrong answer feedback
//       _showAnswerFeedback(false, 'Try the activity to learn more!');
//
//       // Delay to show feedback
//       await Future.delayed(Duration(milliseconds: 1500));
//
//       // Wrong answer - go to activity screen
//       _navigateToActivityScreen(scenario);
//     }
//   }
//
//   void _showAnswerFeedback(bool isCorrect, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isCorrect ? Icons.check_circle : Icons.cancel,
//               color: Colors.white,
//               size: 20,
//             ),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 isCorrect ? 'Correct! $message' : 'Incorrect! $message',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: isCorrect ? Colors.green : Colors.red,
//         duration: Duration(milliseconds: 1500),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   void _goToNextScenario() {
//     _pageController.nextPage(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _navigateToActivityScreen(Scenario scenario) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => EnhancedActivityScreen(
//               scenario: scenario,
//               onActivityComplete: () {
//                 Navigator.pop(context); // Return from activity
//                 _goToNextScenario(); // Continue to next scenario
//               },
//               moduleID: widget.moduleID,
//             ),
//       ),
//     );
//   }
//
//   void _completeLevel() async {
//     // Calculate score and stars
//     int correctAnswers = 0;
//     for (var scenario in scenarios) {
//       int userAnswer = userAnswers[scenario.id] ?? 0;
//       if (userAnswer == scenario.correctAnswer) {
//         correctAnswers++;
//       }
//     }
//
//     int stars = _calculateStars(correctAnswers, scenarios.length);
//
//     // Award completion bonus (module-specific)
//     await _awardLevelCompletionBonus(stars);
//
//     print('🏆 Level Complete for module ${widget.moduleID}!');
//     print('Correct: $correctAnswers/${scenarios.length}');
//     print('Stars: $stars');
//     print('Total Coins in ${widget.moduleID}: $userCoins');
//
//     // Show completion dialog
//     _showCompletionDialog(correctAnswers, scenarios.length, stars);
//   }
//
//   int _calculateStars(int correct, int total) {
//     double percentage = correct / total;
//     if (percentage >= 0.9) return 3;
//     if (percentage >= 0.7) return 2;
//     if (percentage >= 0.5) return 1;
//     return 0;
//   }
//
//   void _showCompletionDialog(int correct, int total, int stars) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => CompletionDialog(
//         correct: correct,
//         total: total,
//         stars: stars,
//         moduleName: _getModuleName(),
//         moduleID: widget.moduleID,
//         userCoins: userCoins,
//         auth: _auth,
//         database: _database,
//       ),
//     );
//   }
// }
import 'package:artizen/widgets/scenario_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../data/ProgressManager.dart';
import '../dialoge/CompletionDialog.dart';
import '../json/JsonDataManager1.dart';
import '../json/JsonDataManager3.dart';
import '../json/JsonDataManager4.dart';
import '../json/JsonDataManager2.dart';
import '../json/JsonDataManager5.dart';
import '../models/JsonModel.dart';
import '../widgets/EmptyScenariosView.dart';
import '../widgets/GameplayView.dart';
import '../widgets/LoadingScenariosView.dart';
import '../widgets/ScenarioNavigationButtons.dart';
import '../widgets/ScenarioProgressBar.dart';
import '../widgets/option_card.dart';
import 'ActivityScreen.dart';

class LevelScenariosScreen extends StatefulWidget {
  final int levelId;
  final String levelName;
  final String moduleID;

  const LevelScenariosScreen({
    super.key,
    required this.levelId,
    required this.levelName,
    required this.moduleID,
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

  // Progress Manager
  late ProgressManager _progressManager;

  // User data
  Map<String, dynamic> userData = {
    'coins': 0,
    'correctAnswers': 0,
    'totalAnswers': 0,
  };

  late AnimationController _slideController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _initializeProgressManager();
    _initializeAnimations();
    _loadUserData();
    _loadScenarios();
  }

  void _initializeProgressManager() {
    _progressManager = ProgressManager(
      auth: _auth,
      database: _database,
      moduleID: widget.moduleID,
      moduleName: _getModuleName(),
      levelId: widget.levelId,
      levelName: widget.levelName,
    );
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
      Map<String, dynamic> loadedData = await _progressManager.loadUserData();
      setState(() {
        userData = loadedData;
      });
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  String _getModuleName() {
    switch (widget.moduleID) {
      case 'human_centered_mindset':
        return 'Human-Centered Mindset';
      case 'ai_ethics':
        return 'AI Ethics';
      case 'ai_foundations_applications':
        return 'AI Foundations and Applications';
      case 'ai_pedagogy':
        return 'AI Pedagogy';
      case 'ai_professional_development':
        return 'AI for Professional Development';
      default:
        return 'Unknown Module';
    }
  }

  void _loadScenarios() {
    try {
      print('\n🔧 Loading scenarios for module: ${widget.moduleID}');
      print('🔧 UI levelId: ${widget.levelId}');

      dynamic educationModule;

      // Load the appropriate JSON manager
      switch (widget.moduleID) {
        case 'human_centered_mindset':
          print('📂 Loading JsonDataManager1 for human_centered_mindset');
          educationModule = JsonDataManager1.getModule();
          break;

        case 'ai_ethics':
          print('📂 Loading JsonDataManager2 for ai_ethics');
          educationModule = JsonDataManager2.getModule();
          break;

        case 'ai_foundations_applications':
          print('📂 Loading JsonDataManager3 for ai_foundations_applications');
          educationModule = JsonDataManager3.getModule();
          break;

        case 'ai_pedagogy':
          print('📂 Loading JsonDataManager4 for ai_pedagogy');
          educationModule = JsonDataManager4.getModule();
          break;

        case 'ai_professional_development':
          print('📂 Loading JsonDataManager5 for ai_professional_development');
          educationModule = JsonDataManager5.getModule();
          break;

        default:
          print('❌ Unknown moduleID: ${widget.moduleID}');
          setState(() {
            isLoading = false;
          });
          return;
      }

      print('🎯 Loaded module: ${educationModule?.moduleName}');

      // Get level by UI index (0-based)
      int levelIndex = widget.levelId - 1; // Convert 1-based to 0-based

      if (levelIndex >= 0 && levelIndex < educationModule.levels.length) {
        final level = educationModule.levels[levelIndex];

        setState(() {
          scenarios = level.scenarios;
          isLoading = false;
        });

        print('📚 Loaded ${scenarios.length} scenarios for ${level.level}');
        print('✅ SUCCESS: Correct scenarios loaded for ${widget.moduleID}');

        // Debug: Print scenario ID range
        if (scenarios.isNotEmpty) {
          print('🎯 Scenario ID range: ${scenarios.first.id} - ${scenarios.last.id}');
        }
      } else {
        print('❌ Level index $levelIndex out of range for module ${educationModule?.moduleName}');
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
          // Coins indicator with real-time updates using ProgressManager
          StreamBuilder<DatabaseEvent>(
            stream: _progressManager.getCoinStream(),
            builder: (context, snapshot) {
              int displayCoins = userData['coins'] ?? 0;
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
            ? LoadingScenariosView()
            : scenarios.isEmpty
            ? EmptyScenariosView()
            : GameplayView(
          scenarios: scenarios,
          pageController: _pageController,
          currentScenarioIndex: currentScenarioIndex,
          onPageChanged: (index) {
            setState(() {
              currentScenarioIndex = index;
            });
          },
          scenarioPageBuilder: _buildScenarioPage,
          progressBar: ScenarioProgressBar(
            currentIndex: currentScenarioIndex,
            total: scenarios.length,
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
          ScenarioCard(scenario: scenario),
          SizedBox(height: 20),

          // Options
          _buildOptionsSection(scenario),
          SizedBox(height: 20),

          // Navigation buttons
          ScenarioNavigationButtons(
            scenario: scenario,
            index: index,
            totalScenarios: scenarios.length,
            hasAnswer: userAnswers.containsKey(scenario.id),
            onPrevious: _goToPreviousScenario,
            onNext: () => _handleNextAction(scenario, index),
          )
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

          return OptionCard(
            scenario: scenario,
            optionIndex: optionIndex,
            optionText: optionText,
            isSelected: isSelected,
            onSelect: _selectOption,
          );
        }).toList(),
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

  void _handleNextAction(Scenario scenario, int index) async {
    int userAnswer = userAnswers[scenario.id] ?? 0;
    bool isCorrect = userAnswer == scenario.correctAnswer;

    print('\n🎯 === ANSWER CHECK ===');
    print('Module: ${widget.moduleID}');
    print('Scenario: ${scenario.title}');
    print('User Answer: $userAnswer');
    print('Correct Answer: ${scenario.correctAnswer}');
    print('Is Correct: $isCorrect');
    print('========================\n');

    // Update progress using ProgressManager
    int newCoinCount = await _progressManager.updateScenarioProgress(
      scenario: scenario,
      isCorrect: isCorrect,
      currentUserData: userData,
    );

    // Update level progress
    await _progressManager.updateLevelProgress(
      isCorrect: isCorrect,
      totalScenarios: scenarios.length,
    );

    // Update local userData
    setState(() {
      userData['coins'] = newCoinCount;
      userData['totalAnswers'] = userData['totalAnswers'] + 1;
      if (isCorrect &&
          !(userAnswers.containsKey(scenario.id) &&
              userAnswers[scenario.id] == scenario.correctAnswer)) {
        userData['correctAnswers'] = userData['correctAnswers'] + 1;
      }
    });

    if (isCorrect) {
      // Show correct answer feedback with dynamic coin message
      num coinsEarned = newCoinCount - (userData['coins'] - newCoinCount);
      String coinMessage = coinsEarned > 0 ? '+$coinsEarned coins!' : 'Already completed!';
      _showAnswerFeedback(true, coinMessage);

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        builder: (context) => EnhancedActivityScreen(
          scenario: scenario,
          onActivityComplete: () {
            Navigator.pop(context); // Return from activity
            _goToNextScenario(); // Continue to next scenario
          },
          moduleID: widget.moduleID,
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

    // Award completion bonus using ProgressManager
    int finalCoinCount = await _progressManager.awardLevelCompletionBonus(
      stars: stars,
      currentCoins: userData['coins'],
    );

    // Update local coin count
    setState(() {
      userData['coins'] = finalCoinCount;
    });

    print('🏆 Level Complete for module ${widget.moduleID}!');
    print('Correct: $correctAnswers/${scenarios.length}');
    print('Stars: $stars');
    print('Total Coins in ${widget.moduleID}: $finalCoinCount');

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
      builder: (context) => CompletionDialog(
        correct: correct,
        total: total,
        stars: stars,
        moduleName: _getModuleName(),
        moduleID: widget.moduleID,
        userCoins: userData['coins'],
        auth: _auth,
        database: _database,
      ),
    );
  }
}