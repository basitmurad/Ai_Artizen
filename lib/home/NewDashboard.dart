// //
// // import 'dart:math' as math;
// // import 'package:flutter/material.dart';
// //
// // import '../data/UserDataService.dart';
// // import '../json/JsonDataManager2.dart';
// // import '../models/LevelData.dart';
// // import '../models/ModuleData.dart';
// // import '../widgets/AnimatedSphere.dart';
// // import '../widgets/DashboardHeader.dart';
// // import '../widgets/LevelDetailsDialog.dart';
// // import '../widgets/LoadingIndicator.dart';
// // import '../widgets/ModuleHeaderWidget.dart';
// // import '../widgets/UserBadgesWidget.dart';
// // import '../widgets/ZigzagModuleWidget.dart';
// // import 'LevelScenariosScreen.dart';
// //
// // class NewDashboard extends StatefulWidget {
// //   const NewDashboard({super.key});
// //
// //   @override
// //   _NewDashboardState createState() => _NewDashboardState();
// // }
// //
// // class _NewDashboardState extends State<NewDashboard>
// //     with TickerProviderStateMixin {
// //   late AnimationController _floatingController;
// //   late AnimationController _pathController;
// //   late AnimationController _coinController;
// //
// //   // Use the service instead of Firebase instances
// //   final UserDataService _userDataService = UserDataService();
// //
// //   bool _isLoading = true;
// //   Map<int, Map<String, dynamic>> _userProgress = {};
// //   Map<String, dynamic> _userProfile = {};
// //   int _totalCoins = 0;
// //
// //   // Level tap handler - commented out as it may not be defined
// //   // late LevelTapHandler _levelTapHandler;
// //
// //   // Single module definition - Human-Centered Mindset with JSON data
// //   final Map<String, dynamic> _moduleDefinition = {
// //     'id': 1,
// //     'title': 'Human-Centered Mindset',
// //     'subtitle': 'Building empathy and understanding in AI implementation',
// //     'color': Color(0xFF4A90E2),
// //     'icon': Icons.favorite,
// //     'hasJsonData': true,
// //   };
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeAnimations();
// //     _initializeLevelHandler();
// //     _fetchUserData();
// //   }
// //
// //   void _initializeAnimations() {
// //     _floatingController = AnimationController(
// //       duration: Duration(seconds: 2),
// //       vsync: this,
// //     )..repeat(reverse: true);
// //
// //     _pathController = AnimationController(
// //       duration: Duration(milliseconds: 3000),
// //       vsync: this,
// //     );
// //
// //     _coinController = AnimationController(
// //       duration: Duration(milliseconds: 800),
// //       vsync: this,
// //     );
// //
// //     _pathController.forward();
// //   }
// //
// //   void _initializeLevelHandler() {
// //     // _levelTapHandler = LevelTapHandler(
// //     //   context: context,
// //     //   onLevelCompleted: _handleLevelCompleted,
// //     // );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _floatingController.dispose();
// //     _pathController.dispose();
// //     _coinController.dispose();
// //     super.dispose();
// //   }
// //
// //   /// Fetch user data using the UserDataService
// //   Future<void> _fetchUserData() async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     try {
// //       final result = await _userDataService.fetchUserData();
// //
// //       if (result.isSuccess) {
// //         setState(() {
// //           _userProfile = result.profile;
// //           _userProgress = result.progress;
// //           _totalCoins = result.totalCoins;
// //         });
// //
// //         // Debug print to check the progress data
// //         print('🔍 User Progress Data:');
// //         _userProgress.forEach((levelId, levelData) {
// //           print('  Level $levelId: $levelData');
// //         });
// //       } else {
// //         print('⚠️ Failed to fetch user data: ${result.error}');
// //         _setDefaultUserData();
// //       }
// //     } catch (e) {
// //       print('❌ Error in _fetchUserData: $e');
// //       _setDefaultUserData();
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //
// //       // Animate coins when data is loaded
// //       _coinController.forward();
// //     }
// //   }
// //
// //   void _setDefaultUserData() {
// //     setState(() {
// //       _userProfile = {
// //         'username': 'User',
// //         'email': '',
// //         'avatar': '',
// //         'isActive': true,
// //       };
// //       _userProgress = {};
// //       _totalCoins = 0;
// //     });
// //   }
// //
// //
// //
// //
// //   void _handleRefresh() {
// //     _coinController.reset();
// //     _fetchUserData();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Column(
// //             children: [
// //               _buildHeader(),
// //               Expanded(
// //                 child: _isLoading ? _buildLoadingIndicator() : _buildGamePath(),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildLoadingIndicator() {
// //     return AnimatedLoadingIndicator(
// //       message: 'Loading your progress...',
// //       indicatorColor: Colors.white,
// //       textColor: Colors.white,
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return AIArtizenDashboardHeader(
// //       displayName: _getUserDisplayName(),
// //       userInitials: _getUserInitials(),
// //       totalCoins: _totalCoins,
// //       coinController: _coinController,
// //       onRefresh: _handleRefresh,
// //     );
// //   }
// //
// //   String _getUserDisplayName() {
// //     if (_userProfile['username'] != null && _userProfile['username'].isNotEmpty) {
// //       return _userProfile['username'];
// //     }
// //     return 'User';
// //   }
// //
// //   String _getUserInitials() {
// //     String displayName = _getUserDisplayName();
// //     if (displayName == 'User') return 'U';
// //
// //     List<String> parts = displayName.split(' ');
// //     if (parts.length >= 2) {
// //       return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
// //     } else if (parts.isNotEmpty) {
// //       return parts[0][0].toUpperCase();
// //     }
// //     return 'U';
// //   }
// //
// //   Widget _buildGamePath() {
// //     return SingleChildScrollView(
// //       physics: BouncingScrollPhysics(),
// //       child: Container(
// //         width: double.infinity,
// //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //         child: Column(
// //           children: [
// //             _buildFloatingMascot(),
// //             SizedBox(height: 20),
// //             _buildModule(),
// //             SizedBox(height: 100), // Extra space at bottom
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //   Widget _buildFloatingMascot() {
// //     return AnimatedSphere(
// //       size: 80,
// //       primaryColor: Color(0xFF4A90E2),
// //       secondaryColor: Color(0xFF7B68EE),
// //       child: Icon(
// //         Icons.psychology,
// //         size: 40,
// //         color: Colors.white,
// //       ),
// //       onTap: () {
// //         // Add any interaction logic here
// //         print("Mascot sphere tapped!");
// //       },
// //     );
// //   }
// //
// //   Widget _buildModule() {
// //     final moduleData = _generateModuleFromJson(_moduleDefinition);
// //
// //     return AnimatedBuilder(
// //       animation: _pathController,
// //       builder: (context, child) {
// //         return FadeTransition(
// //           opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
// //             CurvedAnimation(
// //               parent: _pathController,
// //               curve: Interval(0.0, 0.4, curve: Curves.easeOut),
// //             ),
// //           ),
// //           child: SlideTransition(
// //             position: Tween<Offset>(
// //               begin: Offset(0, 0.3),
// //               end: Offset.zero,
// //             ).animate(
// //               CurvedAnimation(
// //                 parent: _pathController,
// //                 curve: Interval(0.0, 0.4, curve: Curves.easeOut),
// //               ),
// //             ),
// //             child: Column(
// //               children: [
// //                 _buildModuleHeader(moduleData),
// //                 _buildZigzagModule(moduleData.levels),
// //                 _buildUserBadges(), // Add user badges section
// //                 _buildModuleBadge(moduleData),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //   Widget _buildModuleHeader(ModuleData module) {
// //     return ModuleHeaderWidget(
// //       title: module.title,
// //       subtitle: _moduleDefinition['subtitle'],
// //       icon: _moduleDefinition['icon'],
// //       primaryColor: _moduleDefinition['color'],
// //       completedLevels: module.levels.where((level) => level.isCompleted).length,
// //       totalLevels: module.levels.length,
// //       onTap: () {
// //         // Add module tap functionality
// //         print('Module header tapped!');
// //       },
// //     );
// //   }
// //
// //   Widget _buildUserBadges() {
// //     return UserBadgesWidget(
// //       userProgress: _userProgress,
// //       title: 'Your Achievements',
// //       maxLevels: 3, // Exactly 3 levels
// //
// //       showEmptyState: true,
// //       emptyStateText: 'Complete levels to earn badges!',
// //     );
// //   }
// //
// //
// //
// //
// //   Widget _buildZigzagModule(List<LevelData> levels) {
// //     // Convert your LevelData to ZigzagLevelData
// //     List<ZigzagLevelData> zigzagLevels = levels.map((level) =>
// //         ZigzagLevelData(
// //           id: level.id,
// //           title: level.title,
// //           isCompleted: level.isCompleted,
// //           isUnlocked: level.isUnlocked,
// //           stars: level.stars,
// //           data: level.scenarioData,
// //         )
// //     ).toList();
// //
// //     return ZigzagModuleWidget(
// //       levels: zigzagLevels,
// //       onLevelTap: (level) => _onLevelTap(level as LevelData),
// //       showConnectors: true,
// //       levelSize: 70,
// //       pathColor: Colors.white,
// //     );
// //   }
// //
// //   Widget _buildModuleBadge(ModuleData module) {
// //     bool isModuleCompleted = module.levels.every((level) => level.isCompleted);
// //
// //     return Container(
// //       margin: EdgeInsets.only(top: 20),
// //       child: GestureDetector(
// //         onTap: isModuleCompleted ? () => _onBadgeTap(module) : null,
// //         child: Container(
// //           width: 80,
// //           height: 80,
// //           decoration: BoxDecoration(
// //             color: isModuleCompleted
// //                 ? _moduleDefinition['color']
// //                 : Colors.grey[400],
// //             shape: BoxShape.circle,
// //             border: Border.all(
// //               color: Colors.white,
// //               width: 4,
// //             ),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: (isModuleCompleted
// //                     ? _moduleDefinition['color']
// //                     : Colors.grey[400]!).withOpacity(0.3),
// //                 blurRadius: 15,
// //                 offset: Offset(0, 8),
// //               ),
// //             ],
// //           ),
// //           child: Center(
// //             child: isModuleCompleted
// //                 ? Icon(
// //               Icons.military_tech,
// //               color: Colors.white,
// //               size: 35,
// //             )
// //                 : Icon(
// //               Icons.lock,
// //               color: Colors.grey[600],
// //               size: 30,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// //
// //   int _calculateStarsFromProgress(Map<String, dynamic> levelProgress) {
// //     if (levelProgress['isCompleted'] == true) {
// //       // If we have correct/total answers, calculate stars based on performance
// //       int correctAnswers = levelProgress['correctAnswers'] ?? 0;
// //       int totalAnswers = levelProgress['totalAnswers'] ?? 0;
// //
// //       if (totalAnswers > 0) {
// //         double percentage = correctAnswers / totalAnswers;
// //         if (percentage >= 0.9) return 3;  // 90%+ = 3 stars
// //         if (percentage >= 0.7) return 2;  // 70%+ = 2 stars
// //         if (percentage >= 0.5) return 1;  // 50%+ = 1 star
// //       }
// //
// //       // If completed but no performance data, give 1 star
// //       return 1;
// //     }
// //
// //     return 0; // Not completed
// //   }
// //
// //
// //   void _onLevelTap(LevelData level) {
// //     // Print level data when tapped for debugging
// //     print('\n🎯 === LEVEL ${level.id} TAPPED ===');
// //     print('Title: ${level.title}');
// //     print('Is Completed: ${level.isCompleted}');
// //     print('Is Unlocked: ${level.isUnlocked}');
// //     print('Stars: ${level.stars}');
// //     print('User Progress for this level: ${_userProgress[level.id]}');
// //     print('Scenario Data Keys: ${level.scenarioData.keys.toList()}');
// //
// //     // Print detailed level information
// //     try {
// //       final educationModule = JsonDataManager2.getModule();
// //       final currentLevel = educationModule.getLevelByNumber(level.id);
// //
// //       if (currentLevel != null) {
// //         print('\n📚 === DETAILED LEVEL INFO ===');
// //         print('Level Name: ${currentLevel.level}');
// //         print('Level Type: ${currentLevel.levelType}');
// //         print('Total Scenarios: ${currentLevel.scenarios.length}');
// //
// //         // Print all scenario titles
// //         print('\n📋 Scenarios in this level:');
// //         for (int i = 0; i < currentLevel.scenarios.length; i++) {
// //           final scenario = currentLevel.scenarios[i];
// //           print('  ${i + 1}. ${scenario.title}');
// //           print('     - ${scenario.options.length} options');
// //           print('     - ${scenario.activity.cards.length} activity cards');
// //           print('     - Activity: ${scenario.activity.name}');
// //         }
// //         print('=== END DETAILED INFO ===\n');
// //       }
// //     } catch (e) {
// //       print('❌ Error printing level details: $e');
// //     }
// //
// //     // Navigate to the scenarios screen
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => LevelScenariosScreen(
// //           levelId: level.id,
// //           levelName: level.title,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _onBadgeTap(ModuleData module) {
// //     // Handle badge tap - could show achievement dialog
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('🏆 ${module.title} Badge Earned!'),
// //         backgroundColor: Colors.green,
// //         duration: Duration(seconds: 2),
// //       ),
// //     );
// //   }
// //   /// Updated method to work with new JSON structure and proper unlocking logic
// //   ModuleData _generateModuleFromJson(Map<String, dynamic> moduleDefinition) {
// //     try {
// //       // Get the education module using the new model
// //       final educationModule = JsonDataManager2.getModule();
// //
// //       List<LevelData> levelDataList = [];
// //
// //       // Process each level from the JSON
// //       for (int levelIndex = 0; levelIndex < educationModule.levels.length; levelIndex++) {
// //         final level = educationModule.levels[levelIndex];
// //
// //         // Create level ID (1, 2, 3)
// //         int uniqueId = levelIndex + 1;
// //
// //         // Get user progress for this level from Firebase structure
// //         Map<String, dynamic>? levelProgress = _userProgress[uniqueId];
// //         bool isCompleted = levelProgress?['isCompleted'] ?? false;
// //
// //         // NEW UNLOCKING LOGIC: Check sequential completion
// //         bool isUnlocked = _isLevelUnlocked(uniqueId);
// //
// //         // Calculate stars based on progress - UPDATED LOGIC
// //         int stars = 0;
// //         if (levelProgress != null) {
// //           // Try to get stars from multiple possible fields
// //           stars = levelProgress['starsEarned'] ??
// //               levelProgress['stars'] ??
// //               _calculateStarsFromProgress(levelProgress);
// //
// //           // Ensure stars are within valid range
// //           stars = stars.clamp(0, 3);
// //         }
// //
// //         // Create display title from level name
// //         String displayTitle = _formatLevelTitle(level.level);
// //
// //         // Create scenario data for the level tap handler
// //         Map<String, dynamic> scenarioData = {
// //           'id': uniqueId,
// //           'levelName': level.level,
// //           'levelType': level.levelType,
// //           'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
// //           'totalScenarios': level.scenarios.length,
// //         };
// //
// //         // Debug print for each level
// //         print('🎯 Level $uniqueId: completed=$isCompleted, unlocked=$isUnlocked, stars=$stars');
// //
// //         levelDataList.add(
// //           LevelData(
// //             id: uniqueId,
// //             title: displayTitle,
// //             isCompleted: isCompleted,
// //             isUnlocked: isUnlocked,
// //             stars: stars,
// //             scenarioData: scenarioData,
// //           ),
// //         );
// //       }
// //
// //       // Return the complete module with all levels processed
// //       return ModuleData(
// //         title: educationModule.moduleName,
// //         levels: levelDataList,
// //       );
// //     } catch (e) {
// //       print('❌ Error generating module from JSON: $e');
// //       // Return a fallback module
// //       return ModuleData(
// //         title: 'Human-Centered Mindset',
// //         levels: [
// //           LevelData(
// //             id: 1,
// //             title: 'Level 1',
// //             isCompleted: false,
// //             isUnlocked: true,
// //             stars: 0,
// //             scenarioData: {},
// //           ),
// //         ],
// //       );
// //     }
// //   }
// //
// //     bool _isLevelUnlocked(int levelId) {
// //     // Level 1 is always unlocked
// //     if (levelId == 1) {
// //     return true;
// //     }
// //
// //     // For levels 2 and above, check if the previous level is completed
// //     int previousLevelId = levelId - 1;
// //     Map<String, dynamic>? previousLevelProgress = _userProgress[previousLevelId];
// //     bool isPreviousCompleted = previousLevelProgress?['isCompleted'] ?? false;
// //
// //     print('🔓 Checking unlock for Level $levelId: Previous level ($previousLevelId) completed: $isPreviousCompleted');
// //
// //     return isPreviousCompleted;
// //     }
// //
// //     /// Helper method to format level titles for display
// //     String _formatLevelTitle(String levelName) {
// //     // Extract the level type from the full level name
// //     // "Level 1 (Acquire)" -> "Acquire"
// //     // "Level 2 (Deepen)" -> "Deepen"
// //     // "Level 3 (Create)" -> "Create"
// //
// //     final regex = RegExp(r'Level (\d+) \((.+)\)');
// //     final match = regex.firstMatch(levelName);
// //
// //     if (match != null) {
// //     final levelNumber = match.group(1);
// //     final levelType = match.group(2);
// //     return '$levelNumber. $levelType';
// //     }
// //
// //     // Fallback to original name if regex doesn't match
// //     return levelName;
// //     }
// //   }
// //
// //
// //
//
//
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
//
// import '../data/UserDataService.dart';
// import '../json/JsonDataManager2.dart';
// import '../models/LevelData.dart';
// import '../models/ModuleData.dart';
// import '../widgets/AnimatedSphere.dart';
// import '../widgets/DashboardHeader.dart';
// import '../widgets/LevelDetailsDialog.dart';
// import '../widgets/LoadingIndicator.dart';
// import '../widgets/ModuleHeaderWidget.dart';
// import '../widgets/UserBadgesWidget.dart';
// import '../widgets/ZigzagModuleWidget.dart';
// import 'LevelScenariosScreen.dart';
//
// class NewDashboard extends StatefulWidget {
//   const NewDashboard({super.key});
//
//   @override
//   _NewDashboardState createState() => _NewDashboardState();
// }
//
// class _NewDashboardState extends State<NewDashboard>
//     with TickerProviderStateMixin {
//   late AnimationController _floatingController;
//   late AnimationController _pathController;
//   late AnimationController _coinController;
//
//   // Use the service instead of Firebase instances
//   final UserDataService _userDataService = UserDataService();
//
//   bool _isLoading = true;
//   Map<int, Map<String, dynamic>> _userProgress = {};
//   Map<String, dynamic> _userProfile = {};
//   int _totalCoins = 0;
//
//   // Multiple module definitions
//   final List<Map<String, dynamic>> _moduleDefinitions = [
//     {
//       'id': 1,
//       'title': 'Human-Centered Mindset',
//       'subtitle': 'Building empathy and understanding in AI implementation',
//       'color': Color(0xFF4A90E2),
//       'icon': Icons.favorite,
//       'hasJsonData': true,
//       'levelPrefix': 'hcm', // Prefix for level IDs
//     },
//     {
//       'id': 2,
//       'title': 'AI Ethics',
//       'subtitle': 'Understanding bias, fairness, and responsible AI development',
//       'color': Color(0xFF9C27B0),
//       'icon': Icons.balance,
//       'hasJsonData': false, // Can be set to true when JSON data is available
//       'levelPrefix': 'aie', // Prefix for level IDs
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeLevelHandler();
//     _fetchUserData();
//   }
//
//   void _initializeAnimations() {
//     _floatingController = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _pathController = AnimationController(
//       duration: Duration(milliseconds: 3000),
//       vsync: this,
//     );
//
//     _coinController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _pathController.forward();
//   }
//
//   void _initializeLevelHandler() {
//     // _levelTapHandler = LevelTapHandler(
//     //   context: context,
//     //   onLevelCompleted: _handleLevelCompleted,
//     // );
//   }
//
//   @override
//   void dispose() {
//     _floatingController.dispose();
//     _pathController.dispose();
//     _coinController.dispose();
//     super.dispose();
//   }
//
//   /// Fetch user data using the UserDataService
//   Future<void> _fetchUserData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final result = await _userDataService.fetchUserData();
//
//       if (result.isSuccess) {
//         setState(() {
//           _userProfile = result.profile;
//           _userProgress = result.progress;
//           _totalCoins = result.totalCoins;
//         });
//
//         // Debug print to check the progress data
//         print('🔍 User Progress Data:');
//         _userProgress.forEach((levelId, levelData) {
//           print('  Level $levelId: $levelData');
//         });
//       } else {
//         print('⚠️ Failed to fetch user data: ${result.error}');
//         _setDefaultUserData();
//       }
//     } catch (e) {
//       print('❌ Error in _fetchUserData: $e');
//       _setDefaultUserData();
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//
//       // Animate coins when data is loaded
//       _coinController.forward();
//     }
//   }
//
//   void _setDefaultUserData() {
//     setState(() {
//       _userProfile = {
//         'username': 'User',
//         'email': '',
//         'avatar': '',
//         'isActive': true,
//       };
//       _userProgress = {};
//       _totalCoins = 0;
//     });
//   }
//
//   void _handleRefresh() {
//     _coinController.reset();
//     _fetchUserData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: _isLoading ? _buildLoadingIndicator() : _buildGamePath(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return AnimatedLoadingIndicator(
//       message: 'Loading your progress...',
//       indicatorColor: Colors.white,
//       textColor: Colors.white,
//     );
//   }
//
//   Widget _buildHeader() {
//     return AIArtizenDashboardHeader(
//       displayName: _getUserDisplayName(),
//       userInitials: _getUserInitials(),
//       totalCoins: _totalCoins,
//       coinController: _coinController,
//       onRefresh: _handleRefresh,
//     );
//   }
//
//   String _getUserDisplayName() {
//     if (_userProfile['username'] != null && _userProfile['username'].isNotEmpty) {
//       return _userProfile['username'];
//     }
//     return 'User';
//   }
//
//   String _getUserInitials() {
//     String displayName = _getUserDisplayName();
//     if (displayName == 'User') return 'U';
//
//     List<String> parts = displayName.split(' ');
//     if (parts.length >= 2) {
//       return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
//     } else if (parts.isNotEmpty) {
//       return parts[0][0].toUpperCase();
//     }
//     return 'U';
//   }
//
//   Widget _buildGamePath() {
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             _buildFloatingMascot(),
//             SizedBox(height: 20),
//             // Build all modules
//             ..._buildAllModules(),
//             SizedBox(height: 100), // Extra space at bottom
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingMascot() {
//     return AnimatedSphere(
//       size: 80,
//       primaryColor: Color(0xFF4A90E2),
//       secondaryColor: Color(0xFF7B68EE),
//       child: Icon(
//         Icons.psychology,
//         size: 40,
//         color: Colors.white,
//       ),
//       onTap: () {
//         print("Mascot sphere tapped!");
//       },
//     );
//   }
//
//   List<Widget> _buildAllModules() {
//     List<Widget> moduleWidgets = [];
//
//     for (int i = 0; i < _moduleDefinitions.length; i++) {
//       final moduleDefinition = _moduleDefinitions[i];
//       final moduleData = _generateModuleFromDefinition(moduleDefinition);
//
//       // Add module with animation delay
//       moduleWidgets.add(
//         AnimatedBuilder(
//           animation: _pathController,
//           builder: (context, child) {
//             double moduleDelay = 0.2 + (i * 0.3);
//
//             return FadeTransition(
//               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(
//                   parent: _pathController,
//                   curve: Interval(
//                     moduleDelay.clamp(0.0, 0.8),
//                     (moduleDelay + 0.4).clamp(0.0, 1.0),
//                     curve: Curves.easeOut,
//                   ),
//                 ),
//               ),
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                   begin: Offset(0, 0.3),
//                   end: Offset.zero,
//                 ).animate(
//                   CurvedAnimation(
//                     parent: _pathController,
//                     curve: Interval(
//                       moduleDelay.clamp(0.0, 0.8),
//                       (moduleDelay + 0.4).clamp(0.0, 1.0),
//                       curve: Curves.easeOut,
//                     ),
//                   ),
//                 ),
//                 child: _buildModule(moduleData, moduleDefinition),
//               ),
//             );
//           },
//         ),
//       );
//
//       // Add spacing between modules (except for the last one)
//       if (i < _moduleDefinitions.length - 1) {
//         moduleWidgets.add(SizedBox(height: 40));
//       }
//     }
//
//     return moduleWidgets;
//   }
//
//   Widget _buildModule(ModuleData moduleData, Map<String, dynamic> moduleDefinition) {
//     return Column(
//       children: [
//         _buildModuleHeader(moduleData, moduleDefinition),
//         _buildZigzagModule(moduleData.levels, moduleDefinition),
//         _buildUserBadges(moduleDefinition), // Pass module definition for correct level range
//         _buildModuleBadge(moduleData, moduleDefinition),
//       ],
//     );
//   }
//
//   Widget _buildModuleHeader(ModuleData module, Map<String, dynamic> moduleDefinition) {
//     return ModuleHeaderWidget(
//       title: module.title,
//       subtitle: moduleDefinition['subtitle'],
//       icon: moduleDefinition['icon'],
//       primaryColor: moduleDefinition['color'],
//       completedLevels: module.levels.where((level) => level.isCompleted).length,
//       totalLevels: module.levels.length,
//       onTap: () {
//         print('Module ${moduleDefinition['id']} header tapped!');
//       },
//     );
//   }
//
//   Widget _buildUserBadges(Map<String, dynamic> moduleDefinition) {
//     // Calculate level ID range for this module
//     int moduleId = moduleDefinition['id'];
//     int startLevelId = (moduleId - 1) * 3 + 1; // Module 1: 1-3, Module 2: 4-6, etc.
//     int endLevelId = moduleId * 3;
//
//     // Filter user progress for this module's levels
//     Map<int, Map<String, dynamic>> moduleProgress = {};
//     for (int levelId = startLevelId; levelId <= endLevelId; levelId++) {
//       if (_userProgress.containsKey(levelId)) {
//         // Map to relative level ID (1, 2, 3) for the badge widget
//         int relativeLevelId = levelId - startLevelId + 1;
//         moduleProgress[relativeLevelId] = _userProgress[levelId]!;
//       }
//     }
//
//     return UserBadgesWidget(
//       userProgress: moduleProgress,
//       title: 'Your Achievements',
//       maxLevels: 3,
//       showEmptyState: true,
//       emptyStateText: 'Complete levels to earn badges!',
//     );
//   }
//   Widget _buildZigzagModule(List<LevelData> levels, Map<String, dynamic> moduleDefinition) {
//     // Convert your LevelData to ZigzagLevelData
//     List<ZigzagLevelData> zigzagLevels = levels.map((level) =>
//         ZigzagLevelData(
//           id: level.id,
//           title: level.title,
//           isCompleted: level.isCompleted,
//           isUnlocked: level.isUnlocked,
//           stars: level.stars,
//           data: level.scenarioData,
//         )
//     ).toList();
//
//     return ZigzagModuleWidget(
//       levels: zigzagLevels,
//       onLevelTap: (zigzagLevel) {
//         // Convert ZigzagLevelData back to LevelData before calling _onLevelTap
//         final originalLevel = levels.firstWhere((level) => level.id == zigzagLevel.id);
//         _onLevelTap(originalLevel, moduleDefinition);
//       },
//       showConnectors: true,
//       levelSize: 70,
//       pathColor: Colors.white,
//     );
//   }
//
//
//   Widget _buildModuleBadge(ModuleData module, Map<String, dynamic> moduleDefinition) {
//     bool isModuleCompleted = module.levels.every((level) => level.isCompleted);
//
//     return Container(
//       margin: EdgeInsets.only(top: 20),
//       child: GestureDetector(
//         onTap: isModuleCompleted ? () => _onBadgeTap(module) : null,
//         child: Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             color: isModuleCompleted
//                 ? moduleDefinition['color']
//                 : Colors.grey[400],
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.white,
//               width: 4,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: (isModuleCompleted
//                     ? moduleDefinition['color']
//                     : Colors.grey[400]!).withOpacity(0.3),
//                 blurRadius: 15,
//                 offset: Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Center(
//             child: isModuleCompleted
//                 ? Icon(
//               Icons.military_tech,
//               color: Colors.white,
//               size: 35,
//             )
//                 : Icon(
//               Icons.lock,
//               color: Colors.grey[600],
//               size: 30,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   int _calculateStarsFromProgress(Map<String, dynamic> levelProgress) {
//     if (levelProgress['isCompleted'] == true) {
//       int correctAnswers = levelProgress['correctAnswers'] ?? 0;
//       int totalAnswers = levelProgress['totalAnswers'] ?? 0;
//
//       if (totalAnswers > 0) {
//         double percentage = correctAnswers / totalAnswers;
//         if (percentage >= 0.9) return 3;
//         if (percentage >= 0.7) return 2;
//         if (percentage >= 0.5) return 1;
//       }
//
//       return 1;
//     }
//
//     return 0;
//   }
//
//   void _onLevelTap(LevelData level, Map<String, dynamic> moduleDefinition) {
//     print('\n🎯 === LEVEL ${level.id} TAPPED (Module ${moduleDefinition['id']}) ===');
//     print('Module: ${moduleDefinition['title']}');
//     print('Title: ${level.title}');
//     print('Is Completed: ${level.isCompleted}');
//     print('Is Unlocked: ${level.isUnlocked}');
//     print('Stars: ${level.stars}');
//     print('User Progress for this level: ${_userProgress[level.id]}');
//
//     // For Module 1 (Human-Centered Mindset), use JSON data
//     if (moduleDefinition['id'] == 2 && moduleDefinition['hasJsonData']) {
//       try {
//         final educationModule = JsonDataManager2.getModule();
//         final currentLevel = educationModule.getLevelByNumber(level.id);
//
//         if (currentLevel != null) {
//           print('\n📚 === DETAILED LEVEL INFO ===');
//           print('Level Name: ${currentLevel.level}');
//           print('Level Type: ${currentLevel.levelType}');
//           print('Total Scenarios: ${currentLevel.scenarios.length}');
//
//           for (int i = 0; i < currentLevel.scenarios.length; i++) {
//             final scenario = currentLevel.scenarios[i];
//             print('  ${i + 1}. ${scenario.title}');
//             print('     - ${scenario.options.length} options');
//             print('     - ${scenario.activity.cards.length} activity cards');
//             print('     - Activity: ${scenario.activity.name}');
//           }
//           print('=== END DETAILED INFO ===\n');
//         }
//       } catch (e) {
//         print('❌ Error printing level details: $e');
//       }
//
//       // Navigate to the scenarios screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LevelScenariosScreen(
//             levelId: level.id,
//             levelName: level.title,
//           ),
//         ),
//       );
//     } else {
//       // For Module 2 (AI Ethics) or modules without JSON data
//       _showComingSoonDialog(moduleDefinition['title'], level.title);
//     }
//   }
//
//   void _showComingSoonDialog(String moduleName, String levelName) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Row(
//             children: [
//               Icon(Icons.construction, color: Color(0xFF9C27B0), size: 30),
//               SizedBox(width: 10),
//               Text('Coming Soon!'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 '$moduleName - $levelName',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 15),
//               Text(
//                 'This level is currently under development. Stay tuned for exciting content!',
//                 style: TextStyle(fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Got it!', style: TextStyle(color: Color(0xFF9C27B0))),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _onBadgeTap(ModuleData module) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('🏆 ${module.title} Badge Earned!'),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   /// Generate module data from definition
//   ModuleData _generateModuleFromDefinition(Map<String, dynamic> moduleDefinition) {
//     int moduleId = moduleDefinition['id'];
//
//     // For Module 1 (Human-Centered Mindset), use JSON data
//     if (moduleId == 1 && moduleDefinition['hasJsonData']) {
//       return _generateModuleFromJson(moduleDefinition);
//     }
//     // For Module 2 (AI Ethics) and others, generate placeholder data
//     else {
//       return _generatePlaceholderModule(moduleDefinition);
//     }
//   }
//
//   /// Generate placeholder module for modules without JSON data
//   ModuleData _generatePlaceholderModule(Map<String, dynamic> moduleDefinition) {
//     int moduleId = moduleDefinition['id'];
//     int startLevelId = (moduleId - 1) * 3 + 1; // Module 1: 1-3, Module 2: 4-6, etc.
//
//     List<String> levelTypes = ['Acquire', 'Deepen', 'Create'];
//     List<LevelData> levelDataList = [];
//
//     for (int i = 0; i < 3; i++) {
//       int levelId = startLevelId + i;
//
//       // Get user progress for this level
//       Map<String, dynamic>? levelProgress = _userProgress[levelId];
//       bool isCompleted = levelProgress?['isCompleted'] ?? false;
//       bool isUnlocked = _isLevelUnlocked(levelId, moduleId);
//
//       int stars = 0;
//       if (levelProgress != null) {
//         stars = levelProgress['starsEarned'] ??
//             levelProgress['stars'] ??
//             _calculateStarsFromProgress(levelProgress);
//         stars = stars.clamp(0, 3);
//       }
//
//       levelDataList.add(
//         LevelData(
//           id: levelId,
//           title: '${i + 1}. ${levelTypes[i]}',
//           isCompleted: isCompleted,
//           isUnlocked: isUnlocked,
//           stars: stars,
//           scenarioData: {
//             'id': levelId,
//             'levelName': 'Level ${i + 1} (${levelTypes[i]})',
//             'levelType': levelTypes[i],
//             'scenarios': [],
//             'totalScenarios': 0,
//           },
//         ),
//       );
//     }
//
//     return ModuleData(
//       title: moduleDefinition['title'],
//       levels: levelDataList,
//     );
//   }
//
//   /// Original method for Module 1 (Human-Centered Mindset)
//   ModuleData _generateModuleFromJson(Map<String, dynamic> moduleDefinition) {
//     try {
//       final educationModule = JsonDataManager2.getModule();
//       List<LevelData> levelDataList = [];
//
//       for (int levelIndex = 0; levelIndex < educationModule.levels.length; levelIndex++) {
//         final level = educationModule.levels[levelIndex];
//         int uniqueId = levelIndex + 1;
//
//         Map<String, dynamic>? levelProgress = _userProgress[uniqueId];
//         bool isCompleted = levelProgress?['isCompleted'] ?? false;
//         bool isUnlocked = _isLevelUnlocked(uniqueId, 1); // Module 1
//
//         int stars = 0;
//         if (levelProgress != null) {
//           stars = levelProgress['starsEarned'] ??
//               levelProgress['stars'] ??
//               _calculateStarsFromProgress(levelProgress);
//           stars = stars.clamp(0, 3);
//         }
//
//         String displayTitle = _formatLevelTitle(level.level);
//
//         Map<String, dynamic> scenarioData = {
//           'id': uniqueId,
//           'levelName': level.level,
//           'levelType': level.levelType,
//           'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
//           'totalScenarios': level.scenarios.length,
//         };
//
//         levelDataList.add(
//           LevelData(
//             id: uniqueId,
//             title: displayTitle,
//             isCompleted: isCompleted,
//             isUnlocked: isUnlocked,
//             stars: stars,
//             scenarioData: scenarioData,
//           ),
//         );
//       }
//
//       return ModuleData(
//         title: educationModule.moduleName,
//         levels: levelDataList,
//       );
//     } catch (e) {
//       print('❌ Error generating module from JSON: $e');
//       return _generatePlaceholderModule(moduleDefinition);
//     }
//   }
//
//   bool _isLevelUnlocked(int levelId, int moduleId) {
//     // Calculate relative level within module
//     int startLevelId = (moduleId - 1) * 3 + 1;
//     int relativeLevel = levelId - startLevelId + 1;
//
//     // First level of any module is always unlocked
//     if (relativeLevel == 1) {
//       return true;
//     }
//
//     // For subsequent levels, check if previous level is completed
//     int previousLevelId = levelId - 1;
//     Map<String, dynamic>? previousLevelProgress = _userProgress[previousLevelId];
//     bool isPreviousCompleted = previousLevelProgress?['isCompleted'] ?? false;
//
//     print('🔓 Checking unlock for Level $levelId (Module $moduleId): Previous level ($previousLevelId) completed: $isPreviousCompleted');
//
//     return isPreviousCompleted;
//   }
//
//   String _formatLevelTitle(String levelName) {
//     final regex = RegExp(r'Level (\d+) \((.+)\)');
//     final match = regex.firstMatch(levelName);
//
//     if (match != null) {
//       final levelNumber = match.group(1);
//       final levelType = match.group(2);
//       return '$levelNumber. $levelType';
//     }
//
//     return levelName;
//   }
// }
//
// import 'dart:math' as math;
// import 'package:artizen/json/JsonDataManagerEthics.dart';
// import 'package:flutter/material.dart';
//
// import '../data/UserDataService.dart';
// import '../json/JsonDataManager2.dart';
// import '../json/JsonDataManager.dart'; // Import for Module 2
// import '../models/LevelData.dart';
// import '../models/ModuleData.dart';
// import '../widgets/AnimatedSphere.dart';
// import '../widgets/DashboardHeader.dart';
// import '../widgets/LevelDetailsDialog.dart';
// import '../widgets/LoadingIndicator.dart';
// import '../widgets/ModuleHeaderWidget.dart';
// import '../widgets/UserBadgesWidget.dart';
// import '../widgets/ZigzagModuleWidget.dart';
// import 'LevelScenariosScreen.dart';
//
// class NewDashboard extends StatefulWidget {
//   const NewDashboard({super.key});
//
//   @override
//   _NewDashboardState createState() => _NewDashboardState();
// }
//
// class _NewDashboardState extends State<NewDashboard>
//     with TickerProviderStateMixin {
//   late AnimationController _floatingController;
//   late AnimationController _pathController;
//   late AnimationController _coinController;
//
//   // Use the service instead of Firebase instances
//   final UserDataService _userDataService = UserDataService();
//
//   bool _isLoading = true;
//   Map<int, Map<String, dynamic>> _userProgress = {};
//   Map<String, dynamic> _userProfile = {};
//   int _totalCoins = 0;
//
//   // Multiple module definitions
//   final List<Map<String, dynamic>> _moduleDefinitions = [
//     {
//       'id': 1,
//       'title': 'Human-Centered Mindset',
//       'subtitle': 'Building empathy and understanding in AI implementation',
//       'color': Color(0xFF4A90E2),
//       'icon': Icons.favorite,
//       'hasJsonData': true,
//       'levelPrefix': 'hcm', // Prefix for level IDs
//       'jsonManager': 'JsonDataManager2', // Specify which JSON manager to use
//     },
//     {
//       'id': 2,
//       'title': 'AI Ethics',
//       'subtitle': 'Understanding bias, fairness, and responsible AI development',
//       'color': Color(0xFF9C27B0),
//       'icon': Icons.balance,
//       'hasJsonData': true, // Changed to true since we have JSON data
//       'levelPrefix': 'aie', // Prefix for level IDs
//       'jsonManager': 'JsonDataManager', // Use JsonDataManager for Module 2
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeLevelHandler();
//     _fetchUserData();
//   }
//
//   void _initializeAnimations() {
//     _floatingController = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _pathController = AnimationController(
//       duration: Duration(milliseconds: 3000),
//       vsync: this,
//     );
//
//     _coinController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _pathController.forward();
//   }
//
//   void _initializeLevelHandler() {
//     // _levelTapHandler = LevelTapHandler(
//     //   context: context,
//     //   onLevelCompleted: _handleLevelCompleted,
//     // );
//   }
//
//   @override
//   void dispose() {
//     _floatingController.dispose();
//     _pathController.dispose();
//     _coinController.dispose();
//     super.dispose();
//   }
//
//   /// Fetch user data using the UserDataService
//   Future<void> _fetchUserData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final result = await _userDataService.fetchUserData();
//
//       if (result.isSuccess) {
//         setState(() {
//           _userProfile = result.profile;
//           _userProgress = result.progress;
//           _totalCoins = result.totalCoins;
//         });
//
//         // Debug print to check the progress data
//         print('🔍 User Progress Data:');
//         _userProgress.forEach((levelId, levelData) {
//           print('  Level $levelId: $levelData');
//         });
//       } else {
//         print('⚠️ Failed to fetch user data: ${result.error}');
//         _setDefaultUserData();
//       }
//     } catch (e) {
//       print('❌ Error in _fetchUserData: $e');
//       _setDefaultUserData();
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//
//       // Animate coins when data is loaded
//       _coinController.forward();
//     }
//   }
//
//   void _setDefaultUserData() {
//     setState(() {
//       _userProfile = {
//         'username': 'User',
//         'email': '',
//         'avatar': '',
//         'isActive': true,
//       };
//       _userProgress = {};
//       _totalCoins = 0;
//     });
//   }
//
//   void _handleRefresh() {
//     _coinController.reset();
//     _fetchUserData();
//   }
//
//   /// Check if Module 1 is completely finished
//   bool _isModule1Completed() {
//     // Module 1 has levels 1, 2, 3
//     for (int levelId = 1; levelId <= 3; levelId++) {
//       Map<String, dynamic>? levelProgress = _userProgress[levelId];
//       bool isCompleted = levelProgress?['isCompleted'] ?? false;
//       if (!isCompleted) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   /// Check if a module should be available (unlocked)
//   bool _isModuleUnlocked(int moduleId) {
//     if (moduleId == 1) {
//       // Module 1 is always unlocked
//       return true;
//     } else if (moduleId == 2) {
//       // Module 2 is unlocked when Module 1 is completed
//       return _isModule1Completed();
//     }
//     // Add more conditions for future modules
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: _isLoading ? _buildLoadingIndicator() : _buildGamePath(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return AnimatedLoadingIndicator(
//       message: 'Loading your progress...',
//       indicatorColor: Colors.white,
//       textColor: Colors.white,
//     );
//   }
//
//   Widget _buildHeader() {
//     return AIArtizenDashboardHeader(
//       displayName: _getUserDisplayName(),
//       userInitials: _getUserInitials(),
//       totalCoins: _totalCoins,
//       coinController: _coinController,
//       onRefresh: _handleRefresh,
//     );
//   }
//
//   String _getUserDisplayName() {
//     if (_userProfile['username'] != null && _userProfile['username'].isNotEmpty) {
//       return _userProfile['username'];
//     }
//     return 'User';
//   }
//
//   String _getUserInitials() {
//     String displayName = _getUserDisplayName();
//     if (displayName == 'User') return 'U';
//
//     List<String> parts = displayName.split(' ');
//     if (parts.length >= 2) {
//       return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
//     } else if (parts.isNotEmpty) {
//       return parts[0][0].toUpperCase();
//     }
//     return 'U';
//   }
//
//   Widget _buildGamePath() {
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             _buildFloatingMascot(),
//             SizedBox(height: 20),
//             // Build all modules
//             ..._buildAllModules(),
//             SizedBox(height: 100), // Extra space at bottom
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingMascot() {
//     return AnimatedSphere(
//       size: 80,
//       primaryColor: Color(0xFF4A90E2),
//       secondaryColor: Color(0xFF7B68EE),
//       child: Icon(
//         Icons.psychology,
//         size: 40,
//         color: Colors.white,
//       ),
//       onTap: () {
//         print("Mascot sphere tapped!");
//       },
//     );
//   }
//
//   List<Widget> _buildAllModules() {
//     List<Widget> moduleWidgets = [];
//
//     for (int i = 0; i < _moduleDefinitions.length; i++) {
//       final moduleDefinition = _moduleDefinitions[i];
//       bool isModuleUnlocked = _isModuleUnlocked(moduleDefinition['id']);
//
//       // Only show unlocked modules or show locked module with different styling
//       if (isModuleUnlocked || moduleDefinition['id'] <= 2) {
//         final moduleData = _generateModuleFromDefinition(moduleDefinition);
//
//         // Add module with animation delay
//         moduleWidgets.add(
//           AnimatedBuilder(
//             animation: _pathController,
//             builder: (context, child) {
//               double moduleDelay = 0.2 + (i * 0.3);
//
//               Widget moduleWidget = _buildModule(moduleData, moduleDefinition, isModuleUnlocked);
//
//               // If module is locked, add opacity and disable interactions
//               if (!isModuleUnlocked) {
//                 moduleWidget = Opacity(
//                   opacity: 0.5,
//                   child: IgnorePointer(
//                     child: moduleWidget,
//                   ),
//                 );
//               }
//
//               return FadeTransition(
//                 opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                   CurvedAnimation(
//                     parent: _pathController,
//                     curve: Interval(
//                       moduleDelay.clamp(0.0, 0.8),
//                       (moduleDelay + 0.4).clamp(0.0, 1.0),
//                       curve: Curves.easeOut,
//                     ),
//                   ),
//                 ),
//                 child: SlideTransition(
//                   position: Tween<Offset>(
//                     begin: Offset(0, 0.3),
//                     end: Offset.zero,
//                   ).animate(
//                     CurvedAnimation(
//                       parent: _pathController,
//                       curve: Interval(
//                         moduleDelay.clamp(0.0, 0.8),
//                         (moduleDelay + 0.4).clamp(0.0, 1.0),
//                         curve: Curves.easeOut,
//                       ),
//                     ),
//                   ),
//                   child: moduleWidget,
//                 ),
//               );
//             },
//           ),
//         );
//
//         // Add spacing between modules (except for the last one)
//         if (i < _moduleDefinitions.length - 1) {
//           moduleWidgets.add(SizedBox(height: 40));
//         }
//       }
//     }
//
//     return moduleWidgets;
//   }
//
//   Widget _buildModule(ModuleData moduleData, Map<String, dynamic> moduleDefinition, bool isUnlocked) {
//     return Column(
//       children: [
//         _buildModuleHeader(moduleData, moduleDefinition, isUnlocked),
//         if (isUnlocked) ...[
//           _buildZigzagModule(moduleData.levels, moduleDefinition),
//           _buildUserBadges(moduleDefinition),
//           _buildModuleBadge(moduleData, moduleDefinition),
//         ] else ...[
//           _buildLockedModuleContent(moduleDefinition),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildLockedModuleContent(Map<String, dynamic> moduleDefinition) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       margin: EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey[300]?.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.grey[400]!, width: 2),
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.lock,
//             size: 50,
//             color: Colors.grey[600],
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Complete Module 1 to unlock',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Finish all levels in Human-Centered Mindset',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildModuleHeader(ModuleData module, Map<String, dynamic> moduleDefinition, bool isUnlocked) {
//     return ModuleHeaderWidget(
//       title: module.title,
//       subtitle: isUnlocked ? moduleDefinition['subtitle'] : 'Complete previous module to unlock',
//       icon: moduleDefinition['icon'],
//       primaryColor: isUnlocked ? moduleDefinition['color'] : Colors.grey,
//       completedLevels: module.levels.where((level) => level.isCompleted).length,
//       totalLevels: module.levels.length,
//       onTap: isUnlocked ? () {
//         print('Module ${moduleDefinition['id']} header tapped!');
//       } : null,
//     );
//   }
//
//   Widget _buildUserBadges(Map<String, dynamic> moduleDefinition) {
//     // Calculate level ID range for this module
//     int moduleId = moduleDefinition['id'];
//     int startLevelId = (moduleId - 1) * 3 + 1; // Module 1: 1-3, Module 2: 4-6, etc.
//     int endLevelId = moduleId * 3;
//
//     // Filter user progress for this module's levels
//     Map<int, Map<String, dynamic>> moduleProgress = {};
//     for (int levelId = startLevelId; levelId <= endLevelId; levelId++) {
//       if (_userProgress.containsKey(levelId)) {
//         // Map to relative level ID (1, 2, 3) for the badge widget
//         int relativeLevelId = levelId - startLevelId + 1;
//         moduleProgress[relativeLevelId] = _userProgress[levelId]!;
//       }
//     }
//
//     return UserBadgesWidget(
//       userProgress: moduleProgress,
//       title: 'Your Achievements',
//       maxLevels: 3,
//       showEmptyState: true,
//       emptyStateText: 'Complete levels to earn badges!',
//     );
//   }
//
//   Widget _buildZigzagModule(List<LevelData> levels, Map<String, dynamic> moduleDefinition) {
//     // Convert your LevelData to ZigzagLevelData
//     List<ZigzagLevelData> zigzagLevels = levels.map((level) =>
//         ZigzagLevelData(
//           id: level.id,
//           title: level.title,
//           isCompleted: level.isCompleted,
//           isUnlocked: level.isUnlocked,
//           stars: level.stars,
//           data: level.scenarioData,
//         )
//     ).toList();
//
//     return ZigzagModuleWidget(
//       levels: zigzagLevels,
//       onLevelTap: (zigzagLevel) {
//         // Convert ZigzagLevelData back to LevelData before calling _onLevelTap
//         final originalLevel = levels.firstWhere((level) => level.id == zigzagLevel.id);
//         _onLevelTap(originalLevel, moduleDefinition);
//       },
//       showConnectors: true,
//       levelSize: 70,
//       pathColor: Colors.white,
//     );
//   }
//
//   Widget _buildModuleBadge(ModuleData module, Map<String, dynamic> moduleDefinition) {
//     bool isModuleCompleted = module.levels.every((level) => level.isCompleted);
//
//     return Container(
//       margin: EdgeInsets.only(top: 20),
//       child: GestureDetector(
//         onTap: isModuleCompleted ? () => _onBadgeTap(module) : null,
//         child: Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             color: isModuleCompleted
//                 ? moduleDefinition['color']
//                 : Colors.grey[400],
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.white,
//               width: 4,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: (isModuleCompleted
//                     ? moduleDefinition['color']
//                     : Colors.grey[400]!).withOpacity(0.3),
//                 blurRadius: 15,
//                 offset: Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Center(
//             child: isModuleCompleted
//                 ? Icon(
//               Icons.military_tech,
//               color: Colors.white,
//               size: 35,
//             )
//                 : Icon(
//               Icons.lock,
//               color: Colors.grey[600],
//               size: 30,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   int _calculateStarsFromProgress(Map<String, dynamic> levelProgress) {
//     if (levelProgress['isCompleted'] == true) {
//       int correctAnswers = levelProgress['correctAnswers'] ?? 0;
//       int totalAnswers = levelProgress['totalAnswers'] ?? 0;
//
//       if (totalAnswers > 0) {
//         double percentage = correctAnswers / totalAnswers;
//         if (percentage >= 0.9) return 3;
//         if (percentage >= 0.7) return 2;
//         if (percentage >= 0.5) return 1;
//       }
//
//       return 1;
//     }
//
//     return 0;
//   }
//
//   void _onLevelTap(LevelData level, Map<String, dynamic> moduleDefinition) {
//     print('\n🎯 === LEVEL ${level.id} TAPPED (Module ${moduleDefinition['id']}) ===');
//     print('Module: ${moduleDefinition['title']}');
//     print('Title: ${level.title}');
//     print('Is Completed: ${level.isCompleted}');
//     print('Is Unlocked: ${level.isUnlocked}');
//     print('Stars: ${level.stars}');
//     print('User Progress for this level: ${_userProgress[level.id]}');
//
//     // Check if module has JSON data
//     if (moduleDefinition['hasJsonData']) {
//       try {
//         dynamic educationModule;
//
//         // Use the appropriate JSON manager based on module definition
//         if (moduleDefinition['jsonManager'] == 'JsonDataManager2') {
//           educationModule = JsonDataManager2.getModule();
//         } else if (moduleDefinition['jsonManager'] == 'JsonDataManager') {
//           educationModule = JsonDataManagerEthics.getModule();
//         } else {
//           throw Exception('Unknown JSON manager: ${moduleDefinition['jsonManager']}');
//         }
//
//         // Calculate the level number within the module (1, 2, or 3)
//         int moduleId = moduleDefinition['id'];
//         int startLevelId = (moduleId - 1) * 3 + 1;
//         int levelNumberInModule = level.id - startLevelId + 1;
//
//         final currentLevel = educationModule.getLevelByNumber(levelNumberInModule);
//
//         if (currentLevel != null) {
//           print('\n📚 === DETAILED LEVEL INFO ===');
//           print('Level Name: ${currentLevel.level}');
//           print('Level Type: ${currentLevel.levelType}');
//           print('Total Scenarios: ${currentLevel.scenarios.length}');
//
//           for (int i = 0; i < currentLevel.scenarios.length; i++) {
//             final scenario = currentLevel.scenarios[i];
//             print('  ${i + 1}. ${scenario.title}');
//             print('     - ${scenario.options.length} options');
//             print('     - ${scenario.activity.cards.length} activity cards');
//             print('     - Activity: ${scenario.activity.name}');
//           }
//           print('=== END DETAILED INFO ===\n');
//         }
//
//         // Navigate to the scenarios screen
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LevelScenariosScreen(
//               levelId: level.id,
//               levelName: level.title,
//             ),
//           ),
//         );
//       } catch (e) {
//         print('❌ Error loading level data: $e');
//         _showComingSoonDialog(moduleDefinition['title'], level.title);
//       }
//     } else {
//       // For modules without JSON data
//       _showComingSoonDialog(moduleDefinition['title'], level.title);
//     }
//   }
//
//   void _showComingSoonDialog(String moduleName, String levelName) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Row(
//             children: [
//               Icon(Icons.construction, color: Color(0xFF9C27B0), size: 30),
//               SizedBox(width: 10),
//               Text('Coming Soon!'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 '$moduleName - $levelName',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 15),
//               Text(
//                 'This level is currently under development. Stay tuned for exciting content!',
//                 style: TextStyle(fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Got it!', style: TextStyle(color: Color(0xFF9C27B0))),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _onBadgeTap(ModuleData module) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('🏆 ${module.title} Badge Earned!'),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   /// Generate module data from definition
//   ModuleData _generateModuleFromDefinition(Map<String, dynamic> moduleDefinition) {
//     int moduleId = moduleDefinition['id'];
//     bool isModuleUnlocked = _isModuleUnlocked(moduleId);
//
//     // If module is locked, return a basic module with locked levels
//     if (!isModuleUnlocked) {
//       return _generateLockedModule(moduleDefinition);
//     }
//
//     // If module has JSON data, use the appropriate JSON manager
//     if (moduleDefinition['hasJsonData']) {
//       return _generateModuleFromJson(moduleDefinition);
//     }
//     // Otherwise, generate placeholder data
//     else {
//       return _generatePlaceholderModule(moduleDefinition);
//     }
//   }
//
//   /// Generate locked module for modules that aren't unlocked yet
//   ModuleData _generateLockedModule(Map<String, dynamic> moduleDefinition) {
//     int moduleId = moduleDefinition['id'];
//     int startLevelId = (moduleId - 1) * 3 + 1;
//
//     List<LevelData> levelDataList = [];
//     for (int i = 0; i < 3; i++) {
//       int levelId = startLevelId + i;
//       levelDataList.add(
//         LevelData(
//           id: levelId,
//           title: 'Level ${i + 1}',
//           isCompleted: false,
//           isUnlocked: false,
//           stars: 0,
//           scenarioData: {},
//         ),
//       );
//     }
//
//     return ModuleData(
//       title: moduleDefinition['title'],
//       levels: levelDataList,
//     );
//   }
//
//   /// Generate placeholder module for modules without JSON data
//   ModuleData _generatePlaceholderModule(Map<String, dynamic> moduleDefinition) {
//     int moduleId = moduleDefinition['id'];
//     int startLevelId = (moduleId - 1) * 3 + 1; // Module 1: 1-3, Module 2: 4-6, etc.
//
//     List<String> levelTypes = ['Acquire', 'Deepen', 'Create'];
//     List<LevelData> levelDataList = [];
//
//     for (int i = 0; i < 3; i++) {
//       int levelId = startLevelId + i;
//
//       // Get user progress for this level
//       Map<String, dynamic>? levelProgress = _userProgress[levelId];
//       bool isCompleted = levelProgress?['isCompleted'] ?? false;
//       bool isUnlocked = _isLevelUnlocked(levelId, moduleId);
//
//       int stars = 0;
//       if (levelProgress != null) {
//         stars = levelProgress['starsEarned'] ??
//             levelProgress['stars'] ??
//             _calculateStarsFromProgress(levelProgress);
//         stars = stars.clamp(0, 3);
//       }
//
//       levelDataList.add(
//         LevelData(
//           id: levelId,
//           title: '${i + 1}. ${levelTypes[i]}',
//           isCompleted: isCompleted,
//           isUnlocked: isUnlocked,
//           stars: stars,
//           scenarioData: {
//             'id': levelId,
//             'levelName': 'Level ${i + 1} (${levelTypes[i]})',
//             'levelType': levelTypes[i],
//             'scenarios': [],
//             'totalScenarios': 0,
//           },
//         ),
//       );
//     }
//
//     return ModuleData(
//       title: moduleDefinition['title'],
//       levels: levelDataList,
//     );
//   }
//
//   /// Generate module from JSON data (works for both JsonDataManager and JsonDataManager2)
//   ModuleData _generateModuleFromJson(Map<String, dynamic> moduleDefinition) {
//     try {
//       dynamic educationModule;
//
//       // Use the appropriate JSON manager based on module definition
//       if (moduleDefinition['jsonManager'] == 'JsonDataManager2') {
//         educationModule = JsonDataManager2.getModule();
//       } else if (moduleDefinition['jsonManager'] == 'JsonDataManager') {
//         educationModule = JsonDataManagerEthics.getModule();
//       } else {
//         throw Exception('Unknown JSON manager: ${moduleDefinition['jsonManager']}');
//       }
//
//       List<LevelData> levelDataList = [];
//       int moduleId = moduleDefinition['id'];
//       int startLevelId = (moduleId - 1) * 3 + 1; // Calculate starting level ID for this module
//
//       for (int levelIndex = 0; levelIndex < educationModule.levels.length && levelIndex < 3; levelIndex++) {
//         final level = educationModule.levels[levelIndex];
//         int uniqueId = startLevelId + levelIndex; // Use module-specific level IDs
//
//         Map<String, dynamic>? levelProgress = _userProgress[uniqueId];
//         bool isCompleted = levelProgress?['isCompleted'] ?? false;
//         bool isUnlocked = _isLevelUnlocked(uniqueId, moduleId);
//
//         int stars = 0;
//         if (levelProgress != null) {
//           stars = levelProgress['starsEarned'] ??
//               levelProgress['stars'] ??
//               _calculateStarsFromProgress(levelProgress);
//           stars = stars.clamp(0, 3);
//         }
//
//         String displayTitle = _formatLevelTitle(level.level);
//
//         Map<String, dynamic> scenarioData = {
//           'id': uniqueId,
//           'levelName': level.level,
//           'levelType': level.levelType,
//           'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
//           'totalScenarios': level.scenarios.length,
//         };
//
//         levelDataList.add(
//           LevelData(
//             id: uniqueId,
//             title: displayTitle,
//             isCompleted: isCompleted,
//             isUnlocked: isUnlocked,
//             stars: stars,
//             scenarioData: scenarioData,
//           ),
//         );
//       }
//
//       return ModuleData(
//         title: educationModule.moduleName,
//         levels: levelDataList,
//       );
//     } catch (e) {
//       print('❌ Error generating module from JSON: $e');
//       return _generatePlaceholderModule(moduleDefinition);
//     }
//   }
//
//   bool _isLevelUnlocked(int levelId, int moduleId) {
//     // Calculate relative level within module
//     int startLevelId = (moduleId - 1) * 3 + 1;
//     int relativeLevel = levelId - startLevelId + 1;
//
//     // First level of any module is always unlocked (if the module itself is unlocked)
//     if (relativeLevel == 1) {
//       return _isModuleUnlocked(moduleId);
//     }
//
//     // For subsequent levels, check if previous level is completed
//     int previousLevelId = levelId - 1;
//     Map<String, dynamic>? previousLevelProgress = _userProgress[previousLevelId];
//     bool isPreviousCompleted = previousLevelProgress?['isCompleted'] ?? false;
//
//     print('🔓 Checking unlock for Level $levelId (Module $moduleId): Previous level ($previousLevelId) completed: $isPreviousCompleted');
//
//     return isPreviousCompleted && _isModuleUnlocked(moduleId);
//   }
//
//   String _formatLevelTitle(String levelName) {
//     final regex = RegExp(r'Level (\d+) \((.+)\)');
//     final match = regex.firstMatch(levelName);
//
//     if (match != null) {
//       final levelNumber = match.group(1);
//       final levelType = match.group(2);
//       return '$levelNumber. $levelType';
//     }
//
//     return levelName;
//   }
// }


import 'dart:math' as math;
import 'package:artizen/json/JsonDataManagerEthics.dart';
import 'package:flutter/material.dart';

import '../data/UserDataService.dart';
import '../json/JsonDataManager2.dart';
import '../json/JsonDataManager.dart';
import '../models/LevelData.dart';
import '../models/ModuleData.dart';
import '../widgets/AnimatedSphere.dart';
import '../widgets/DashboardHeader.dart';
import '../widgets/LevelDetailsDialog.dart';
import '../widgets/LoadingIndicator.dart';
import '../widgets/ModuleHeaderWidget.dart';
import '../widgets/UserBadgesWidget.dart';
import '../widgets/ZigzagModuleWidget.dart';
import 'LevelScenariosScreen.dart';

class NewDashboard extends StatefulWidget {
  const NewDashboard({super.key});

  @override
  _NewDashboardState createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pathController;
  late AnimationController _coinController;

  final UserDataService _userDataService = UserDataService();

  bool _isLoading = true;
  Map<String, Map<int, Map<String, dynamic>>> _moduleProgress = {}; // Module-specific progress
  Map<String, dynamic> _userProfile = {};
  int _totalCoins = 0;

  // Independent module definitions - each module is self-contained
  final List<ModuleDefinition> _moduleDefinitions = [
    ModuleDefinition(
      id: 'human_centered_mindset',
      title: 'Human-Centered Mindset',
      subtitle: 'Building empathy and understanding in AI implementation',
      color: Color(0xFF4A90E2),
      icon: Icons.favorite,
      jsonManager: 'JsonDataManager2',
      maxLevels: 3,
      isAlwaysUnlocked: true, // This module is always available
    ),
    ModuleDefinition(
      id: 'ai_ethics',
      title: 'AI Ethics',
      subtitle: 'Understanding bias, fairness, and responsible AI development',
      color: Color(0xFF9C27B0),
      icon: Icons.balance,
      jsonManager: 'JsonDataManager',
      maxLevels: 3,
      isAlwaysUnlocked: true, // Make this independent too
    ),
    ModuleDefinition(
      id: 'machine_learning_basics',
      title: 'Machine Learning Basics',
      subtitle: 'Core concepts and fundamentals of ML',
      color: Color(0xFF2E7D32),
      icon: Icons.memory,
      jsonManager: null, // No JSON data yet
      maxLevels: 3,
      isAlwaysUnlocked: true, // Independent module
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchUserData();
  }

  void _initializeAnimations() {
    _floatingController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pathController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _coinController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pathController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pathController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  /// Fetch user data with module-specific progress tracking
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _userDataService.fetchUserData();

      if (result.isSuccess) {
        setState(() {
          _userProfile = result.profile;
          _totalCoins = result.totalCoins;

          // Organize progress by module
          _moduleProgress = _organizeProgressByModule(result.progress);
        });

        // Debug print module-specific progress
        print('🔍 Module Progress Data:');
        _moduleProgress.forEach((moduleId, progress) {
          print('  Module $moduleId:');
          progress.forEach((levelId, levelData) {
            print('    Level $levelId: $levelData');
          });
        });
      } else {
        print('⚠️ Failed to fetch user data: ${result.error}');
        _setDefaultUserData();
      }
    } catch (e) {
      print('❌ Error in _fetchUserData: $e');
      _setDefaultUserData();
    } finally {
      setState(() {
        _isLoading = false;
      });
      _coinController.forward();
    }
  }

  /// Organize progress data by module
  Map<String, Map<int, Map<String, dynamic>>> _organizeProgressByModule(
      Map<int, Map<String, dynamic>> rawProgress) {
    Map<String, Map<int, Map<String, dynamic>>> organized = {};

    // Initialize each module with empty progress
    for (var moduleDef in _moduleDefinitions) {
      organized[moduleDef.id] = {};
    }

    // Distribute progress based on level IDs or module prefixes
    rawProgress.forEach((levelId, levelData) {
      String moduleId = _determineModuleFromLevelId(levelId, levelData);
      int moduleLevelId = _getModuleLevelId(levelId, moduleId);

      organized[moduleId] ??= {};
      organized[moduleId]![moduleLevelId] = levelData;
    });

    return organized;
  }

  /// Determine which module a level belongs to
  String _determineModuleFromLevelId(int levelId, Map<String, dynamic> levelData) {
    // Check if level data contains module information
    if (levelData.containsKey('moduleId')) {
      return levelData['moduleId'];
    }

    // Fallback: distribute by level ID ranges (for backward compatibility)
    if (levelId >= 1 && levelId <= 3) {
      return 'human_centered_mindset';
    } else if (levelId >= 4 && levelId <= 6) {
      return 'ai_ethics';
    } else if (levelId >= 7 && levelId <= 9) {
      return 'machine_learning_basics';
    }

    // Default to first module
    return _moduleDefinitions.first.id;
  }

  /// Get the level ID within a specific module (1, 2, 3)
  int _getModuleLevelId(int globalLevelId, String moduleId) {
    // For backward compatibility with existing level IDs
    if (moduleId == 'human_centered_mindset') {
      return globalLevelId <= 3 ? globalLevelId : (globalLevelId % 3) + 1;
    } else if (moduleId == 'ai_ethics') {
      return globalLevelId >= 4 && globalLevelId <= 6 ? globalLevelId - 3 : (globalLevelId % 3) + 1;
    }

    // Default: assume 1-3 numbering within module
    return (globalLevelId % 3) == 0 ? 3 : (globalLevelId % 3);
  }

  void _setDefaultUserData() {
    setState(() {
      _userProfile = {
        'username': 'User',
        'email': '',
        'avatar': '',
        'isActive': true,
      };
      _moduleProgress = {};
      _totalCoins = 0;
    });
  }

  void _handleRefresh() {
    _coinController.reset();
    _fetchUserData();
  }

  /// Check if a specific module is completed
  bool _isModuleCompleted(String moduleId) {
    var moduleProgress = _moduleProgress[moduleId] ?? {};
    var moduleDef = _moduleDefinitions.firstWhere((m) => m.id == moduleId);

    for (int levelId = 1; levelId <= moduleDef.maxLevels; levelId++) {
      bool isCompleted = moduleProgress[levelId]?['isCompleted'] ?? false;
      if (!isCompleted) {
        return false;
      }
    }
    return true;
  }

  /// Check if a module should be available (for independent modules, always true)
  bool _isModuleUnlocked(String moduleId) {
    var moduleDef = _moduleDefinitions.firstWhere((m) => m.id == moduleId);
    return moduleDef.isAlwaysUnlocked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoading ? _buildLoadingIndicator() : _buildGamePath(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return AnimatedLoadingIndicator(
      message: 'Loading your progress...',
      indicatorColor: Colors.white,
      textColor: Colors.white,
    );
  }

  Widget _buildHeader() {
    return AIArtizenDashboardHeader(
      displayName: _getUserDisplayName(),
      userInitials: _getUserInitials(),
      totalCoins: _totalCoins,
      coinController: _coinController,
      onRefresh: _handleRefresh,
    );
  }

  String _getUserDisplayName() {
    if (_userProfile['username'] != null && _userProfile['username'].isNotEmpty) {
      return _userProfile['username'];
    }
    return 'User';
  }

  String _getUserInitials() {
    String displayName = _getUserDisplayName();
    if (displayName == 'User') return 'U';

    List<String> parts = displayName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  Widget _buildGamePath() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _buildFloatingMascot(),
            SizedBox(height: 20),
            ..._buildAllModules(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingMascot() {
    return AnimatedSphere(
      size: 80,
      primaryColor: Color(0xFF4A90E2),
      secondaryColor: Color(0xFF7B68EE),
      child: Icon(
        Icons.psychology,
        size: 40,
        color: Colors.white,
      ),
      onTap: () {
        print("Mascot sphere tapped!");
      },
    );
  }

  List<Widget> _buildAllModules() {
    List<Widget> moduleWidgets = [];

    for (int i = 0; i < _moduleDefinitions.length; i++) {
      final moduleDefinition = _moduleDefinitions[i];
      bool isModuleUnlocked = _isModuleUnlocked(moduleDefinition.id);

      final moduleData = _generateModuleData(moduleDefinition);

      moduleWidgets.add(
        AnimatedBuilder(
          animation: _pathController,
          builder: (context, child) {
            double moduleDelay = 0.2 + (i * 0.3);

            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _pathController,
                  curve: Interval(
                    moduleDelay.clamp(0.0, 0.8),
                    (moduleDelay + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _pathController,
                    curve: Interval(
                      moduleDelay.clamp(0.0, 0.8),
                      (moduleDelay + 0.4).clamp(0.0, 1.0),
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: _buildModule(moduleData, moduleDefinition),
              ),
            );
          },
        ),
      );

      if (i < _moduleDefinitions.length - 1) {
        moduleWidgets.add(SizedBox(height: 40));
      }
    }

    return moduleWidgets;
  }

  Widget _buildModule(ModuleData moduleData, ModuleDefinition moduleDefinition) {
    return Column(
      children: [
        _buildModuleHeader(moduleData, moduleDefinition),
        _buildZigzagModule(moduleData.levels, moduleDefinition),
        _buildUserBadges(moduleDefinition),
        _buildModuleBadge(moduleData, moduleDefinition),
      ],
    );
  }

  Widget _buildModuleHeader(ModuleData module, ModuleDefinition moduleDefinition) {
    return ModuleHeaderWidget(
      title: module.title,
      subtitle: moduleDefinition.subtitle,
      icon: moduleDefinition.icon,
      primaryColor: moduleDefinition.color,
      completedLevels: module.levels.where((level) => level.isCompleted).length,
      totalLevels: module.levels.length,
      onTap: () {
        print('Module ${moduleDefinition.id} header tapped!');
      },
    );
  }

  Widget _buildUserBadges(ModuleDefinition moduleDefinition) {
    var moduleProgress = _moduleProgress[moduleDefinition.id] ?? {};

    return UserBadgesWidget(
      userProgress: moduleProgress,
      title: 'Module Achievements',
      maxLevels: moduleDefinition.maxLevels,
      showEmptyState: true,
      emptyStateText: 'Complete levels to earn badges!',
    );
  }

  Widget _buildZigzagModule(List<LevelData> levels, ModuleDefinition moduleDefinition) {
    List<ZigzagLevelData> zigzagLevels = levels.map((level) =>
        ZigzagLevelData(
          id: level.id,
          title: level.title,
          isCompleted: level.isCompleted,
          isUnlocked: level.isUnlocked,
          stars: level.stars,
          data: level.scenarioData,
        )
    ).toList();

    return ZigzagModuleWidget(
      levels: zigzagLevels,
      onLevelTap: (zigzagLevel) {
        final originalLevel = levels.firstWhere((level) => level.id == zigzagLevel.id);
        _onLevelTap(originalLevel, moduleDefinition);
      },
      showConnectors: true,
      levelSize: 70,
      pathColor: Colors.white,
    );
  }

  Widget _buildModuleBadge(ModuleData module, ModuleDefinition moduleDefinition) {
    bool isModuleCompleted = module.levels.every((level) => level.isCompleted);

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: isModuleCompleted ? () => _onBadgeTap(module, moduleDefinition) : null,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isModuleCompleted ? moduleDefinition.color : Colors.grey[400],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: (isModuleCompleted ? moduleDefinition.color : Colors.grey[400]!)
                    .withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: isModuleCompleted
                ? Icon(Icons.military_tech, color: Colors.white, size: 35)
                : Icon(Icons.lock, color: Colors.grey[600], size: 30),
          ),
        ),
      ),
    );
  }

  /// Generate module data independently
  ModuleData _generateModuleData(ModuleDefinition moduleDefinition) {
    if (moduleDefinition.jsonManager != null) {
      return _generateModuleFromJson(moduleDefinition);
    } else {
      return _generatePlaceholderModule(moduleDefinition);
    }
  }

  /// Generate module from JSON data
  ModuleData _generateModuleFromJson(ModuleDefinition moduleDefinition) {
    try {
      dynamic educationModule;

      if (moduleDefinition.jsonManager == 'JsonDataManager2') {
        educationModule = JsonDataManager2.getModule();
      } else if (moduleDefinition.jsonManager == 'JsonDataManager') {
        educationModule = JsonDataManagerEthics.getModule();
      } else {
        throw Exception('Unknown JSON manager: ${moduleDefinition.jsonManager}');
      }

      List<LevelData> levelDataList = [];
      var moduleProgress = _moduleProgress[moduleDefinition.id] ?? {};

      for (int levelIndex = 0; levelIndex < educationModule.levels.length && levelIndex < moduleDefinition.maxLevels; levelIndex++) {
        final level = educationModule.levels[levelIndex];
        int levelId = levelIndex + 1; // Module-specific level ID (1, 2, 3)

        Map<String, dynamic>? levelProgress = moduleProgress[levelId];
        bool isCompleted = levelProgress?['isCompleted'] ?? false;
        bool isUnlocked = _isLevelUnlockedInModule(levelId, moduleDefinition.id);

        int stars = 0;
        if (levelProgress != null) {
          stars = levelProgress['starsEarned'] ??
              levelProgress['stars'] ??
              _calculateStarsFromProgress(levelProgress);
          stars = stars.clamp(0, 3);
        }

        String displayTitle = _formatLevelTitle(level.level);

        Map<String, dynamic> scenarioData = {
          'id': levelId,
          'moduleId': moduleDefinition.id,
          'levelName': level.level,
          'levelType': level.levelType,
          'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
          'totalScenarios': level.scenarios.length,
        };

        levelDataList.add(
          LevelData(
            id: levelId,
            title: displayTitle,
            isCompleted: isCompleted,
            isUnlocked: isUnlocked,
            stars: stars,
            scenarioData: scenarioData,
          ),
        );
      }

      return ModuleData(
        title: educationModule.moduleName,
        levels: levelDataList,
      );
    } catch (e) {
      print('❌ Error generating module from JSON: $e');
      return _generatePlaceholderModule(moduleDefinition);
    }
  }

  /// Generate placeholder module
  ModuleData _generatePlaceholderModule(ModuleDefinition moduleDefinition) {
    List<String> levelTypes = ['Acquire', 'Deepen', 'Create'];
    List<LevelData> levelDataList = [];
    var moduleProgress = _moduleProgress[moduleDefinition.id] ?? {};

    for (int i = 0; i < moduleDefinition.maxLevels; i++) {
      int levelId = i + 1;

      Map<String, dynamic>? levelProgress = moduleProgress[levelId];
      bool isCompleted = levelProgress?['isCompleted'] ?? false;
      bool isUnlocked = _isLevelUnlockedInModule(levelId, moduleDefinition.id);

      int stars = 0;
      if (levelProgress != null) {
        stars = levelProgress['starsEarned'] ??
            levelProgress['stars'] ??
            _calculateStarsFromProgress(levelProgress);
        stars = stars.clamp(0, 3);
      }

      levelDataList.add(
        LevelData(
          id: levelId,
          title: '${levelId}. ${levelTypes[i % levelTypes.length]}',
          isCompleted: isCompleted,
          isUnlocked: isUnlocked,
          stars: stars,
          scenarioData: {
            'id': levelId,
            'moduleId': moduleDefinition.id,
            'levelName': 'Level $levelId (${levelTypes[i % levelTypes.length]})',
            'levelType': levelTypes[i % levelTypes.length],
            'scenarios': [],
            'totalScenarios': 0,
          },
        ),
      );
    }

    return ModuleData(
      title: moduleDefinition.title,
      levels: levelDataList,
    );
  }

  /// Check if a level is unlocked within its module
  bool _isLevelUnlockedInModule(int levelId, String moduleId) {
    // First level is always unlocked
    if (levelId == 1) {
      return true;
    }

    // Check if previous level is completed
    var moduleProgress = _moduleProgress[moduleId] ?? {};
    int previousLevelId = levelId - 1;
    Map<String, dynamic>? previousLevelProgress = moduleProgress[previousLevelId];
    bool isPreviousCompleted = previousLevelProgress?['isCompleted'] ?? false;

    print('🔓 Module $moduleId - Level $levelId unlock check: Previous level completed: $isPreviousCompleted');

    return isPreviousCompleted;
  }

  int _calculateStarsFromProgress(Map<String, dynamic> levelProgress) {
    if (levelProgress['isCompleted'] == true) {
      int correctAnswers = levelProgress['correctAnswers'] ?? 0;
      int totalAnswers = levelProgress['totalAnswers'] ?? 0;

      if (totalAnswers > 0) {
        double percentage = correctAnswers / totalAnswers;
        if (percentage >= 0.9) return 3;
        if (percentage >= 0.7) return 2;
        if (percentage >= 0.5) return 1;
      }
      return 1;
    }
    return 0;
  }

  void _onLevelTap(LevelData level, ModuleDefinition moduleDefinition) {
    print('\n🎯 === LEVEL ${level.id} TAPPED (Module ${moduleDefinition.id}) ===');
    print('Module: ${moduleDefinition.title}');
    print('Title: ${level.title}');
    print('Is Completed: ${level.isCompleted}');
    print('Is Unlocked: ${level.isUnlocked}');
    print('Stars: ${level.stars}');

    if (moduleDefinition.jsonManager != null) {
      try {
        dynamic educationModule;

        if (moduleDefinition.jsonManager == 'JsonDataManager2') {
          educationModule = JsonDataManager2.getModule();
        } else if (moduleDefinition.jsonManager == 'JsonDataManager') {
          educationModule = JsonDataManagerEthics.getModule();
        } else {
          throw Exception('Unknown JSON manager: ${moduleDefinition.jsonManager}');
        }

        final currentLevel = educationModule.getLevelByNumber(level.id);

        if (currentLevel != null) {
          print('\n📚 === DETAILED LEVEL INFO ===');
          print('Level Name: ${currentLevel.level}');
          print('Level Type: ${currentLevel.levelType}');
          print('Total Scenarios: ${currentLevel.scenarios.length}');
          print('=== END DETAILED INFO ===\n');
        }

        // Navigate with module-specific level data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelScenariosScreen(
              levelId: level.id,
              levelName: level.title,
              moduleID: moduleDefinition.id, // Pass module ID
            ),
          ),
        );
      } catch (e) {
        print('❌ Error loading level data: $e');
        _showComingSoonDialog(moduleDefinition.title, level.title);
      }
    } else {
      _showComingSoonDialog(moduleDefinition.title, level.title);
    }
  }

  void _showComingSoonDialog(String moduleName, String levelName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.construction, color: Color(0xFF9C27B0), size: 30),
              SizedBox(width: 10),
              Text('Coming Soon!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$moduleName - $levelName',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Text(
                'This level is currently under development. Stay tuned for exciting content!',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it!', style: TextStyle(color: Color(0xFF9C27B0))),
            ),
          ],
        );
      },
    );
  }

  void _onBadgeTap(ModuleData module, ModuleDefinition moduleDefinition) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🏆 ${module.title} Badge Earned!'),
        backgroundColor: moduleDefinition.color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatLevelTitle(String levelName) {
    final regex = RegExp(r'Level (\d+) \((.+)\)');
    final match = regex.firstMatch(levelName);

    if (match != null) {
      final levelNumber = match.group(1);
      final levelType = match.group(2);
      return '$levelNumber. $levelType';
    }

    return levelName;
  }
}

/// Independent module definition class
class ModuleDefinition {
  final String id;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final String? jsonManager;
  final int maxLevels;
  final bool isAlwaysUnlocked;

  ModuleDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.jsonManager,
    this.maxLevels = 3,
    this.isAlwaysUnlocked = false,
  });
}
