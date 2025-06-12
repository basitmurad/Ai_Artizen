// // import 'dart:math' as math;
// // import 'package:flutter/material.dart';
// //
// // import '../data/UserDataService.dart';
// // import '../json/JsonDataManager2.dart';
// // import '../models/LevelData.dart';
// // import '../models/ModuleData.dart';
// // import '../widgets/DashboardHeader.dart';
// // import '../widgets/LevelDetailsDialog.dart';
// // import '../widgets/LoadingIndicator.dart';
// // import 'LevelScenariosScreen.dart';
// //
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
// //   // Level tap handler
// //   late LevelTapHandler _levelTapHandler;
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
// //     _levelTapHandler = LevelTapHandler(
// //       context: context,
// //       onLevelCompleted: _handleLevelCompleted,
// //     );
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
// //   void _handleLevelCompleted(Map<String, dynamic> result) {
// //     print('🔄 Level completed, refreshing progress...');
// //     _showCompletionFeedback(result);
// //     _coinController.reset();
// //     _fetchUserData();
// //   }
// //
// //   void _showCompletionFeedback(Map<String, dynamic> result) {
// //     final stars = result['stars'] ?? 0;
// //     final coins = stars * 10;
// //
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Row(
// //           children: [
// //             Icon(Icons.celebration, color: Colors.white),
// //             SizedBox(width: 8),
// //             Expanded(
// //               child: Text(
// //                 '🎉 Level completed! +$coins coins earned!',
// //                 style: TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //           ],
// //         ),
// //         backgroundColor: Colors.green,
// //         duration: Duration(seconds: 3),
// //         behavior: SnackBarBehavior.floating,
// //       ),
// //     );
// //   }
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
// //
// //   Widget _buildFloatingMascot() {
// //     return AnimatedBuilder(
// //       animation: _floatingController,
// //       builder: (context, child) {
// //         return Transform.translate(
// //           offset: Offset(
// //             0,
// //             math.sin(_floatingController.value * math.pi) * 5,
// //           ),
// //           child: Container(
// //             width: 80,
// //             height: 80,
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(40),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.1),
// //                   blurRadius: 10,
// //                   offset: Offset(0, 5),
// //                 ),
// //               ],
// //             ),
// //             child: Center(
// //               child: Icon(
// //                 Icons.psychology,
// //                 size: 40,
// //                 color: Color(0xFF4A90E2),
// //               ),
// //             ),
// //           ),
// //         );
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
// //                 _buildModuleBadge(moduleData),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildModuleHeader(ModuleData module) {
// //     int completedLevels = module.levels.where((level) => level.isCompleted).length;
// //     int totalLevels = module.levels.length;
// //     double progress = totalLevels > 0 ? completedLevels / totalLevels : 0.0;
// //
// //     return Container(
// //       margin: EdgeInsets.symmetric(vertical: 15),
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.15),
// //         borderRadius: BorderRadius.circular(25),
// //         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
// //         boxShadow: [
// //           BoxShadow(
// //             color: _moduleDefinition['color'].withOpacity(0.2),
// //             blurRadius: 15,
// //             offset: Offset(0, 8),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: _moduleDefinition['color'],
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Icon(
// //                   _moduleDefinition['icon'],
// //                   color: Colors.white,
// //                   size: 24,
// //                 ),
// //               ),
// //               SizedBox(width: 12),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       module.title,
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: 2),
// //                     Text(
// //                       _moduleDefinition['subtitle'],
// //                       style: TextStyle(
// //                         color: Colors.white.withOpacity(0.8),
// //                         fontSize: 13,
// //                         fontWeight: FontWeight.w400,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 15),
// //           _buildProgressBar(progress),
// //           SizedBox(height: 8),
// //           Text(
// //             '$completedLevels/$totalLevels levels completed',
// //             style: TextStyle(
// //               color: Colors.white.withOpacity(0.8),
// //               fontSize: 12,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildProgressBar(double progress) {
// //     return Container(
// //       height: 6,
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.3),
// //         borderRadius: BorderRadius.circular(3),
// //       ),
// //       child: FractionallySizedBox(
// //         alignment: Alignment.centerLeft,
// //         widthFactor: progress,
// //         child: Container(
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(3),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildZigzagModule(List<LevelData> levels) {
// //     return Column(
// //       children: levels.asMap().entries.map((entry) {
// //         int levelIndex = entry.key;
// //         LevelData level = entry.value;
// //
// //         bool isLeft = levelIndex % 2 == 0;
// //         double horizontalOffset = isLeft ? -0.3 : 0.3;
// //
// //         return AnimatedBuilder(
// //           animation: _pathController,
// //           builder: (context, child) {
// //             double totalLevels = levels.length.toDouble();
// //             double levelDelay = 0.1 + (levelIndex / totalLevels) * 0.4;
// //             double animationDuration = 0.2;
// //
// //             return FadeTransition(
// //               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
// //                 CurvedAnimation(
// //                   parent: _pathController,
// //                   curve: Interval(
// //                     levelDelay,
// //                     (levelDelay + animationDuration).clamp(0.0, 1.0),
// //                     curve: Curves.easeOut,
// //                   ),
// //                 ),
// //               ),
// //               child: SlideTransition(
// //                 position: Tween<Offset>(
// //                   begin: Offset(horizontalOffset, 0.5),
// //                   end: Offset.zero,
// //                 ).animate(
// //                   CurvedAnimation(
// //                     parent: _pathController,
// //                     curve: Interval(
// //                       levelDelay,
// //                       (levelDelay + animationDuration).clamp(0.0, 1.0),
// //                       curve: Curves.easeOut,
// //                     ),
// //                   ),
// //                 ),
// //                 child: Container(
// //                   margin: EdgeInsets.symmetric(vertical: 8),
// //                   child: Row(
// //                     mainAxisAlignment: isLeft
// //                         ? MainAxisAlignment.start
// //                         : MainAxisAlignment.end,
// //                     children: [
// //                       if (isLeft) SizedBox(width: 30),
// //                       _buildLevelNode(level),
// //                       if (!isLeft) SizedBox(width: 30),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       }).toList(),
// //     );
// //   }
// //
// //   Widget _buildLevelNode(LevelData level) {
// //     final nodeStyles = _getLevelNodeStyles(level);
// //
// //     return GestureDetector(
// //       onTap: level.isUnlocked ? () => _onLevelTap(level) : null,
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           _buildLevelCircle(level, nodeStyles),
// //           SizedBox(height: 6),
// //           if (level.isCompleted || level.isUnlocked) _buildStarsDisplay(level),
// //           if (level.isCompleted || level.isUnlocked) SizedBox(height: 4),
// //           if (level.isCompleted || level.isUnlocked) _buildLevelTitle(level),
// //         ],
// //       ),
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
// //   Map<String, dynamic> _getLevelNodeStyles(LevelData level) {
// //     if (level.isCompleted) {
// //       return {
// //         'color': Color(0xFF4CAF50),
// //         'icon': Icons.check,
// //         'iconColor': Colors.white,
// //         'displayText': '',
// //       };
// //     } else if (level.isUnlocked) {
// //       return {
// //         'color': Color(0xFFFFD700),
// //         'icon': Icons.play_arrow,
// //         'iconColor': Colors.white,
// //         'displayText': '${level.id}',
// //       };
// //     } else {
// //       return {
// //         'color': Colors.grey[400]!,
// //         'icon': Icons.lock,
// //         'iconColor': Colors.grey[600]!,
// //         'displayText': '',
// //       };
// //     }
// //   }
// //
// //   Widget _buildLevelCircle(LevelData level, Map<String, dynamic> styles) {
// //     return Container(
// //       width: 70,
// //       height: 70,
// //       decoration: BoxDecoration(
// //         color: styles['color'],
// //         shape: BoxShape.circle,
// //         border: Border.all(color: Colors.white, width: 4),
// //         boxShadow: [
// //           BoxShadow(
// //             color: styles['color'].withOpacity(0.3),
// //             blurRadius: 10,
// //             offset: Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: Center(
// //         child: level.isCompleted
// //             ? Icon(styles['icon'], color: styles['iconColor'], size: 30)
// //             : level.isUnlocked
// //             ? Text(
// //           styles['displayText'],
// //           style: TextStyle(
// //             color: styles['iconColor'],
// //             fontSize: 24,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         )
// //             : Icon(styles['icon'], color: styles['iconColor'], size: 25),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStarsDisplay(LevelData level) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.black.withOpacity(0.2),
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: List.generate(3, (index) {
// //           bool isStarEarned = index < level.stars;
// //           return Icon(
// //             isStarEarned ? Icons.star : Icons.star_border,
// //             color: isStarEarned ? Colors.yellow : Colors.white.withOpacity(0.5),
// //             size: 16,
// //           );
// //         }),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildLevelTitle(LevelData level) {
// //     return Container(
// //       width: 80,
// //       child: Text(
// //         level.title,
// //         style: TextStyle(
// //           color: Colors.white.withOpacity(0.8),
// //           fontSize: 11,
// //           fontWeight: FontWeight.w500,
// //         ),
// //         textAlign: TextAlign.center,
// //         maxLines: 2,
// //         overflow: TextOverflow.ellipsis,
// //       ),
// //     );
// //   }
// //   void _onLevelTap(LevelData level) {
// //     // Print level data when tapped for debugging
// //     print('\n🎯 === LEVEL ${level.id} TAPPED ===');
// //     print('Title: ${level.title}');
// //     print('Is Completed: ${level.isCompleted}');
// //     print('Is Unlocked: ${level.isUnlocked}');
// //     print('Stars: ${level.stars}');
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
// //
// //   /// Updated method to work with new JSON structure
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
// //         // Get user progress for this level
// //         Map<String, dynamic>? levelProgress = _userProgress[uniqueId];
// //         bool isCompleted = levelProgress?['completed'] ?? false;
// //
// //         // Unlock logic: First level is always unlocked, others unlock sequentially
// //         bool isUnlocked = uniqueId == 1;
// //         if (uniqueId > 1) {
// //           Map<String, dynamic>? previousProgress = _userProgress[uniqueId - 1];
// //           isUnlocked = previousProgress?['completed'] ?? false;
// //         }
// //
// //         // Calculate stars based on progress
// //         int stars = 0;
// //         if (isCompleted && levelProgress != null) {
// //           stars = (levelProgress['score'] ?? 0).clamp(0, 3);
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
// //   /// Helper method to format level titles for display
// //   String _formatLevelTitle(String levelName) {
// //     // Extract the level type from the full level name
// //     // "Level 1 (Acquire)" -> "Acquire"
// //     // "Level 2 (Deepen)" -> "Deepen"
// //     // "Level 3 (Create)" -> "Create"
// //
// //     final regex = RegExp(r'Level (\d+) \((.+)\)');
// //     final match = regex.firstMatch(levelName);
// //
// //     if (match != null) {
// //       final levelNumber = match.group(1);
// //       final levelType = match.group(2);
// //       return '$levelNumber. $levelType';
// //     }
// //
// //     // Fallback to original name if regex doesn't match
// //     return levelName;
// //   }
// //
// //
// //
// //
// // }
// //
//
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
//
// import '../data/UserDataService.dart';
// import '../json/JsonDataManager2.dart';
// import '../models/LevelData.dart';
// import '../models/ModuleData.dart';
// import '../widgets/DashboardHeader.dart';
// import '../widgets/LevelDetailsDialog.dart';
// import '../widgets/LoadingIndicator.dart';
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
//   // Level tap handler
//   late LevelTapHandler _levelTapHandler;
//
//   // Single module definition - Human-Centered Mindset with JSON data
//   final Map<String, dynamic> _moduleDefinition = {
//     'id': 1,
//     'title': 'Human-Centered Mindset',
//     'subtitle': 'Building empathy and understanding in AI implementation',
//     'color': Color(0xFF4A90E2),
//     'icon': Icons.favorite,
//     'hasJsonData': true,
//   };
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
//     _levelTapHandler = LevelTapHandler(
//       context: context,
//       onLevelCompleted: _handleLevelCompleted,
//     );
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
//   void _handleLevelCompleted(Map<String, dynamic> result) {
//     print('🔄 Level completed, refreshing progress...');
//     _showCompletionFeedback(result);
//     _coinController.reset();
//     _fetchUserData();
//   }
//
//   void _showCompletionFeedback(Map<String, dynamic> result) {
//     final stars = result['stars'] ?? 0;
//     final coins = stars * 10;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.celebration, color: Colors.white),
//             SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 '🎉 Level completed! +$coins coins earned!',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
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
//             _buildModule(),
//             SizedBox(height: 100), // Extra space at bottom
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFloatingMascot() {
//     return AnimatedBuilder(
//       animation: _floatingController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(
//             0,
//             math.sin(_floatingController.value * math.pi) * 5,
//           ),
//           child: Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(40),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Icon(
//                 Icons.psychology,
//                 size: 40,
//                 color: Color(0xFF4A90E2),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildModule() {
//     final moduleData = _generateModuleFromJson(_moduleDefinition);
//
//     return AnimatedBuilder(
//       animation: _pathController,
//       builder: (context, child) {
//         return FadeTransition(
//           opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//             CurvedAnimation(
//               parent: _pathController,
//               curve: Interval(0.0, 0.4, curve: Curves.easeOut),
//             ),
//           ),
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset(0, 0.3),
//               end: Offset.zero,
//             ).animate(
//               CurvedAnimation(
//                 parent: _pathController,
//                 curve: Interval(0.0, 0.4, curve: Curves.easeOut),
//               ),
//             ),
//             child: Column(
//               children: [
//                 _buildModuleHeader(moduleData),
//                 _buildZigzagModule(moduleData.levels),
//                 _buildUserBadges(), // Add user badges section
//                 _buildModuleBadge(moduleData),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildModuleHeader(ModuleData module) {
//     int completedLevels = module.levels.where((level) => level.isCompleted).length;
//     int totalLevels = module.levels.length;
//     double progress = totalLevels > 0 ? completedLevels / totalLevels : 0.0;
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 15),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: _moduleDefinition['color'].withOpacity(0.2),
//             blurRadius: 15,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: _moduleDefinition['color'],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   _moduleDefinition['icon'],
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       module.title,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       _moduleDefinition['subtitle'],
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 13,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 15),
//           _buildProgressBar(progress),
//           SizedBox(height: 8),
//           Text(
//             '$completedLevels/$totalLevels levels completed',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.8),
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressBar(double progress) {
//     return Container(
//       height: 6,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(3),
//       ),
//       child: FractionallySizedBox(
//         alignment: Alignment.centerLeft,
//         widthFactor: progress,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(3),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // New method to build user badges based on completed levels
//   Widget _buildUserBadges() {
//     List<Widget> badges = [];
//
//     // Check each level completion and add corresponding badge
//     for (int levelId = 1; levelId <= 3; levelId++) {
//       Map<String, dynamic>? levelProgress = _userProgress[levelId];
//       bool isCompleted = levelProgress?['isCompleted'] ?? false;
//
//       if (isCompleted) {
//         String badgeType = _getBadgeType(levelId);
//         badges.add(_buildUserBadge(badgeType, levelId));
//       }
//     }
//
//     if (badges.isEmpty) {
//       return SizedBox.shrink(); // Return empty widget if no badges
//     }
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         children: [
//           Text(
//             'Your Achievements',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 15),
//           Wrap(
//             spacing: 15,
//             runSpacing: 15,
//             alignment: WrapAlignment.center,
//             children: badges,
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getBadgeType(int levelId) {
//     switch (levelId) {
//       case 1:
//         return 'Acquire';
//       case 2:
//         return 'Deepen';
//       case 3:
//         return 'Create';
//       default:
//         return 'Level $levelId';
//     }
//   }
//
//   Widget _buildUserBadge(String badgeType, int levelId) {
//     Color badgeColor;
//     IconData badgeIcon;
//
//     switch (badgeType) {
//       case 'Acquire':
//         badgeColor = Color(0xFF4CAF50); // Green
//         badgeIcon = Icons.lightbulb;
//         break;
//       case 'Deepen':
//         badgeColor = Color(0xFF2196F3); // Blue
//         badgeIcon = Icons.psychology;
//         break;
//       case 'Create':
//         badgeColor = Color(0xFFFF9800); // Orange
//         badgeIcon = Icons.create;
//         break;
//       default:
//         badgeColor = Color(0xFF9C27B0); // Purple
//         badgeIcon = Icons.star;
//     }
//
//     return GestureDetector(
//       onTap: () => _showBadgeDetails(badgeType, levelId),
//       child: Container(
//         width: 80,
//         height: 100,
//         child: Column(
//           children: [
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: badgeColor,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 3),
//                 boxShadow: [
//                   BoxShadow(
//                     color: badgeColor.withOpacity(0.4),
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Icon(
//                   badgeIcon,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               badgeType,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showBadgeDetails(String badgeType, int levelId) {
//     Map<String, dynamic>? levelProgress = _userProgress[levelId];
//     int starsEarned = levelProgress?['starsEarned'] ?? 0;
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Row(
//             children: [
//               Icon(Icons.military_tech, color: Color(0xFF4A90E2), size: 30),
//               SizedBox(width: 10),
//               Text('$badgeType Master'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Congratulations! You\'ve mastered the $badgeType level.',
//                 style: TextStyle(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(3, (index) {
//                   return Icon(
//                     index < starsEarned ? Icons.star : Icons.star_border,
//                     color: index < starsEarned ? Colors.amber : Colors.grey,
//                     size: 30,
//                   );
//                 }),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 '$starsEarned/3 Stars Earned',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Close', style: TextStyle(color: Color(0xFF4A90E2))),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildZigzagModule(List<LevelData> levels) {
//     return Column(
//       children: levels.asMap().entries.map((entry) {
//         int levelIndex = entry.key;
//         LevelData level = entry.value;
//
//         bool isLeft = levelIndex % 2 == 0;
//         double horizontalOffset = isLeft ? -0.3 : 0.3;
//
//         return AnimatedBuilder(
//           animation: _pathController,
//           builder: (context, child) {
//             double totalLevels = levels.length.toDouble();
//             double levelDelay = 0.1 + (levelIndex / totalLevels) * 0.4;
//             double animationDuration = 0.2;
//
//             return FadeTransition(
//               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(
//                   parent: _pathController,
//                   curve: Interval(
//                     levelDelay,
//                     (levelDelay + animationDuration).clamp(0.0, 1.0),
//                     curve: Curves.easeOut,
//                   ),
//                 ),
//               ),
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                   begin: Offset(horizontalOffset, 0.5),
//                   end: Offset.zero,
//                 ).animate(
//                   CurvedAnimation(
//                     parent: _pathController,
//                     curve: Interval(
//                       levelDelay,
//                       (levelDelay + animationDuration).clamp(0.0, 1.0),
//                       curve: Curves.easeOut,
//                     ),
//                   ),
//                 ),
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: isLeft
//                         ? MainAxisAlignment.start
//                         : MainAxisAlignment.end,
//                     children: [
//                       if (isLeft) SizedBox(width: 30),
//                       _buildLevelNode(level),
//                       if (!isLeft) SizedBox(width: 30),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildLevelNode(LevelData level) {
//     final nodeStyles = _getLevelNodeStyles(level);
//
//     return GestureDetector(
//       onTap: level.isUnlocked ? () => _onLevelTap(level) : null,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _buildLevelCircle(level, nodeStyles),
//           SizedBox(height: 6),
//           if (level.isCompleted || level.isUnlocked) _buildStarsDisplay(level),
//           if (level.isCompleted || level.isUnlocked) SizedBox(height: 4),
//           if (level.isCompleted || level.isUnlocked) _buildLevelTitle(level),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildModuleBadge(ModuleData module) {
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
//                 ? _moduleDefinition['color']
//                 : Colors.grey[400],
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.white,
//               width: 4,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: (isModuleCompleted
//                     ? _moduleDefinition['color']
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
//   Map<String, dynamic> _getLevelNodeStyles(LevelData level) {
//     if (level.isCompleted) {
//       return {
//         'color': Color(0xFF4CAF50),
//         'icon': Icons.check,
//         'iconColor': Colors.white,
//         'displayText': '',
//       };
//     } else if (level.isUnlocked) {
//       return {
//         'color': Color(0xFFFFD700),
//         'icon': Icons.play_arrow,
//         'iconColor': Colors.white,
//         'displayText': '${level.id}',
//       };
//     } else {
//       return {
//         'color': Colors.grey[400]!,
//         'icon': Icons.lock,
//         'iconColor': Colors.grey[600]!,
//         'displayText': '',
//       };
//     }
//   }
//
//   Widget _buildLevelCircle(LevelData level, Map<String, dynamic> styles) {
//     return Container(
//       width: 70,
//       height: 70,
//       decoration: BoxDecoration(
//         color: styles['color'],
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.white, width: 4),
//         boxShadow: [
//           BoxShadow(
//             color: styles['color'].withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Center(
//         child: level.isCompleted
//             ? Icon(styles['icon'], color: styles['iconColor'], size: 30)
//             : level.isUnlocked
//             ? Text(
//           styles['displayText'],
//           style: TextStyle(
//             color: styles['iconColor'],
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         )
//             : Icon(styles['icon'], color: styles['iconColor'], size: 25),
//       ),
//     );
//   }
//
//   Widget _buildStarsDisplay(LevelData level) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(3, (index) {
//           bool isStarEarned = index < level.stars;
//           return Icon(
//             isStarEarned ? Icons.star : Icons.star_border,
//             color: isStarEarned ? Colors.yellow : Colors.white.withOpacity(0.5),
//             size: 16,
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildLevelTitle(LevelData level) {
//     return Container(
//       width: 80,
//       child: Text(
//         level.title,
//         style: TextStyle(
//           color: Colors.white.withOpacity(0.8),
//           fontSize: 11,
//           fontWeight: FontWeight.w500,
//         ),
//         textAlign: TextAlign.center,
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//       ),
//     );
//   }
//
//   void _onLevelTap(LevelData level) {
//     // Print level data when tapped for debugging
//     print('\n🎯 === LEVEL ${level.id} TAPPED ===');
//     print('Title: ${level.title}');
//     print('Is Completed: ${level.isCompleted}');
//     print('Is Unlocked: ${level.isUnlocked}');
//     print('Stars: ${level.stars}');
//     print('Scenario Data Keys: ${level.scenarioData.keys.toList()}');
//
//     // Print detailed level information
//     try {
//       final educationModule = JsonDataManager2.getModule();
//       final currentLevel = educationModule.getLevelByNumber(level.id);
//
//       if (currentLevel != null) {
//         print('\n📚 === DETAILED LEVEL INFO ===');
//         print('Level Name: ${currentLevel.level}');
//         print('Level Type: ${currentLevel.levelType}');
//         print('Total Scenarios: ${currentLevel.scenarios.length}');
//
//         // Print all scenario titles
//         print('\n📋 Scenarios in this level:');
//         for (int i = 0; i < currentLevel.scenarios.length; i++) {
//           final scenario = currentLevel.scenarios[i];
//           print('  ${i + 1}. ${scenario.title}');
//           print('     - ${scenario.options.length} options');
//           print('     - ${scenario.activity.cards.length} activity cards');
//           print('     - Activity: ${scenario.activity.name}');
//         }
//         print('=== END DETAILED INFO ===\n');
//       }
//     } catch (e) {
//       print('❌ Error printing level details: $e');
//     }
//
//     // Navigate to the scenarios screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LevelScenariosScreen(
//           levelId: level.id,
//           levelName: level.title,
//         ),
//       ),
//     );
//   }
//
//   void _onBadgeTap(ModuleData module) {
//     // Handle badge tap - could show achievement dialog
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('🏆 ${module.title} Badge Earned!'),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   /// Updated method to work with new JSON structure and proper unlocking logic
//   ModuleData _generateModuleFromJson(Map<String, dynamic> moduleDefinition) {
//     try {
//       // Get the education module using the new model
//       final educationModule = JsonDataManager2.getModule();
//
//       List<LevelData> levelDataList = [];
//
//       // Process each level from the JSON
//       for (int levelIndex = 0; levelIndex < educationModule.levels.length; levelIndex++) {
//         final level = educationModule.levels[levelIndex];
//
//         // Create level ID (1, 2, 3)
//         int uniqueId = levelIndex + 1;
//
//         // Get user progress for this level from Firebase structure
//         Map<String, dynamic>? levelProgress = _userProgress[uniqueId];
//         bool isCompleted = levelProgress?['isCompleted'] ?? false;
//
//         // NEW UNLOCKING LOGIC: Check sequential completion
//         bool isUnlocked = _isLevelUnlocked(uniqueId);
//
//         // Calculate stars based on progress
//         int stars = 0;
//         if (isCompleted && levelProgress != null) {
//           stars = (levelProgress['starsEarned'] ?? 0).clamp(0, 3);
//         }
//
//         // Create display title from level name
//         String displayTitle = _formatLevelTitle(level.level);
//
//         // Create scenario data for the level tap handler
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
//       // Return a fallback module
//       return ModuleData(
//         title: 'Human-Centered Mindset',
//         levels: [
//           LevelData(
//             id: 1,
//             title: 'Level 1',
//             isCompleted: false,
//             isUnlocked: true,
//             stars: 0,
//             scenarioData: {},
//           ),
//         ],
//       );
//     }
//   }
//
//   /// NEW METHOD: Check if a level should be unlocked based on completion of previous levels
//   bool _isLevelUnlocked(int levelId) {
//     // Level 1 is always unlocked
//     if (levelId == 1) {
//       return true;
//     }
//
//     // For levels 2 and above, check if the previous level is completed
//     int previousLevelId = levelId - 1;
//     Map<String, dynamic>? previousLevelProgress = _userProgress[previousLevelId];
//     bool isPreviousCompleted = previousLevelProgress?['isCompleted'] ?? false;
//
//     print('🔓 Checking unlock for Level $levelId: Previous level ($previousLevelId) completed: $isPreviousCompleted');
//
//     return isPreviousCompleted;
//   }
//
//   /// Helper method to format level titles for display
//   String _formatLevelTitle(String levelName) {
//     // Extract the level type from the full level name
//     // "Level 1 (Acquire)" -> "Acquire"
//     // "Level 2 (Deepen)" -> "Deepen"
//     // "Level 3 (Create)" -> "Create"
//
//     final regex = RegExp(r'Level (\d+) \((.+)\)');
//     final match = regex.firstMatch(levelName);
//
//     if (match != null) {
//       final levelNumber = match.group(1);
//       final levelType = match.group(2);
//       return '$levelNumber. $levelType';
//     }
//
//     // Fallback to original name if regex doesn't match
//     return levelName;
//   }
//
//
//
//
//
//
// }
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../data/UserDataService.dart';
import '../json/JsonDataManager2.dart';
import '../models/LevelData.dart';
import '../models/ModuleData.dart';
import '../widgets/DashboardHeader.dart';
import '../widgets/LevelDetailsDialog.dart';
import '../widgets/LoadingIndicator.dart';
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

  // Use the service instead of Firebase instances
  final UserDataService _userDataService = UserDataService();

  bool _isLoading = true;
  Map<int, Map<String, dynamic>> _userProgress = {};
  Map<String, dynamic> _userProfile = {};
  int _totalCoins = 0;

  // Level tap handler - commented out as it may not be defined
  // late LevelTapHandler _levelTapHandler;

  // Single module definition - Human-Centered Mindset with JSON data
  final Map<String, dynamic> _moduleDefinition = {
    'id': 1,
    'title': 'Human-Centered Mindset',
    'subtitle': 'Building empathy and understanding in AI implementation',
    'color': Color(0xFF4A90E2),
    'icon': Icons.favorite,
    'hasJsonData': true,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLevelHandler();
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

  void _initializeLevelHandler() {
    // _levelTapHandler = LevelTapHandler(
    //   context: context,
    //   onLevelCompleted: _handleLevelCompleted,
    // );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pathController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  /// Fetch user data using the UserDataService
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _userDataService.fetchUserData();

      if (result.isSuccess) {
        setState(() {
          _userProfile = result.profile;
          _userProgress = result.progress;
          _totalCoins = result.totalCoins;
        });

        // Debug print to check the progress data
        print('🔍 User Progress Data:');
        _userProgress.forEach((levelId, levelData) {
          print('  Level $levelId: $levelData');
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

      // Animate coins when data is loaded
      _coinController.forward();
    }
  }

  void _setDefaultUserData() {
    setState(() {
      _userProfile = {
        'username': 'User',
        'email': '',
        'avatar': '',
        'isActive': true,
      };
      _userProgress = {};
      _totalCoins = 0;
    });
  }

  void _handleLevelCompleted(Map<String, dynamic> result) {
    print('🔄 Level completed, refreshing progress...');
    _showCompletionFeedback(result);
    _coinController.reset();
    _fetchUserData();
  }

  void _showCompletionFeedback(Map<String, dynamic> result) {
    final stars = result['stars'] ?? 0;
    final coins = stars * 10;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.celebration, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '🎉 Level completed! +$coins coins earned!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRefresh() {
    _coinController.reset();
    _fetchUserData();
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
            _buildModule(),
            SizedBox(height: 100), // Extra space at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingMascot() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            math.sin(_floatingController.value * math.pi) * 5,
          ),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.psychology,
                size: 40,
                color: Color(0xFF4A90E2),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModule() {
    final moduleData = _generateModuleFromJson(_moduleDefinition);

    return AnimatedBuilder(
      animation: _pathController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _pathController,
              curve: Interval(0.0, 0.4, curve: Curves.easeOut),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _pathController,
                curve: Interval(0.0, 0.4, curve: Curves.easeOut),
              ),
            ),
            child: Column(
              children: [
                _buildModuleHeader(moduleData),
                _buildZigzagModule(moduleData.levels),
                _buildUserBadges(), // Add user badges section
                _buildModuleBadge(moduleData),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModuleHeader(ModuleData module) {
    int completedLevels = module.levels.where((level) => level.isCompleted).length;
    int totalLevels = module.levels.length;
    double progress = totalLevels > 0 ? completedLevels / totalLevels : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: _moduleDefinition['color'].withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _moduleDefinition['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _moduleDefinition['icon'],
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      _moduleDefinition['subtitle'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          _buildProgressBar(progress),
          SizedBox(height: 8),
          Text(
            '$completedLevels/$totalLevels levels completed',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  // New method to build user badges based on completed levels
  Widget _buildUserBadges() {
    List<Widget> badges = [];

    // Check each level completion and add corresponding badge
    for (int levelId = 1; levelId <= 3; levelId++) {
      Map<String, dynamic>? levelProgress = _userProgress[levelId];
      bool isCompleted = levelProgress?['isCompleted'] ?? false;

      if (isCompleted) {
        String badgeType = _getBadgeType(levelId);
        badges.add(_buildUserBadge(badgeType, levelId));
      }
    }

    if (badges.isEmpty) {
      return SizedBox.shrink(); // Return empty widget if no badges
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            'Your Achievements',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: badges,
          ),
        ],
      ),
    );
  }

  String _getBadgeType(int levelId) {
    switch (levelId) {
      case 1:
        return 'Acquire';
      case 2:
        return 'Deepen';
      case 3:
        return 'Create';
      default:
        return 'Level $levelId';
    }
  }

  Widget _buildUserBadge(String badgeType, int levelId) {
    Color badgeColor;
    IconData badgeIcon;

    switch (badgeType) {
      case 'Acquire':
        badgeColor = Color(0xFF4CAF50); // Green
        badgeIcon = Icons.lightbulb;
        break;
      case 'Deepen':
        badgeColor = Color(0xFF2196F3); // Blue
        badgeIcon = Icons.psychology;
        break;
      case 'Create':
        badgeColor = Color(0xFFFF9800); // Orange
        badgeIcon = Icons.create;
        break;
      default:
        badgeColor = Color(0xFF9C27B0); // Purple
        badgeIcon = Icons.star;
    }

    return GestureDetector(
      onTap: () => _showBadgeDetails(badgeType, levelId),
      child: Container(
        width: 80,
        height: 100,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  badgeIcon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              badgeType,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetails(String badgeType, int levelId) {
    Map<String, dynamic>? levelProgress = _userProgress[levelId];
    int starsEarned = levelProgress?['starsEarned'] ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.military_tech, color: Color(0xFF4A90E2), size: 30),
              SizedBox(width: 10),
              Text('$badgeType Master'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Congratulations! You\'ve mastered the $badgeType level.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < starsEarned ? Icons.star : Icons.star_border,
                    color: index < starsEarned ? Colors.amber : Colors.grey,
                    size: 30,
                  );
                }),
              ),
              SizedBox(height: 10),
              Text(
                '$starsEarned/3 Stars Earned',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: Color(0xFF4A90E2))),
            ),
          ],
        );
      },
    );
  }

  Widget _buildZigzagModule(List<LevelData> levels) {
    return Column(
      children: levels.asMap().entries.map((entry) {
        int levelIndex = entry.key;
        LevelData level = entry.value;

        bool isLeft = levelIndex % 2 == 0;
        double horizontalOffset = isLeft ? -0.3 : 0.3;

        return AnimatedBuilder(
          animation: _pathController,
          builder: (context, child) {
            double totalLevels = levels.length.toDouble();
            double levelDelay = 0.1 + (levelIndex / totalLevels) * 0.4;
            double animationDuration = 0.2;

            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _pathController,
                  curve: Interval(
                    levelDelay,
                    (levelDelay + animationDuration).clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(horizontalOffset, 0.5),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _pathController,
                    curve: Interval(
                      levelDelay,
                      (levelDelay + animationDuration).clamp(0.0, 1.0),
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: isLeft
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (isLeft) SizedBox(width: 30),
                      _buildLevelNode(level),
                      if (!isLeft) SizedBox(width: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildLevelNode(LevelData level) {
    final nodeStyles = _getLevelNodeStyles(level);

    return GestureDetector(
      onTap: level.isUnlocked ? () => _onLevelTap(level) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLevelCircle(level, nodeStyles),
          SizedBox(height: 6),
          // Always show stars for unlocked levels (whether completed or not)
          if (level.isUnlocked) _buildStarsDisplay(level),
          if (level.isUnlocked) SizedBox(height: 4),
          if (level.isUnlocked) _buildLevelTitle(level),
        ],
      ),
    );
  }

  Widget _buildModuleBadge(ModuleData module) {
    bool isModuleCompleted = module.levels.every((level) => level.isCompleted);

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: isModuleCompleted ? () => _onBadgeTap(module) : null,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isModuleCompleted
                ? _moduleDefinition['color']
                : Colors.grey[400],
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: (isModuleCompleted
                    ? _moduleDefinition['color']
                    : Colors.grey[400]!).withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: isModuleCompleted
                ? Icon(
              Icons.military_tech,
              color: Colors.white,
              size: 35,
            )
                : Icon(
              Icons.lock,
              color: Colors.grey[600],
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getLevelNodeStyles(LevelData level) {
    if (level.isCompleted) {
      return {
        'color': Color(0xFF4CAF50),
        'icon': Icons.check,
        'iconColor': Colors.white,
        'displayText': '',
      };
    } else if (level.isUnlocked) {
      return {
        'color': Color(0xFFFFD700),
        'icon': Icons.play_arrow,
        'iconColor': Colors.white,
        'displayText': '${level.id}',
      };
    } else {
      return {
        'color': Colors.grey[400]!,
        'icon': Icons.lock,
        'iconColor': Colors.grey[600]!,
        'displayText': '',
      };
    }
  }

  Widget _buildLevelCircle(LevelData level, Map<String, dynamic> styles) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: styles['color'],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: styles['color'].withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: level.isCompleted
            ? Icon(styles['icon'], color: styles['iconColor'], size: 30)
            : level.isUnlocked
            ? Text(
          styles['displayText'],
          style: TextStyle(
            color: styles['iconColor'],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
            : Icon(styles['icon'], color: styles['iconColor'], size: 25),
      ),
    );
  }

  /// Updated stars display method to properly show stars based on progress
  Widget _buildStarsDisplay(LevelData level) {
    // Get the stars from user progress or default to 0
    int starsEarned = 0;

    Map<String, dynamic>? levelProgress = _userProgress[level.id];
    if (levelProgress != null) {
      // Try different possible field names for stars
      starsEarned = levelProgress['starsEarned'] ??
          levelProgress['stars'] ??
          _calculateStarsFromProgress(levelProgress);
    }

    // Debug print
    print('🌟 Level ${level.id} stars: $starsEarned from progress: $levelProgress');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          bool isStarEarned = index < starsEarned;
          return Icon(
            isStarEarned ? Icons.star : Icons.star_border,
            color: isStarEarned ? Colors.yellow : Colors.white.withOpacity(0.5),
            size: 16,
          );
        }),
      ),
    );
  }

  /// Helper method to calculate stars from progress data
  int _calculateStarsFromProgress(Map<String, dynamic> levelProgress) {
    if (levelProgress['isCompleted'] == true) {
      // If we have correct/total answers, calculate stars based on performance
      int correctAnswers = levelProgress['correctAnswers'] ?? 0;
      int totalAnswers = levelProgress['totalAnswers'] ?? 0;

      if (totalAnswers > 0) {
        double percentage = correctAnswers / totalAnswers;
        if (percentage >= 0.9) return 3;  // 90%+ = 3 stars
        if (percentage >= 0.7) return 2;  // 70%+ = 2 stars
        if (percentage >= 0.5) return 1;  // 50%+ = 1 star
      }

      // If completed but no performance data, give 1 star
      return 1;
    }

    return 0; // Not completed
  }

  Widget _buildLevelTitle(LevelData level) {
    return Container(
      width: 80,
      child: Text(
        level.title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _onLevelTap(LevelData level) {
    // Print level data when tapped for debugging
    print('\n🎯 === LEVEL ${level.id} TAPPED ===');
    print('Title: ${level.title}');
    print('Is Completed: ${level.isCompleted}');
    print('Is Unlocked: ${level.isUnlocked}');
    print('Stars: ${level.stars}');
    print('User Progress for this level: ${_userProgress[level.id]}');
    print('Scenario Data Keys: ${level.scenarioData.keys.toList()}');

    // Print detailed level information
    try {
      final educationModule = JsonDataManager2.getModule();
      final currentLevel = educationModule.getLevelByNumber(level.id);

      if (currentLevel != null) {
        print('\n📚 === DETAILED LEVEL INFO ===');
        print('Level Name: ${currentLevel.level}');
        print('Level Type: ${currentLevel.levelType}');
        print('Total Scenarios: ${currentLevel.scenarios.length}');

        // Print all scenario titles
        print('\n📋 Scenarios in this level:');
        for (int i = 0; i < currentLevel.scenarios.length; i++) {
          final scenario = currentLevel.scenarios[i];
          print('  ${i + 1}. ${scenario.title}');
          print('     - ${scenario.options.length} options');
          print('     - ${scenario.activity.cards.length} activity cards');
          print('     - Activity: ${scenario.activity.name}');
        }
        print('=== END DETAILED INFO ===\n');
      }
    } catch (e) {
      print('❌ Error printing level details: $e');
    }

    // Navigate to the scenarios screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelScenariosScreen(
          levelId: level.id,
          levelName: level.title,
        ),
      ),
    );
  }

  void _onBadgeTap(ModuleData module) {
    // Handle badge tap - could show achievement dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🏆 ${module.title} Badge Earned!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
  /// Updated method to work with new JSON structure and proper unlocking logic
  ModuleData _generateModuleFromJson(Map<String, dynamic> moduleDefinition) {
    try {
      // Get the education module using the new model
      final educationModule = JsonDataManager2.getModule();

      List<LevelData> levelDataList = [];

      // Process each level from the JSON
      for (int levelIndex = 0; levelIndex < educationModule.levels.length; levelIndex++) {
        final level = educationModule.levels[levelIndex];

        // Create level ID (1, 2, 3)
        int uniqueId = levelIndex + 1;

        // Get user progress for this level from Firebase structure
        Map<String, dynamic>? levelProgress = _userProgress[uniqueId];
        bool isCompleted = levelProgress?['isCompleted'] ?? false;

        // NEW UNLOCKING LOGIC: Check sequential completion
        bool isUnlocked = _isLevelUnlocked(uniqueId);

        // Calculate stars based on progress - UPDATED LOGIC
        int stars = 0;
        if (levelProgress != null) {
          // Try to get stars from multiple possible fields
          stars = levelProgress['starsEarned'] ??
              levelProgress['stars'] ??
              _calculateStarsFromProgress(levelProgress);

          // Ensure stars are within valid range
          stars = stars.clamp(0, 3);
        }

        // Create display title from level name
        String displayTitle = _formatLevelTitle(level.level);

        // Create scenario data for the level tap handler
        Map<String, dynamic> scenarioData = {
          'id': uniqueId,
          'levelName': level.level,
          'levelType': level.levelType,
          'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
          'totalScenarios': level.scenarios.length,
        };

        // Debug print for each level
        print('🎯 Level $uniqueId: completed=$isCompleted, unlocked=$isUnlocked, stars=$stars');

        levelDataList.add(
          LevelData(
            id: uniqueId,
            title: displayTitle,
            isCompleted: isCompleted,
            isUnlocked: isUnlocked,
            stars: stars,
            scenarioData: scenarioData,
          ),
        );
      }

      // Return the complete module with all levels processed
      return ModuleData(
        title: educationModule.moduleName,
        levels: levelDataList,
      );
    } catch (e) {
      print('❌ Error generating module from JSON: $e');
      // Return a fallback module
      return ModuleData(
        title: 'Human-Centered Mindset',
        levels: [
          LevelData(
            id: 1,
            title: 'Level 1',
            isCompleted: false,
            isUnlocked: true,
            stars: 0,
            scenarioData: {},
          ),
        ],
      );
    }
  }
  /// Updated method to work with new JSON structure and proper unlocking logic
  // ModuleData _generateModuleFromJson(Map<String, dynamic> moduleDefinition) {
  //   try {
  //     // Get the education module using the new model
  //     final educationModule = JsonDataManager2.getModule();
  //
  //     List<LevelData> levelDataList = [];
  //
  //     // Process each level from the JSON
  //     for (int levelIndex = 0; levelIndex < educationModule.levels.length; levelIndex++) {
  //       final level = educationModule.levels[levelIndex];
  //
  //       // Create level ID (1, 2, 3)
  //       int uniqueId = levelIndex + 1;
  //
  //       // Get user progress for this level from Firebase structure
  //       Map<String, dynamic>? levelProgress = _userProgress[uniqueId];
  //       bool isCompleted = levelProgress?['isCompleted'] ?? false;
  //
  //       // NEW UNLOCKING LOGIC: Check sequential completion
  //       bool isUnlocked = _isLevelUnlocked(uniqueId);
  //
  //       // Calculate stars based on progress - UPDATED LOGIC
  //       int stars = 0;
  //       if (levelProgress != null) {
  //         // Try to get stars from multiple possible fields
  //         stars = levelProgress['starsEarned'] ??
  //             levelProgress['stars'] ??
  //             // Ensure stars are within valid range
  //             stars = stars.clamp(0, 3);
  //
  //         // Create display title from level name
  //         String displayTitle = _formatLevelTitle(level.level);
  //
  //         // Create scenario data for the level tap handler
  //         Map<String, dynamic> scenarioData = {
  //           'id': uniqueId,
  //           'levelName': level.level,
  //           'levelType': level.levelType,
  //           'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
  //           'totalScenarios': level.scenarios.length,
  //         };
  //
  //         // Debug print for each level
  //         print('🎯 Level $uniqueId: completed=$isCompleted, unlocked=$isUnlocked, stars=$stars');
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
  //     } }catch (e) {
  //     print('❌ Error generating module from JSON: $e');
  //     // Return a fallback module
  //     return ModuleData(
  //       title: 'Human-Centered Mindset',
  //       levels: [
  //         LevelData(
  //           id: 1,
  //           title: 'Level 1',
  //           isCompleted: false,
  //           isUnlocked: true,
  //           stars: 0,
  //           scenarioData: {},
  //         ),
  //       ],
  //     );
  //   }
  // }

    /// NEW METHOD: Check if a level should be unlocked based on completion of previous levels
    bool _isLevelUnlocked(int levelId) {
    // Level 1 is always unlocked
    if (levelId == 1) {
    return true;
    }

    // For levels 2 and above, check if the previous level is completed
    int previousLevelId = levelId - 1;
    Map<String, dynamic>? previousLevelProgress = _userProgress[previousLevelId];
    bool isPreviousCompleted = previousLevelProgress?['isCompleted'] ?? false;

    print('🔓 Checking unlock for Level $levelId: Previous level ($previousLevelId) completed: $isPreviousCompleted');

    return isPreviousCompleted;
    }

    /// Helper method to format level titles for display
    String _formatLevelTitle(String levelName) {
    // Extract the level type from the full level name
    // "Level 1 (Acquire)" -> "Acquire"
    // "Level 2 (Deepen)" -> "Deepen"
    // "Level 3 (Create)" -> "Create"

    final regex = RegExp(r'Level (\d+) \((.+)\)');
    final match = regex.firstMatch(levelName);

    if (match != null) {
    final levelNumber = match.group(1);
    final levelType = match.group(2);
    return '$levelNumber. $levelType';
    }

    // Fallback to original name if regex doesn't match
    return levelName;
    }
  }