  // //
  // // import 'package:artizen/widgets/scenario_card.dart';
  // // import 'package:flutter/material.dart';
  // // import 'package:firebase_auth/firebase_auth.dart';
  // // import 'package:firebase_database/firebase_database.dart';
  // // import '../data/ProgressManager.dart';
  // // import '../dialoge/CompletionDialog.dart';
  // // import '../json/JsonDataManager1.dart';
  // // import '../json/JsonDataManager3.dart';
  // // import '../json/JsonDataManager4.dart';
  // // import '../json/JsonDataManager2.dart';
  // // import '../json/JsonDataManager5.dart';
  // // import '../models/JsonModel.dart';
  // // import '../widgets/EmptyScenariosView.dart';
  // // import '../widgets/GameplayView.dart';
  // // import '../widgets/LoadingScenariosView.dart';
  // // import '../widgets/ScenarioNavigationButtons.dart';
  // // import '../widgets/ScenarioProgressBar.dart';
  // // import '../widgets/option_card.dart';
  // // import 'ActivityScreen.dart';
  // //
  // // class LevelScenariosScreen extends StatefulWidget {
  // //   final int levelId;
  // //   final String levelName;
  // //   final String moduleID;
  // //
  // //   const LevelScenariosScreen({
  // //     super.key,
  // //     required this.levelId,
  // //     required this.levelName,
  // //     required this.moduleID,
  // //   });
  // //
  // //   @override
  // //   State<LevelScenariosScreen> createState() => _LevelScenariosScreenState();
  // // }
  // //
  // // class _LevelScenariosScreenState extends State<LevelScenariosScreen>
  // //     with TickerProviderStateMixin {
  // //   final PageController _pageController = PageController();
  // //   List<Scenario> scenarios = [];
  // //   int currentScenarioIndex = 0;
  // //   Map<int, int> userAnswers = {}; // scenario_id -> selected_option
  // //
  // //   // New: Store feedback text for each scenario
  // //   Map<int, String> userFeedback = {}; // scenario_id -> feedback text
  // //   Map<int, TextEditingController> feedbackControllers = {}; // Controllers for text fields
  // //
  // //   bool isLoading = true;
  // //
  // //   // Firebase instances
  // //   final FirebaseAuth _auth = FirebaseAuth.instance;
  // //   final DatabaseReference _database = FirebaseDatabase.instance.ref();
  // //
  // //   // Progress Manager
  // //   late ProgressManager _progressManager;
  // //
  // //   // User data
  // //   Map<String, dynamic> userData = {
  // //     'coins': 0,
  // //     'correctAnswers': 0,
  // //     'totalAnswers': 0,
  // //   };
  // //
  // //   late AnimationController _slideController;
  // //   late AnimationController _fadeController;
  // //
  // //   @override
  // //   void initState() {
  // //     super.initState();
  // //     _initializeProgressManager();
  // //     _initializeAnimations();
  // //     _loadUserData();
  // //     _loadScenarios();
  // //   }
  // //
  // //   void _initializeProgressManager() {
  // //     _progressManager = ProgressManager(
  // //       auth: _auth,
  // //       database: _database,
  // //       moduleID: widget.moduleID,
  // //       moduleName: _getModuleName(),
  // //       levelId: widget.levelId,
  // //       levelName: widget.levelName,
  // //     );
  // //   }
  // //
  // //   void _initializeAnimations() {
  // //     _slideController = AnimationController(
  // //       duration: Duration(milliseconds: 300),
  // //       vsync: this,
  // //     );
  // //     _fadeController = AnimationController(
  // //       duration: Duration(milliseconds: 200),
  // //       vsync: this,
  // //     );
  // //   }
  // //
  // //   @override
  // //   void dispose() {
  // //     _pageController.dispose();
  // //     _slideController.dispose();
  // //     _fadeController.dispose();
  // //
  // //     // Dispose text controllers
  // //     for (var controller in feedbackControllers.values) {
  // //       controller.dispose();
  // //     }
  // //
  // //     super.dispose();
  // //   }
  // //
  // //   Future<void> _loadUserData() async {
  // //     try {
  // //       Map<String, dynamic> loadedData = await _progressManager.loadUserData();
  // //       setState(() {
  // //         userData = loadedData;
  // //       });
  // //     } catch (e) {
  // //       print('❌ Error loading user data: $e');
  // //     }
  // //   }
  // //
  // //   String _getModuleName() {
  // //     switch (widget.moduleID) {
  // //       case 'human_centered_mindset':
  // //         return 'Human-Centered Mindset';
  // //       case 'ai_ethics':
  // //         return 'AI Ethics';
  // //       case 'ai_foundations_applications':
  // //         return 'AI Foundations and Applications';
  // //       case 'ai_pedagogy':
  // //         return 'AI Pedagogy';
  // //       case 'ai_professional_development':
  // //         return 'AI for Professional Development';
  // //       default:
  // //         return 'Unknown Module';
  // //     }
  // //   }
  // //
  // //   void _loadScenarios() {
  // //     try {
  // //       print('\n🔧 Loading scenarios for module: ${widget.moduleID}');
  // //       print('🔧 UI levelId: ${widget.levelId}');
  // //
  // //       dynamic educationModule;
  // //
  // //       // Load the appropriate JSON manager
  // //       switch (widget.moduleID) {
  // //         case 'human_centered_mindset':
  // //           print('📂 Loading JsonDataManager1 for human_centered_mindset');
  // //           educationModule = JsonDataManager1.getModule();
  // //           break;
  // //
  // //         case 'ai_ethics':
  // //           print('📂 Loading JsonDataManager2 for ai_ethics');
  // //           educationModule = JsonDataManager2.getModule();
  // //           break;
  // //
  // //         case 'ai_foundations_applications':
  // //           print('📂 Loading JsonDataManager3 for ai_foundations_applications');
  // //           educationModule = JsonDataManager3.getModule();
  // //           break;
  // //
  // //         case 'ai_pedagogy':
  // //           print('📂 Loading JsonDataManager4 for ai_pedagogy');
  // //           educationModule = JsonDataManager4.getModule();
  // //           break;
  // //
  // //         case 'ai_professional_development':
  // //           print('📂 Loading JsonDataManager5 for ai_professional_development');
  // //           educationModule = JsonDataManager5.getModule();
  // //           break;
  // //
  // //         default:
  // //           print('❌ Unknown moduleID: ${widget.moduleID}');
  // //           setState(() {
  // //             isLoading = false;
  // //           });
  // //           return;
  // //       }
  // //
  // //       print('🎯 Loaded module: ${educationModule?.moduleName}');
  // //
  // //       // Get level by UI index (0-based)
  // //       int levelIndex = widget.levelId - 1; // Convert 1-based to 0-based
  // //
  // //       if (levelIndex >= 0 && levelIndex < educationModule.levels.length) {
  // //         final level = educationModule.levels[levelIndex];
  // //
  // //         setState(() {
  // //           scenarios = level.scenarios;
  // //           isLoading = false;
  // //         });
  // //
  // //         // Initialize text controllers for each scenario
  // //         for (var scenario in scenarios) {
  // //           feedbackControllers[scenario.id] = TextEditingController();
  // //         }
  // //
  // //         print('📚 Loaded ${scenarios.length} scenarios for ${level.level}');
  // //         print('✅ SUCCESS: Correct scenarios loaded for ${widget.moduleID}');
  // //
  // //         // Debug: Print scenario ID range
  // //         if (scenarios.isNotEmpty) {
  // //           print('🎯 Scenario ID range: ${scenarios.first.id} - ${scenarios.last.id}');
  // //         }
  // //       } else {
  // //         print('❌ Level index $levelIndex out of range for module ${educationModule?.moduleName}');
  // //         setState(() {
  // //           isLoading = false;
  // //         });
  // //       }
  // //     } catch (e) {
  // //       print('❌ Error loading scenarios: $e');
  // //       setState(() {
  // //         isLoading = false;
  // //       });
  // //     }
  // //   }
  // //
  // //   @override
  // //   Widget build(BuildContext context) {
  // //     return Scaffold(
  // //       backgroundColor: Color(0xFF4A90E2),
  // //       appBar: AppBar(
  // //         backgroundColor: Colors.transparent,
  // //         elevation: 0,
  // //         leading: IconButton(
  // //           icon: Icon(Icons.arrow_back, color: Colors.white),
  // //           onPressed: () => Navigator.pop(context),
  // //         ),
  // //         title: Text(
  // //           textAlign: TextAlign.start,
  // //           widget.levelName,
  // //           style: TextStyle(
  // //             color: Colors.white,
  // //             fontSize: 18,
  // //             fontWeight: FontWeight.bold,
  // //           ),
  // //         ),
  // //         actions: [
  // //           // Coins indicator with real-time updates using ProgressManager
  // //           StreamBuilder<DatabaseEvent>(
  // //             stream: _progressManager.getCoinStream(),
  // //             builder: (context, snapshot) {
  // //               int displayCoins = userData['coins'] ?? 0;
  // //               if (snapshot.hasData && snapshot.data!.snapshot.exists) {
  // //                 displayCoins = snapshot.data!.snapshot.value as int? ?? 0;
  // //               }
  // //
  // //               return Container(
  // //                 margin: EdgeInsets.only(right: 8),
  // //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  // //                 decoration: BoxDecoration(
  // //                   color: Colors.amber.withOpacity(0.9),
  // //                   borderRadius: BorderRadius.circular(20),
  // //                 ),
  // //                 child: Row(
  // //                   mainAxisSize: MainAxisSize.min,
  // //                   children: [
  // //                     Icon(Icons.monetization_on, color: Colors.white, size: 16),
  // //                     SizedBox(width: 4),
  // //                     Text(
  // //                       displayCoins.toString(),
  // //                       style: TextStyle(
  // //                         color: Colors.white,
  // //                         fontSize: 14,
  // //                         fontWeight: FontWeight.bold,
  // //                       ),
  // //                     ),
  // //                   ],
  // //                 ),
  // //               );
  // //             },
  // //           ),
  // //           // Progress indicator
  // //           Container(
  // //             margin: EdgeInsets.only(right: 16),
  // //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  // //             decoration: BoxDecoration(
  // //               color: Colors.white.withOpacity(0.2),
  // //               borderRadius: BorderRadius.circular(20),
  // //             ),
  // //             child: Text(
  // //               '${currentScenarioIndex + 1}/${scenarios.length}',
  // //               style: TextStyle(
  // //                 color: Colors.white,
  // //                 fontSize: 14,
  // //                 fontWeight: FontWeight.w500,
  // //               ),
  // //             ),
  // //           ),
  // //         ],
  // //       ),
  // //
  // //       body: Container(
  // //         decoration: BoxDecoration(
  // //           gradient: LinearGradient(
  // //             begin: Alignment.topCenter,
  // //             end: Alignment.bottomCenter,
  // //             colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
  // //           ),
  // //         ),
  // //         child: isLoading
  // //             ? LoadingScenariosView()
  // //             : scenarios.isEmpty
  // //             ? EmptyScenariosView()
  // //             : GameplayView(
  // //           scenarios: scenarios,
  // //           pageController: _pageController,
  // //           currentScenarioIndex: currentScenarioIndex,
  // //           onPageChanged: (index) {
  // //             setState(() {
  // //               currentScenarioIndex = index;
  // //             });
  // //           },
  // //           scenarioPageBuilder: _buildScenarioPage,
  // //           progressBar: ScenarioProgressBar(
  // //             currentIndex: currentScenarioIndex,
  // //             total: scenarios.length,
  // //           ),
  // //         ),
  // //       ),
  // //     );
  // //   }
  // //
  // //   Widget _buildScenarioPage(Scenario scenario, int index) {
  // //     return SingleChildScrollView(
  // //       padding: EdgeInsets.all(16),
  // //       child: Column(
  // //         crossAxisAlignment: CrossAxisAlignment.start,
  // //         children: [
  // //           // Scenario Card
  // //           ScenarioCard(scenario: scenario),
  // //           SizedBox(height: 20),
  // //
  // //           // Options
  // //           _buildOptionsSection(scenario),
  // //           SizedBox(height: 20),
  // //
  // //           // Feedback Section - Only show if an answer is selected
  // //           if (userAnswers.containsKey(scenario.id))
  // //             _buildFeedbackSection(scenario),
  // //
  // //           SizedBox(height: 20),
  // //
  // //           // Navigation buttons
  // //           ScenarioNavigationButtons(
  // //             scenario: scenario,
  // //             index: index,
  // //             totalScenarios: scenarios.length,
  // //             hasAnswer: userAnswers.containsKey(scenario.id),
  // //             onPrevious: _goToPreviousScenario,
  // //             onNext: () => _handleNextAction(scenario, index),
  // //           )
  // //         ],
  // //       ),
  // //     );
  // //   }
  // //
  // //   Widget _buildOptionsSection(Scenario scenario) {
  // //     return Column(
  // //       crossAxisAlignment: CrossAxisAlignment.start,
  // //       children: [
  // //         Text(
  // //           'Choose your answer:',
  // //           style: TextStyle(
  // //             color: Colors.white,
  // //             fontSize: 18,
  // //             fontWeight: FontWeight.bold,
  // //           ),
  // //         ),
  // //         SizedBox(height: 12),
  // //
  // //         ...scenario.options.asMap().entries.map((entry) {
  // //           int optionIndex = entry.key + 1; // 1-based indexing
  // //           String optionText = entry.value;
  // //           bool isSelected = userAnswers[scenario.id] == optionIndex;
  // //
  // //           return OptionCard(
  // //             scenario: scenario,
  // //             optionIndex: optionIndex,
  // //             optionText: optionText,
  // //             isSelected: isSelected,
  // //             onSelect: _selectOption,
  // //           );
  // //         }),
  // //       ],
  // //     );
  // //   }
  // //
  // //   Widget _buildFeedbackSection(Scenario scenario) {
  // //     return Container(
  // //       padding: EdgeInsets.all(16),
  // //       decoration: BoxDecoration(
  // //         color: Colors.white.withOpacity(0.15),
  // //         borderRadius: BorderRadius.circular(12),
  // //         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
  // //       ),
  // //       child: Column(
  // //         crossAxisAlignment: CrossAxisAlignment.start,
  // //         children: [
  // //           Row(
  // //             children: [
  // //               Icon(Icons.feedback_outlined, color: Colors.white, size: 20),
  // //               SizedBox(width: 8),
  // //               Text(
  // //                 'Share your thoughts',
  // //                 style: TextStyle(
  // //                   color: Colors.white,
  // //                   fontSize: 16,
  // //                   fontWeight: FontWeight.bold,
  // //                 ),
  // //               ),
  // //             ],
  // //           ),
  // //           SizedBox(height: 4),
  // //           Text(
  // //             'Why did you choose this option? (Optional)',
  // //             style: TextStyle(
  // //               color: Colors.white.withOpacity(0.8),
  // //               fontSize: 14,
  // //             ),
  // //           ),
  // //           SizedBox(height: 12),
  // //
  // //           // Feedback input field
  // //           Container(
  // //             decoration: BoxDecoration(
  // //               color: Colors.white.withOpacity(0.1),
  // //               borderRadius: BorderRadius.circular(8),
  // //               border: Border.all(
  // //                 color: Colors.white.withOpacity(0.3),
  // //                 width: 1,
  // //               ),
  // //             ),
  // //             child: TextField(
  // //               controller: feedbackControllers[scenario.id],
  // //               onChanged: (value) {
  // //                 userFeedback[scenario.id] = value;
  // //               },
  // //               maxLines: 3,
  // //               style: TextStyle(
  // //                 color: Colors.white,
  // //                 fontSize: 14,
  // //               ),
  // //               decoration: InputDecoration(
  // //                 hintText: 'Share your reasoning, thoughts, or questions...',
  // //                 hintStyle: TextStyle(
  // //                   color: Colors.white.withOpacity(0.6),
  // //                   fontSize: 14,
  // //                 ),
  // //                 contentPadding: EdgeInsets.symmetric(
  // //                   horizontal: 16,
  // //                   vertical: 12,
  // //                 ),
  // //                 border: InputBorder.none,
  // //               ),
  // //             ),
  // //           ),
  // //
  // //           SizedBox(height: 8),
  // //
  // //           // Character count
  // //           Align(
  // //             alignment: Alignment.centerRight,
  // //             child: Text(
  // //               '${feedbackControllers[scenario.id]?.text.length ?? 0}/500',
  // //               style: TextStyle(
  // //                 color: Colors.white.withOpacity(0.6),
  // //                 fontSize: 12,
  // //               ),
  // //             ),
  // //           ),
  // //         ],
  // //       ),
  // //     );
  // //   }
  // //
  // //   void _selectOption(Scenario scenario, int optionIndex) {
  // //     setState(() {
  // //       userAnswers[scenario.id] = optionIndex;
  // //       // Initialize feedback controller if not exists
  // //       if (!feedbackControllers.containsKey(scenario.id)) {
  // //         feedbackControllers[scenario.id] = TextEditingController();
  // //       }
  // //     });
  // //
  // //     print('✅ Selected option $optionIndex for scenario ${scenario.id}');
  // //   }
  // //
  // //   void _goToPreviousScenario() {
  // //     if (currentScenarioIndex > 0) {
  // //       _pageController.previousPage(
  // //         duration: Duration(milliseconds: 300),
  // //         curve: Curves.easeInOut,
  // //       );
  // //     }
  // //   }
  // //
  // //   void _handleNextAction(Scenario scenario, int index) async {
  // //     int userAnswer = userAnswers[scenario.id] ?? 0;
  // //     bool isCorrect = userAnswer == scenario.correctAnswer;
  // //     String feedbackText = userFeedback[scenario.id] ?? '';
  // //
  // //     print('\n🎯 === ANSWER CHECK ===');
  // //     print('Module: ${widget.moduleID}');
  // //     print('Scenario: ${scenario.title}');
  // //     print('User Answer: $userAnswer');
  // //     print('Correct Answer: ${scenario.correctAnswer}');
  // //     print('Is Correct: $isCorrect');
  // //     print('User Feedback: $feedbackText');
  // //     print('========================\n');
  // //
  // //     // Update progress with feedback in SINGLE call
  // //     int newCoinCount = await _progressManager.updateScenarioProgress(
  // //       scenario: scenario,
  // //       isCorrect: isCorrect,
  // //       currentUserData: userData,
  // //       userFeedback: feedbackText.isNotEmpty ? feedbackText : null,
  // //       userAnswer: userAnswer,
  // //     );
  // //
  // //     // Update level progress
  // //     await _progressManager.updateLevelProgress(
  // //       isCorrect: isCorrect,
  // //       totalScenarios: scenarios.length,
  // //     );
  // //
  // //     // Update local userData
  // //     setState(() {
  // //       userData['coins'] = newCoinCount;
  // //       userData['totalAnswers'] = userData['totalAnswers'] + 1;
  // //       if (isCorrect &&
  // //           !(userAnswers.containsKey(scenario.id) &&
  // //               userAnswers[scenario.id] == scenario.correctAnswer)) {
  // //         userData['correctAnswers'] = userData['correctAnswers'] + 1;
  // //       }
  // //     });
  // //
  // //     if (isCorrect) {
  // //       // Show correct answer feedback with dynamic coin message
  // //       num coinsEarned = newCoinCount - (userData['coins'] - newCoinCount);
  // //       String coinMessage = coinsEarned > 0 ? '+$coinsEarned coins!' : 'Already completed!';
  // //       _showAnswerFeedback(true, coinMessage);
  // //
  // //       // Correct answer - go to next scenario or complete level
  // //       if (index == scenarios.length - 1) {
  // //         _completeLevel();
  // //       } else {
  // //         // Delay to show feedback
  // //         await Future.delayed(Duration(milliseconds: 1500));
  // //         _goToNextScenario();
  // //       }
  // //     } else {
  // //       // Show wrong answer feedback
  // //       _showAnswerFeedback(false, 'Try the activity to learn more!');
  // //
  // //       // Delay to show feedback
  // //       await Future.delayed(Duration(milliseconds: 1500));
  // //
  // //       // Wrong answer - go to activity screen
  // //       _navigateToActivityScreen(scenario);
  // //     }
  // //   }
  // //
  // //   void _showAnswerFeedback(bool isCorrect, String message) {
  // //     ScaffoldMessenger.of(context).showSnackBar(
  // //       SnackBar(
  // //         content: Row(
  // //           children: [
  // //             Icon(
  // //               isCorrect ? Icons.check_circle : Icons.cancel,
  // //               color: Colors.white,
  // //               size: 20,
  // //             ),
  // //             SizedBox(width: 8),
  // //             Expanded(
  // //               child: Text(
  // //                 isCorrect ? 'Correct! $message' : 'Incorrect! $message',
  // //                 style: TextStyle(
  // //                   color: Colors.white,
  // //                   fontWeight: FontWeight.w500,
  // //                 ),
  // //               ),
  // //             ),
  // //           ],
  // //         ),
  // //         backgroundColor: isCorrect ? Colors.green : Colors.red,
  // //         duration: Duration(milliseconds: 1500),
  // //         behavior: SnackBarBehavior.floating,
  // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  // //       ),
  // //     );
  // //   }
  // //
  // //   void _goToNextScenario() {
  // //     _pageController.nextPage(
  // //       duration: Duration(milliseconds: 300),
  // //       curve: Curves.easeInOut,
  // //     );
  // //   }
  // //
  // //   void _navigateToActivityScreen(Scenario scenario) {
  // //     Navigator.push(
  // //       context,
  // //       MaterialPageRoute(
  // //         builder: (context) => EnhancedActivityScreen(
  // //           scenario: scenario,
  // //           onActivityComplete: () {
  // //             Navigator.pop(context); // Return from activity
  // //             _goToNextScenario(); // Continue to next scenario
  // //           },
  // //           moduleID: widget.moduleID,
  // //         ),
  // //       ),
  // //     );
  // //   }
  // //
  // //   void _completeLevel() async {
  // //     // Calculate score and stars
  // //     int correctAnswers = 0;
  // //     for (var scenario in scenarios) {
  // //       int userAnswer = userAnswers[scenario.id] ?? 0;
  // //       if (userAnswer == scenario.correctAnswer) {
  // //         correctAnswers++;
  // //       }
  // //     }
  // //
  // //     int stars = _calculateStars(correctAnswers, scenarios.length);
  // //
  // //     // Award completion bonus using ProgressManager
  // //     int finalCoinCount = await _progressManager.awardLevelCompletionBonus(
  // //       stars: stars,
  // //       currentCoins: userData['coins'],
  // //     );
  // //
  // //     // Update local coin count
  // //     setState(() {
  // //       userData['coins'] = finalCoinCount;
  // //     });
  // //
  // //     print('🏆 Level Complete for module ${widget.moduleID}!');
  // //     print('Correct: $correctAnswers/${scenarios.length}');
  // //     print('Stars: $stars');
  // //     print('Total Coins in ${widget.moduleID}: $finalCoinCount');
  // //
  // //     // Show completion dialog
  // //     _showCompletionDialog(correctAnswers, scenarios.length, stars);
  // //   }
  // //
  // //   int _calculateStars(int correct, int total) {
  // //     double percentage = correct / total;
  // //     if (percentage >= 0.9) return 3;
  // //     if (percentage >= 0.7) return 2;
  // //     if (percentage >= 0.5) return 1;
  // //     return 0;
  // //   }
  // //
  // //   void _showCompletionDialog(int correct, int total, int stars) {
  // //     showDialog(
  // //       context: context,
  // //       barrierDismissible: false,
  // //       builder: (context) => CompletionDialog(
  // //         correct: correct,
  // //         total: total,
  // //         stars: stars,
  // //         moduleName: _getModuleName(),
  // //         moduleID: widget.moduleID,
  // //         userCoins: userData['coins'],
  // //         auth: _auth,
  // //         database: _database,
  // //       ),
  // //     );
  // //   }
  // // }
  // import 'package:artizen/widgets/scenario_card.dart';
  // import 'package:flutter/material.dart';
  // import 'package:firebase_auth/firebase_auth.dart';
  // import 'package:firebase_database/firebase_database.dart';
  // import '../data/ProgressManager.dart';
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
  //   const LevelScenariosScreen({
  //     super.key,
  //     required this.levelId,
  //     required this.levelName,
  //     required this.moduleID,
  //   });
  //
  //   @override
  //   State<LevelScenariosScreen> createState() => _LevelScenariosScreenState();
  // }
  //
  // class _LevelScenariosScreenState extends State<LevelScenariosScreen>
  //     with TickerProviderStateMixin {
  //   final PageController _pageController = PageController();
  //   List<Scenario> scenarios = [];
  //   int currentScenarioIndex = 0;
  //   Map<int, int> userAnswers = {}; // scenario_id -> selected_option
  //
  //   // New: Store feedback text for each scenario
  //   Map<int, String> userFeedback = {}; // scenario_id -> feedback text
  //   Map<int, TextEditingController> feedbackControllers = {}; // Controllers for text fields
  //
  //   bool isLoading = true;
  //
  //   // Firebase instances
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final DatabaseReference _database = FirebaseDatabase.instance.ref();
  //
  //   // Progress Manager
  //   late ProgressManager _progressManager;
  //
  //   // User data
  //   Map<String, dynamic> userData = {
  //     'coins': 0,
  //     'correctAnswers': 0,
  //     'totalAnswers': 0,
  //   };
  //
  //   late AnimationController _slideController;
  //   late AnimationController _fadeController;
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //     _initializeProgressManager();
  //     _initializeAnimations();
  //     _loadUserData();
  //     _loadScenarios();
  //   }
  //
  //   void _initializeProgressManager() {
  //     _progressManager = ProgressManager(
  //       auth: _auth,
  //       database: _database,
  //       moduleID: widget.moduleID,
  //       moduleName: _getModuleName(),
  //       levelId: widget.levelId,
  //       levelName: widget.levelName,
  //     );
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
  //
  //     // Dispose text controllers
  //     for (var controller in feedbackControllers.values) {
  //       controller.dispose();
  //     }
  //
  //     super.dispose();
  //   }
  //
  //   Future<void> _loadUserData() async {
  //     try {
  //       Map<String, dynamic> loadedData = await _progressManager.loadUserData();
  //       setState(() {
  //         userData = loadedData;
  //       });
  //     } catch (e) {
  //       print('❌ Error loading user data: $e');
  //     }
  //   }
  //
  //   String _getModuleName() {
  //     switch (widget.moduleID) {
  //       case 'human_centered_mindset':
  //         return 'Human-Centered Mindset';
  //       case 'ai_ethics':
  //         return 'AI Ethics';
  //       case 'ai_foundations_applications':
  //         return 'AI Foundations and Applications';
  //       case 'ai_pedagogy':
  //         return 'AI Pedagogy';
  //       case 'ai_professional_development':
  //         return 'AI for Professional Development';
  //       default:
  //         return 'Unknown Module';
  //     }
  //   }
  //
  //   void _loadScenarios() {
  //     try {
  //       print('\n🔧 Loading scenarios for module: ${widget.moduleID}');
  //       print('🔧 UI levelId: ${widget.levelId}');
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
  //         // Initialize text controllers for each scenario
  //         for (var scenario in scenarios) {
  //           feedbackControllers[scenario.id] = TextEditingController();
  //         }
  //
  //         print('📚 Loaded ${scenarios.length} scenarios for ${level.level}');
  //         print('✅ SUCCESS: Correct scenarios loaded for ${widget.moduleID}');
  //
  //         // Debug: Print scenario ID range
  //         if (scenarios.isNotEmpty) {
  //           print('🎯 Scenario ID range: ${scenarios.first.id} - ${scenarios.last.id}');
  //         }
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
  //   // Method to save scenario records under existing progress node
  //   Future<void> _saveScenarioRecord({
  //     required Scenario scenario,
  //     required int userChoice,
  //     required int correctAnswer,
  //     required bool isCorrect,
  //     String? userFeedback,
  //   }) async {
  //     try {
  //       final User? user = _auth.currentUser;
  //       if (user == null) {
  //         print('❌ No authenticated user');
  //         return;
  //       }
  //
  //       // Create a unique record ID using timestamp and scenario ID
  //       String recordId = '${DateTime.now().millisecondsSinceEpoch}_${scenario.id}';
  //
  //       // Prepare the scenario record data
  //       Map<String, dynamic> scenarioRecord = {
  //         // Scenario Information
  //         'scenarioId': scenario.id,
  //         'scenarioTitle': scenario.title,
  //         'scenarioDescription': scenario.description,
  //         'scenarioOptions': scenario.options,
  //         'correctAnswer': correctAnswer,
  //
  //         // User Response Information
  //         'userChoice': userChoice,
  //         'isCorrect': isCorrect,
  //         'userFeedback': userFeedback,
  //
  //         // Metadata
  //         'timestamp': DateTime.now().toIso8601String(),
  //         'attemptId': recordId,
  //       };
  //
  //       // Save under existing progress structure
  //       // Path: progress/{userId}/modules/{moduleId}/levels/{levelId}/scenario_records/{recordId}
  //       await _database
  //           .child('progress')
  //           .child(user.uid)
  //           .child('modules')
  //           .child(widget.moduleID)
  //           .child('levels')
  //           .child(widget.levelId.toString())
  //           .child('scenario_records')
  //           .child(recordId)
  //           .set(scenarioRecord);
  //
  //       // Also save individual scenario progress for quick access
  //       // Path: progress/{userId}/modules/{moduleId}/levels/{levelId}/scenarios/{scenarioId}
  //       Map<String, dynamic> scenarioProgress = {
  //         'lastAttempt': {
  //           'userChoice': userChoice,
  //           'isCorrect': isCorrect,
  //           'timestamp': DateTime.now().toIso8601String(),
  //           'userFeedback': userFeedback,
  //         },
  //         'scenarioId': scenario.id,
  //         'scenarioTitle': scenario.title,
  //         'attempts': {
  //           recordId: {
  //             'userChoice': userChoice,
  //             'isCorrect': isCorrect,
  //             'timestamp': DateTime.now().toIso8601String(),
  //           }
  //         }
  //       };
  //
  //       await _database
  //           .child('progress')
  //           .child(user.uid)
  //           .child('modules')
  //           .child(widget.moduleID)
  //           .child('levels')
  //           .child(widget.levelId.toString())
  //           .child('scenarios')
  //           .child(scenario.id.toString())
  //           .update(scenarioProgress);
  //
  //       print('✅ Scenario record saved under progress node: $recordId');
  //
  //     } catch (e) {
  //       print('❌ Error saving scenario record: $e');
  //     }
  //   }
  //
  //   // Method to retrieve user's scenario records from progress node
  //   Future<List<Map<String, dynamic>>> getUserScenarioRecords() async {
  //     try {
  //       final User? user = _auth.currentUser;
  //       if (user == null) return [];
  //
  //       final DatabaseEvent event = await _database
  //           .child('progress')
  //           .child(user.uid)
  //           .child('modules')
  //           .child(widget.moduleID)
  //           .child('levels')
  //           .child(widget.levelId.toString())
  //           .child('scenario_records')
  //           .orderByChild('timestamp')
  //           .once();
  //
  //       if (event.snapshot.exists) {
  //         Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
  //         return data.values
  //             .map((record) => Map<String, dynamic>.from(record))
  //             .toList()
  //             .reversed // Most recent first
  //             .toList();
  //       }
  //
  //       return [];
  //     } catch (e) {
  //       print('❌ Error retrieving scenario records: $e');
  //       return [];
  //     }
  //   }
  //
  //   // Method to get specific scenario progress from progress node
  //   Future<Map<String, dynamic>?> getScenarioProgress(int scenarioId) async {
  //     try {
  //       final User? user = _auth.currentUser;
  //       if (user == null) return null;
  //
  //       final DatabaseEvent event = await _database
  //           .child('progress')
  //           .child(user.uid)
  //           .child('modules')
  //           .child(widget.moduleID)
  //           .child('levels')
  //           .child(widget.levelId.toString())
  //           .child('scenarios')
  //           .child(scenarioId.toString())
  //           .once();
  //
  //       if (event.snapshot.exists) {
  //         return Map<String, dynamic>.from(event.snapshot.value as Map);
  //       }
  //
  //       return null;
  //     } catch (e) {
  //       print('❌ Error retrieving scenario progress: $e');
  //       return null;
  //     }
  //   }
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
  //           textAlign: TextAlign.start,
  //           widget.levelName,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         actions: [
  //           // Coins indicator with real-time updates using ProgressManager
  //           StreamBuilder<DatabaseEvent>(
  //             stream: _progressManager.getCoinStream(),
  //             builder: (context, snapshot) {
  //               int displayCoins = userData['coins'] ?? 0;
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
  //
  //       body: Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
  //           ),
  //         ),
  //         child: isLoading
  //             ? LoadingScenariosView()
  //             : scenarios.isEmpty
  //             ? EmptyScenariosView()
  //             : GameplayView(
  //           scenarios: scenarios,
  //           pageController: _pageController,
  //           currentScenarioIndex: currentScenarioIndex,
  //           onPageChanged: (index) {
  //             setState(() {
  //               currentScenarioIndex = index;
  //             });
  //           },
  //           scenarioPageBuilder: _buildScenarioPage,
  //           progressBar: ScenarioProgressBar(
  //             currentIndex: currentScenarioIndex,
  //             total: scenarios.length,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //
  //   Widget _buildScenarioPage(Scenario scenario, int index) {
  //     return SingleChildScrollView(
  //       padding: EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Scenario Card
  //           ScenarioCard(scenario: scenario),
  //           SizedBox(height: 20),
  //
  //           // Options
  //           _buildOptionsSection(scenario),
  //           SizedBox(height: 20),
  //
  //           // Feedback Section - Only show if an answer is selected
  //           if (userAnswers.containsKey(scenario.id))
  //             _buildFeedbackSection(scenario),
  //
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
  //         ],
  //       ),
  //     );
  //   }
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
  //             optionText: optionText,
  //             isSelected: isSelected,
  //             onSelect: _selectOption,
  //           );
  //         }),
  //       ],
  //     );
  //   }
  //
  //   Widget _buildFeedbackSection(Scenario scenario) {
  //     return Container(
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white.withOpacity(0.15),
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.feedback_outlined, color: Colors.white, size: 20),
  //               SizedBox(width: 8),
  //               Text(
  //                 'Share your thoughts',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 4),
  //           Text(
  //             'Why did you choose this option? (Optional)',
  //             style: TextStyle(
  //               color: Colors.white.withOpacity(0.8),
  //               fontSize: 14,
  //             ),
  //           ),
  //           SizedBox(height: 12),
  //
  //           // Feedback input field
  //           Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white.withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(
  //                 color: Colors.white.withOpacity(0.3),
  //                 width: 1,
  //               ),
  //             ),
  //             child: TextField(
  //               controller: feedbackControllers[scenario.id],
  //               onChanged: (value) {
  //                 userFeedback[scenario.id] = value;
  //               },
  //               maxLines: 3,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 14,
  //               ),
  //               decoration: InputDecoration(
  //                 hintText: 'Share your reasoning, thoughts, or questions...',
  //                 hintStyle: TextStyle(
  //                   color: Colors.white.withOpacity(0.6),
  //                   fontSize: 14,
  //                 ),
  //                 contentPadding: EdgeInsets.symmetric(
  //                   horizontal: 16,
  //                   vertical: 12,
  //                 ),
  //                 border: InputBorder.none,
  //               ),
  //             ),
  //           ),
  //
  //           SizedBox(height: 8),
  //
  //           // Character count
  //           Align(
  //             alignment: Alignment.centerRight,
  //             child: Text(
  //               '${feedbackControllers[scenario.id]?.text.length ?? 0}/500',
  //               style: TextStyle(
  //                 color: Colors.white.withOpacity(0.6),
  //                 fontSize: 12,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   void _selectOption(Scenario scenario, int optionIndex) {
  //     setState(() {
  //       userAnswers[scenario.id] = optionIndex;
  //       // Initialize feedback controller if not exists
  //       if (!feedbackControllers.containsKey(scenario.id)) {
  //         feedbackControllers[scenario.id] = TextEditingController();
  //       }
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
  //   // Updated method with database recording
  //   void _handleNextAction(Scenario scenario, int index) async {
  //     int userAnswer = userAnswers[scenario.id] ?? 0;
  //     bool isCorrect = userAnswer == scenario.correctAnswer;
  //     String feedbackText = userFeedback[scenario.id] ?? '';
  //
  //     print('\n🎯 === ANSWER CHECK ===');
  //     print('Module: ${widget.moduleID}');
  //     print('Scenario: ${scenario.title}');
  //     print('User Answer: $userAnswer');
  //     print('Correct Answer: ${scenario.correctAnswer}');
  //     print('Is Correct: $isCorrect');
  //     print('User Feedback: $feedbackText');
  //     print('========================\n');
  //
  //     // Save the scenario record to database
  //     await _saveScenarioRecord(
  //       scenario: scenario,
  //       userChoice: userAnswer,
  //       correctAnswer: scenario.correctAnswer,
  //       isCorrect: isCorrect,
  //       userFeedback: feedbackText.isNotEmpty ? feedbackText : null,
  //     );
  //
  //     // Update progress with feedback in SINGLE call
  //     int newCoinCount = await _progressManager.updateScenarioProgress(
  //       scenario: scenario,
  //       isCorrect: isCorrect,
  //       currentUserData: userData,
  //       userFeedback: feedbackText.isNotEmpty ? feedbackText : null,
  //       userAnswer: userAnswer,
  //     );
  //
  //     // Update level progress
  //     await _progressManager.updateLevelProgress(
  //       isCorrect: isCorrect,
  //       totalScenarios: scenarios.length,
  //     );
  //
  //     // Update local userData
  //     setState(() {
  //       userData['coins'] = newCoinCount;
  //       userData['totalAnswers'] = userData['totalAnswers'] + 1;
  //       if (isCorrect &&
  //           !(userAnswers.containsKey(scenario.id) &&
  //               userAnswers[scenario.id] == scenario.correctAnswer)) {
  //         userData['correctAnswers'] = userData['correctAnswers'] + 1;
  //       }
  //     });
  //
  //     if (isCorrect) {
  //       // Show correct answer feedback with dynamic coin message
  //       num coinsEarned = newCoinCount - (userData['coins'] - newCoinCount);
  //       String coinMessage = coinsEarned > 0 ? '+$coinsEarned coins!' : 'Already completed!';
  //       _showAnswerFeedback(true, coinMessage);
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
  //         builder: (context) => EnhancedActivityScreen(
  //           scenario: scenario,
  //           onActivityComplete: () {
  //             Navigator.pop(context); // Return from activity
  //             _goToNextScenario(); // Continue to next scenario
  //           },
  //           moduleID: widget.moduleID,
  //         ),
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
  //     // Award completion bonus using ProgressManager
  //     int finalCoinCount = await _progressManager.awardLevelCompletionBonus(
  //       stars: stars,
  //       currentCoins: userData['coins'],
  //     );
  //
  //     // Update local coin count
  //     setState(() {
  //       userData['coins'] = finalCoinCount;
  //     });
  //
  //     print('🏆 Level Complete for module ${widget.moduleID}!');
  //     print('Correct: $correctAnswers/${scenarios.length}');
  //     print('Stars: $stars');
  //     print('Total Coins in ${widget.moduleID}: $finalCoinCount');
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
  //         userCoins: userData['coins'],
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
    final PageController _pageController = PageController();
    List<Scenario> scenarios = [];
    int currentScenarioIndex = 0;
    Map<int, int> userAnswers = {}; // scenario_id -> selected_option

    // New: Store feedback text for each scenario
    Map<int, String> userFeedback = {}; // scenario_id -> feedback text
    Map<int, TextEditingController> feedbackControllers = {}; // Controllers for text fields

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

      // Dispose text controllers
      for (var controller in feedbackControllers.values) {
        controller.dispose();
      }

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

          // Initialize text controllers for each scenario
          for (var scenario in scenarios) {
            feedbackControllers[scenario.id] = TextEditingController();
          }

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

    // Method to save scenario records under existing progress node
    Future<void> _saveScenarioRecord({
      required Scenario scenario,
      required int userChoice,
      required int correctAnswer,
      required bool isCorrect,
      String? userFeedback,
    }) async {
      try {
        final User? user = _auth.currentUser;
        if (user == null) {
          print('❌ No authenticated user');
          return;
        }

        // Create a unique record ID using timestamp and scenario ID
        String recordId = '${DateTime.now().millisecondsSinceEpoch}_${scenario.id}';

        // Prepare the scenario record data
        Map<String, dynamic> scenarioRecord = {
          // Scenario Information
          'scenarioId': scenario.id,
          'scenarioTitle': scenario.title,
          'scenarioDescription': scenario.description,
          'scenarioOptions': scenario.options,
          'correctAnswer': correctAnswer,

          // User Response Information
          'userChoice': userChoice,
          'isCorrect': isCorrect,
          'userFeedback': userFeedback,

          // Metadata
          'timestamp': DateTime.now().toIso8601String(),
          'attemptId': recordId,
        };

        // Save under existing progress structure
        // Path: progress/{userId}/modules/{moduleId}/levels/{levelId}/scenario_records/{recordId}
        await _database
            .child('Progress')
            .child(user.uid)
            .child('modules')
            .child(widget.moduleID)
            .child('levels')
            .child(widget.levelId.toString())
            .child('scenario_records')
            .child(recordId)
            .set(scenarioRecord);

        // Also save individual scenario progress for quick access
        // Path: progress/{userId}/modules/{moduleId}/levels/{levelId}/scenarios/{scenarioId}
        Map<String, dynamic> scenarioProgress = {
          'lastAttempt': {
            'userChoice': userChoice,
            'isCorrect': isCorrect,
            'timestamp': DateTime.now().toIso8601String(),
            'userFeedback': userFeedback,
          },
          'scenarioId': scenario.id,
          'scenarioTitle': scenario.title,
          'attempts': {
            recordId: {
              'userChoice': userChoice,
              'isCorrect': isCorrect,
              'timestamp': DateTime.now().toIso8601String(),
            }
          }
        };

        await _database
            .child('Progress')
            .child(user.uid)
            .child('modules')
            .child(widget.moduleID)
            .child('levels')
            .child(widget.levelId.toString())
            .child('scenarios')
            .child(scenario.id.toString())
            .update(scenarioProgress);

        print('✅ Scenario record saved under progress node: $recordId');

      } catch (e) {
        print('❌ Error saving scenario record: $e');
      }
    }

    // Method to retrieve user's scenario records from Progress node
    Future<List<Map<String, dynamic>>> getUserScenarioRecords() async {
      try {
        final User? user = _auth.currentUser;
        if (user == null) return [];

        final DatabaseEvent event = await _database
            .child('Progress')
            .child(user.uid)
            .child('modules')
            .child(widget.moduleID)
            .child('levels')
            .child(widget.levelId.toString())
            .child('scenario_records')
            .orderByChild('timestamp')
            .once();

        if (event.snapshot.exists) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          return data.values
              .map((record) => Map<String, dynamic>.from(record))
              .toList()
              .reversed // Most recent first
              .toList();
        }

        return [];
      } catch (e) {
        print('❌ Error retrieving scenario records: $e');
        return [];
      }
    }

    // Method to get specific scenario progress from Progress node
    Future<Map<String, dynamic>?> getScenarioProgress(int scenarioId) async {
      try {
        final User? user = _auth.currentUser;
        if (user == null) return null;

        final DatabaseEvent event = await _database
            .child('Progress')
            .child(user.uid)
            .child('modules')
            .child(widget.moduleID)
            .child('levels')
            .child(widget.levelId.toString())
            .child('scenarios')
            .child(scenarioId.toString())
            .once();

        if (event.snapshot.exists) {
          return Map<String, dynamic>.from(event.snapshot.value as Map);
        }

        return null;
      } catch (e) {
        print('❌ Error retrieving scenario progress: $e');
        return null;
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
            textAlign: TextAlign.start,
            widget.levelName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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

            // Feedback Section - Only show if an answer is selected
            if (userAnswers.containsKey(scenario.id))
              _buildFeedbackSection(scenario),

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
          }),
        ],
      );
    }

    Widget _buildFeedbackSection(Scenario scenario) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.feedback_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Share your thoughts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Why did you choose this option? (Optional)',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),

            // Feedback input field
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: feedbackControllers[scenario.id],
                onChanged: (value) {
                  userFeedback[scenario.id] = value;
                },
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Share your reasoning, thoughts, or questions...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 8),

            // Character count
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${feedbackControllers[scenario.id]?.text.length ?? 0}/500',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    void _selectOption(Scenario scenario, int optionIndex) {
      setState(() {
        userAnswers[scenario.id] = optionIndex;
        // Initialize feedback controller if not exists
        if (!feedbackControllers.containsKey(scenario.id)) {
          feedbackControllers[scenario.id] = TextEditingController();
        }
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

    // Updated method with database recording
    void _handleNextAction(Scenario scenario, int index) async {
      int userAnswer = userAnswers[scenario.id] ?? 0;
      bool isCorrect = userAnswer == scenario.correctAnswer;
      String feedbackText = userFeedback[scenario.id] ?? '';

      print('\n🎯 === ANSWER CHECK ===');
      print('Module: ${widget.moduleID}');
      print('Scenario: ${scenario.title}');
      print('User Answer: $userAnswer');
      print('Correct Answer: ${scenario.correctAnswer}');
      print('Is Correct: $isCorrect');
      print('User Feedback: $feedbackText');
      print('========================\n');

      // Save the scenario record to database
      await _saveScenarioRecord(
        scenario: scenario,
        userChoice: userAnswer,
        correctAnswer: scenario.correctAnswer,
        isCorrect: isCorrect,
        userFeedback: feedbackText.isNotEmpty ? feedbackText : null,
      );

      // Update progress with feedback in SINGLE call
      int newCoinCount = await _progressManager.updateScenarioProgress(
        scenario: scenario,
        isCorrect: isCorrect,
        currentUserData: userData,
        userFeedback: feedbackText.isNotEmpty ? feedbackText : null,
        userAnswer: userAnswer,
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