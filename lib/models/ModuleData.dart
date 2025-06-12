import 'LevelData.dart';

class ModuleData {
  final String title;
  final List<LevelData> levels;

  ModuleData({
    required this.title,
    required this.levels,
  });
}
//
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// import '../json/JsonDataManager.dart';
// import '../models/LevelData.dart';
// import '../models/ModuleData.dart';
// import 'ScenarioScreen.dart';
//
// class AIArtizenDashboard extends StatefulWidget {
//   const AIArtizenDashboard({super.key});
//
//   @override
//   _AIArtizenDashboardState createState() => _AIArtizenDashboardState();
// }
//
// class _AIArtizenDashboardState extends State<AIArtizenDashboard>
//     with TickerProviderStateMixin {
//   late AnimationController _floatingController;
//   late AnimationController _pathController;
//   late AnimationController _coinController;
//   late PageController _pageController;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   bool _isLoading = true;
//   Map<String, Map<int, Map<String, dynamic>>> _allUserProgress = {};
//   Map<String, dynamic> _userProfile = {};
//   int _totalCoins = 0;
//   int _currentModuleIndex = 0;
//
//   // Define all 5 modules
//   final List<Map<String, dynamic>> _moduleDefinitions = [
//     {
//       'title': 'Human-Centered AI Implementation in Education',
//       'subtitle': 'Foundation of AI Ethics',
//       'icon': Icons.psychology,
//       'color': Color(0xFF4A90E2),
//       'key': 'human_centered_ai_education',
//     },
//     {
//       'title': 'AI-Powered Learning Analytics',
//       'subtitle': 'Data-Driven Education',
//       'icon': Icons.analytics,
//       'color': Color(0xFF7B68EE),
//       'key': 'ai_learning_analytics',
//     },
//     {
//       'title': 'Personalized Learning with AI',
//       'subtitle': 'Adaptive Education Systems',
//       'icon': Icons.person,
//       'color': Color(0xFF6A5ACD),
//       'key': 'personalized_learning_ai',
//     },
//     {
//       'title': 'AI Ethics and Bias Prevention',
//       'subtitle': 'Responsible AI Development',
//       'icon': Icons.balance,
//       'color': Color(0xFF9370DB),
//       'key': 'ai_ethics_bias_prevention',
//     },
//     {
//       'title': 'Future of AI in Education',
//       'subtitle': 'Emerging Technologies',
//       'icon': Icons.school,
//       'color': Color(0xFF8A2BE2),
//       'key': 'future_ai_education',
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _floatingController = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _pathController = AnimationController(
//       duration: Duration(milliseconds: 2000),
//       vsync: this,
//     );
//
//     _coinController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _pageController = PageController();
//
//     _pathController.forward();
//
//     // Fetch user data from Firebase
//     _fetchUserData();
//   }
//
//   @override
//   void dispose() {
//     _floatingController.dispose();
//     _pathController.dispose();
//     _coinController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchUserData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     await Future.wait([_fetchUserProfile(), _fetchAllUserProgress()]);
//     _calculateTotalCoins();
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     // Animate coins when data is loaded
//     _coinController.forward();
//   }
//
//   void _calculateTotalCoins() {
//     int totalCoins = 0;
//
//     // Calculate coins from all modules
//     _allUserProgress.forEach((moduleKey, moduleProgress) {
//       moduleProgress.forEach((levelId, progress) {
//         if (progress['completed'] == true) {
//           int stars = progress['score'] ?? 0;
//           totalCoins += stars * 10; // 10 coins per star
//         }
//       });
//     });
//
//     setState(() {
//       _totalCoins = totalCoins;
//     });
//
//     print('💰 Total coins calculated: $_totalCoins');
//   }
//
//   Future<void> _fetchUserProfile() async {
//     try {
//       final User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         print('❌ No user logged in');
//         return;
//       }
//
//       print('🔍 Fetching profile for user: ${currentUser.uid}');
//
//       // Fetch user profile data directly from users/{userId}
//       final DatabaseEvent snapshot =
//       await _database.child('users').child(currentUser.uid).once();
//
//       if (snapshot.snapshot.exists) {
//         final Map<dynamic, dynamic> profileData =
//         snapshot.snapshot.value as Map<dynamic, dynamic>;
//         _userProfile = Map<String, dynamic>.from(profileData);
//         print('✅ Found profile data: $_userProfile');
//       } else {
//         // Fallback to Firebase Auth user data
//         _userProfile = {
//           'username': currentUser.displayName ?? 'User',
//           'email': currentUser.email ?? '',
//           'avatar': '',
//           'isActive': true,
//         };
//         print('ℹ️ No profile data found, using auth data: $_userProfile');
//       }
//     } catch (e) {
//       print('❌ Error fetching user profile: $e');
//       // Fallback data
//       _userProfile = {
//         'username': 'User',
//         'email': '',
//         'avatar': '',
//         'isActive': true,
//       };
//     }
//   }
//
//   Future<void> _fetchAllUserProgress() async {
//     try {
//       final User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         print('❌ No user logged in');
//         return;
//       }
//
//       print('🔍 Fetching progress for user: ${currentUser.uid}');
//
//       // Fetch all user progress
//       final DatabaseEvent snapshot = await _database
//           .child('progressUser')
//           .child(currentUser.uid)
//           .child('progress')
//           .once();
//
//       if (snapshot.snapshot.exists) {
//         final Map<dynamic, dynamic> allProgressData =
//         snapshot.snapshot.value as Map<dynamic, dynamic>;
//
//         print('✅ Found progress data: $allProgressData');
//
//         // Process progress for each module
//         _allUserProgress.clear();
//         for (var moduleDefinition in _moduleDefinitions) {
//           String moduleKey = moduleDefinition['key'];
//           _allUserProgress[moduleKey] = {};
//
//           if (allProgressData.containsKey(moduleKey)) {
//             final Map<dynamic, dynamic> moduleProgressData =
//             allProgressData[moduleKey];
//
//             moduleProgressData.forEach((key, value) {
//               if (key.toString().startsWith('level_')) {
//                 final int levelId = int.parse(
//                   key.toString().replaceFirst('level_', ''),
//                 );
//                 final Map<String, dynamic> levelProgress =
//                 Map<String, dynamic>.from(value);
//                 _allUserProgress[moduleKey]![levelId] = levelProgress;
//
//                 print(
//                   '📊 Module $moduleKey - Level $levelId progress: ${levelProgress['completed']} | Stars: ${levelProgress['score']}',
//                 );
//               }
//             });
//           }
//         }
//       } else {
//         print('ℹ️ No progress data found');
//         // Initialize empty progress for all modules
//         for (var moduleDefinition in _moduleDefinitions) {
//           _allUserProgress[moduleDefinition['key']] = {};
//         }
//       }
//     } catch (e) {
//       print('❌ Error fetching user progress: $e');
//       // Initialize empty progress for all modules
//       for (var moduleDefinition in _moduleDefinitions) {
//         _allUserProgress[moduleDefinition['key']] = {};
//       }
//     }
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
//             colors: [
//               _moduleDefinitions[_currentModuleIndex]['color'],
//               _moduleDefinitions[_currentModuleIndex]['color'].withOpacity(0.8),
//               _moduleDefinitions[_currentModuleIndex]['color'].withOpacity(0.6),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               _buildModuleSelector(),
//               Expanded(
//                 child: _isLoading ? _buildLoadingIndicator() : _buildModuleView(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Loading your progress...',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Row(
//         children: [
//           // User Profile Section
//           Expanded(
//             child: Row(
//               children: [
//                 // Profile Avatar
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 5,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(child: _getAvatarWidget()),
//                 ),
//                 SizedBox(width: 12),
//                 // User Info with Status
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               ' ${_capitalizeFirstLetter(_getUserDisplayName())}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(width: 16),
//
//           // Coins Display
//           AnimatedBuilder(
//             animation: _coinController,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: 1.0 + (_coinController.value * 0.1),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.amber.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.monetization_on,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                       SizedBox(width: 4),
//                       AnimatedBuilder(
//                         animation: _coinController,
//                         builder: (context, child) {
//                           int displayCoins =
//                           (_totalCoins * _coinController.value).round();
//                           return Text(
//                             '$displayCoins',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           SizedBox(width: 16),
//
//           // Right Section - Action Buttons
//           Row(
//             children: [
//               // Refresh button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.refresh, color: Colors.white, size: 20),
//                   onPressed: () {
//                     _coinController.reset();
//                     _fetchUserData();
//                   },
//                   padding: EdgeInsets.all(8),
//                   constraints: BoxConstraints(minWidth: 36, minHeight: 36),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildModuleSelector() {
//     return Container(
//       height: 120,
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       child: PageView.builder(
//         controller: _pageController,
//         onPageChanged: (index) {
//           setState(() {
//             _currentModuleIndex = index;
//             _pathController.reset();
//             _pathController.forward();
//           });
//         },
//         itemCount: _moduleDefinitions.length,
//         itemBuilder: (context, index) {
//           var module = _moduleDefinitions[index];
//           bool isSelected = index == _currentModuleIndex;
//
//           return AnimatedContainer(
//             duration: Duration(milliseconds: 300),
//             margin: EdgeInsets.symmetric(horizontal: isSelected ? 0 : 20, vertical: 10),
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(isSelected ? 0.25 : 0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.white.withOpacity(isSelected ? 0.4 : 0.2),
//                 width: isSelected ? 2 : 1,
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   module['icon'],
//                   color: Colors.white,
//                   size: isSelected ? 32 : 24,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   module['title'],
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: isSelected ? 14 : 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   module['subtitle'],
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: isSelected ? 12 : 10,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildModuleView() {
//     return SingleChildScrollView(
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             // Character/Mascot
//             AnimatedBuilder(
//               animation: _floatingController,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(
//                     0,
//                     math.sin(_floatingController.value * math.pi) * 5,
//                   ),
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(40),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Icon(
//                         _moduleDefinitions[_currentModuleIndex]['icon'],
//                         size: 40,
//                         color: _moduleDefinitions[_currentModuleIndex]['color'],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             // Current Module
//             _buildCurrentModule(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCurrentModule() {
//     ModuleData module = _generateModuleData(_currentModuleIndex);
//
//     return Column(
//       children: [
//         // Module Header with Progress
//         _buildModuleHeader(module),
//         // Zigzag Level Layout
//         _buildZigzagModule(module.levels),
//         SizedBox(height: 20),
//       ],
//     );
//   }
//
//   Widget _buildModuleHeader(ModuleData module) {
//     int completedLevels =
//         module.levels.where((level) => level.isCompleted).length;
//     int totalLevels = module.levels.length;
//     double progress = totalLevels > 0 ? completedLevels / totalLevels : 0;
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 15),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         children: [
//           Text(
//             _moduleDefinitions[_currentModuleIndex]['title'],
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 4),
//           Text(
//             _moduleDefinitions[_currentModuleIndex]['subtitle'],
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 12),
//           // Progress Bar
//           Container(
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: FractionallySizedBox(
//               alignment: Alignment.centerLeft,
//               widthFactor: progress,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//               ),
//             ),
//           ),
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
//   Widget _buildZigzagModule(List<LevelData> levels) {
//     if (levels.isEmpty) {
//       return Container(
//         padding: EdgeInsets.all(40),
//         child: Column(
//           children: [
//             Icon(
//               Icons.construction,
//               size: 48,
//               color: Colors.white.withOpacity(0.7),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Coming Soon!',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'This module is under development.',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.8),
//                 fontSize: 14,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Column(
//       children: levels.asMap().entries.map((entry) {
//         int levelIndex = entry.key;
//         LevelData level = entry.value;
//
//         // Calculate zigzag position
//         bool isLeft = levelIndex % 2 == 0;
//         double horizontalOffset = isLeft ? -0.3 : 0.3;
//
//         return AnimatedBuilder(
//           animation: _pathController,
//           builder: (context, child) {
//             double totalLevels = levels.length.toDouble();
//             double animationDelay = (levelIndex / totalLevels) * 0.7;
//             double animationDuration = 0.3;
//
//             return FadeTransition(
//               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(
//                   parent: _pathController,
//                   curve: Interval(
//                     animationDelay,
//                     (animationDelay + animationDuration).clamp(0.0, 1.0),
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
//                       animationDelay,
//                       (animationDelay + animationDuration).clamp(0.0, 1.0),
//                       curve: Curves.easeOut,
//                     ),
//                   ),
//                 ),
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     mainAxisAlignment:
//                     isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
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
//     Color nodeColor;
//     IconData nodeIcon;
//     Color iconColor;
//     String displayText;
//
//     if (level.isCompleted) {
//       nodeColor = Color(0xFF4CAF50);
//       nodeIcon = Icons.check;
//       iconColor = Colors.white;
//       displayText = '';
//     } else if (level.isUnlocked) {
//       nodeColor = Color(0xFFFFD700);
//       nodeIcon = Icons.play_arrow;
//       iconColor = Colors.white;
//       displayText = '${level.id}';
//     } else {
//       nodeColor = Colors.grey[400]!;
//       nodeIcon = Icons.lock;
//       iconColor = Colors.grey[600]!;
//       displayText = '';
//     }
//
//     return GestureDetector(
//       onTap: level.isUnlocked ? () => _onLevelTap(level) : null,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Main level circle
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               color: nodeColor,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 4),
//               boxShadow: [
//                 BoxShadow(
//                   color: nodeColor.withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: level.isCompleted
//                   ? Icon(nodeIcon, color: iconColor, size: 30)
//                   : level.isUnlocked
//                   ? Text(
//                 displayText,
//                 style: TextStyle(
//                   color: iconColor,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//                   : Icon(nodeIcon, color: iconColor, size: 25),
//             ),
//           ),
//           SizedBox(height: 6),
//           // Stars
//           if (level.isCompleted || level.isUnlocked)
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(3, (index) {
//                   bool isStarEarned = index < level.stars;
//                   return Icon(
//                     isStarEarned ? Icons.star : Icons.star_border,
//                     color: isStarEarned
//                         ? Colors.yellow
//                         : Colors.white.withOpacity(0.5),
//                     size: 16,
//                   );
//                 }),
//               ),
//             ),
//           // Level description
//           if (level.isCompleted || level.isUnlocked) SizedBox(height: 4),
//           if (level.isCompleted || level.isUnlocked)
//             Container(
//               width: 80,
//               child: Text(
//                 level.title,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.8),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   ModuleData _generateModuleData(int moduleIndex) {
//     var moduleDefinition = _moduleDefinitions[moduleIndex];
//     String moduleKey = moduleDefinition['key'];
//     String moduleTitle = moduleDefinition['title'];
//
//     List<LevelData> levels = [];
//
//     // For the first module (index 0), use the existing JSON data
//     if (moduleIndex == 0) {
//       // Get scenarios from JsonDataManager (existing functionality)
//       List<dynamic> scenarios = JsonDataManager.getScenarios();
//       Map<int, Map<String, dynamic>> moduleProgress = _allUserProgress[moduleKey] ?? {};
//
//       // Generate levels from JSON scenarios and apply user progress
//       for (int i = 0; i < scenarios.length; i++) {
//         var scenario = scenarios[i];
//         int levelId = scenario['id'];
//
//         // Check if user has progress for this level
//         Map<String, dynamic>? levelProgress = moduleProgress[levelId];
//
//         // Determine completion status
//         bool isCompleted = levelProgress?['completed'] ?? false;
//
//         // Determine unlock status - first level is always unlocked,
//         // subsequent levels unlock when previous level is completed
//         bool isUnlocked = levelId == 1; // First level is always unlocked
//         if (levelId > 1) {
//           // Check if previous level is completed
//           Map<String, dynamic>? previousLevelProgress = moduleProgress[levelId - 1];
//           isUnlocked = previousLevelProgress?['completed'] ?? false;
//         }
//
//         // Get stars from user progress (score = stars)
//         int stars = 0;
//         if (isCompleted && levelProgress != null) {
//           stars = levelProgress['score'] ?? 0;
//           // Ensure stars is between 0 and 3
//           stars = stars.clamp(0, 3);
//         }
//
//         levels.add(
//           LevelData(
//             id: levelId,
//             title: scenario['title'],
//             isCompleted: isCompleted,
//             isUnlocked: isUnlocked,
//             stars: stars,
//             scenarioData: scenario, // Store the full scenario data
//           ),
//         );
//       }
//     } else {
//       // For other modules, generate placeholder levels
//       Map<int, Map<String, dynamic>> moduleProgress = _allUserProgress[moduleKey] ?? {};
//
//       // Generate 5 sample levels for each module
//       List<String> levelTitles = _getSampleLevelTitles(moduleIndex);
//
//       for (int i = 0; i < levelTitles.length; i++) {
//         int levelId = i + 1;
//
//         // Check if user has progress for this level
//         Map<String, dynamic>? levelProgress = moduleProgress[levelId];
//
//         // Determine completion status
//         bool isCompleted = levelProgress?['completed'] ?? false;
//
//         // Determine unlock status
//         bool isUnlocked = levelId == 1; // First level is always unlocked
//         if (levelId > 1) {
//           // Check if previous level is completed
//           Map<String, dynamic>? previousLevelProgress = moduleProgress[levelId - 1];
//           isUnlocked = previousLevelProgress?['completed'] ?? false;
//         }
//
//         // Get stars from user progress
//         int stars = 0;
//         if (isCompleted && levelProgress != null) {
//           stars = levelProgress['score'] ?? 0;
//           stars = stars.clamp(0, 3);
//         }
//
//         levels.add(
//           LevelData(
//             id: levelId,
//             title: levelTitles[i],
//             isCompleted: isCompleted,
//             isUnlocked: isUnlocked,
//             stars: stars,
//             scenarioData: _generateSampleScenario(levelId, levelTitles[i], moduleIndex),
//           ),
//         );
//       }
//     }
//
//     return ModuleData(title: moduleTitle, levels: levels);
//   }
//
//   List<String> _getSampleLevelTitles(int moduleIndex) {
//     switch (moduleIndex) {
//       case 1: // AI-Powered Learning Analytics
//         return [
//           'Data Collection Ethics',
//           'Learning Pattern Analysis',
//           'Predictive Modeling',
//           'Performance Metrics',
//           'Privacy Protection'
//         ];
//       case 2: // Personalized Learning with AI
//         return [
//           'Adaptive Pathways',
//           'Learning Styles',
//           'Content Recommendation',
//           'Skill Assessment',
//           'Progress Tracking'
//         ];
//       case 3: // AI Ethics and Bias Prevention
//         return [
//           'Bias Identification',
//           'Fairness Algorithms',
//           'Inclusive Design',
//           'Ethical Guidelines',
//           'Accountability Measures'
//         ];
//       case 4: // Future of AI in Education
//         return [
//           'Emerging Technologies',
//           'Virtual Reality Learning',
//           'AI Tutoring Systems',
//           'Quantum Computing',
//           'Neural Interfaces'
//         ];
//       default:
//         return [
//           'Introduction',
//           'Basic Concepts',
//           'Advanced Topics',
//           'Applications',
//           'Future Trends'
//         ];
//     }
//   }
//
//   Map<String, dynamic> _generateSampleScenario(int levelId, String title, int moduleIndex) {
//     // Generate sample scenario data for non-primary modules
//     return {
//       'id': levelId,
//       'title': title,
//       'description': _getScenarioDescription(title, moduleIndex),
//       'content': 'This is a sample scenario for $title. More content will be added as the module develops.',
//       'objectives': [
//         'Understand key concepts',
//         'Apply theoretical knowledge',
//         'Analyze practical scenarios'
//       ],
//       'estimatedTime': '15-20 minutes'
//     };
//   }
//
//   String _getScenarioDescription(String title, int moduleIndex) {
//     switch (moduleIndex) {
//       case 1: // AI-Powered Learning Analytics
//         switch (title) {
//           case 'Data Collection Ethics':
//             return 'Learn about ethical considerations when collecting student data for AI analysis.';
//           case 'Learning Pattern Analysis':
//             return 'Explore how AI can identify and analyze student learning patterns.';
//           case 'Predictive Modeling':
//             return 'Understand how to build models that predict student outcomes.';
//           case 'Performance Metrics':
//             return 'Discover key metrics for measuring AI system effectiveness.';
//           case 'Privacy Protection':
//             return 'Learn strategies to protect student privacy in AI systems.';
//           default:
//             return 'Explore advanced concepts in AI-powered learning analytics.';
//         }
//       case 2: // Personalized Learning with AI
//         switch (title) {
//           case 'Adaptive Pathways':
//             return 'Design learning paths that adapt to individual student needs.';
//           case 'Learning Styles':
//             return 'Understand how AI can accommodate different learning preferences.';
//           case 'Content Recommendation':
//             return 'Build systems that recommend relevant learning content.';
//           case 'Skill Assessment':
//             return 'Develop AI-powered assessment tools for skill evaluation.';
//           case 'Progress Tracking':
//             return 'Create systems to monitor and visualize learning progress.';
//           default:
//             return 'Explore personalized learning approaches with AI.';
//         }
//       case 3: // AI Ethics and Bias Prevention
//         switch (title) {
//           case 'Bias Identification':
//             return 'Learn to identify and understand different types of AI bias.';
//           case 'Fairness Algorithms':
//             return 'Explore algorithms designed to promote fairness in AI systems.';
//           case 'Inclusive Design':
//             return 'Design AI systems that work fairly for all user groups.';
//           case 'Ethical Guidelines':
//             return 'Understand frameworks for ethical AI development.';
//           case 'Accountability Measures':
//             return 'Implement systems for AI accountability and transparency.';
//           default:
//             return 'Study ethical considerations in AI development.';
//         }
//       case 4: // Future of AI in Education
//         switch (title) {
//           case 'Emerging Technologies':
//             return 'Explore cutting-edge technologies shaping education\'s future.';
//           case 'Virtual Reality Learning':
//             return 'Discover how VR and AI create immersive learning experiences.';
//           case 'AI Tutoring Systems':
//             return 'Study advanced AI systems that provide personalized tutoring.';
//           case 'Quantum Computing':
//             return 'Understand quantum computing\'s potential impact on education.';
//           case 'Neural Interfaces':
//             return 'Explore brain-computer interfaces in educational applications.';
//           default:
//             return 'Investigate future possibilities in AI-enhanced education.';
//         }
//       default:
//         return 'Explore this important topic in AI and education.';
//     }
//   }
//
//   String _capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1);
//   }
//
//   Widget _getAvatarWidget() {
//     String initials = _getUserInitials();
//     return Container(
//       color: _moduleDefinitions[_currentModuleIndex]['color'],
//       child: Center(
//         child: Text(
//           initials,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getUserDisplayName() {
//     if (_userProfile['username'] != null &&
//         _userProfile['username'].isNotEmpty) {
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
//   void _onLevelTap(LevelData level) {
//     // Show level details dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(level.title),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Level ${level.id}',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               level.scenarioData['description'] ?? 'Scenario content...',
//             ),
//             if (level.scenarioData['estimatedTime'] != null) ...[
//               SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
//                   SizedBox(width: 4),
//                   Text(
//                     level.scenarioData['estimatedTime'],
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//             SizedBox(height: 12),
//             if (level.isCompleted)
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.amber, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       '${level.stars}/3 stars earned',
//                       style: TextStyle(
//                         color: Colors.green[700],
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Icon(Icons.monetization_on, color: Colors.amber, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       '${level.stars * 10} coins',
//                       style: TextStyle(
//                         color: Colors.green[700],
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Navigate to scenario screen
//               _navigateToScenario(level);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor:
//               level.isCompleted ? Colors.blue : Color(0xFFFFD700),
//             ),
//             child: Text(
//               level.isCompleted ? 'Review' : 'Start',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToScenario(LevelData level) async {
//     // Get the current module title to pass to scenario screen
//     String moduleTitle = _moduleDefinitions[_currentModuleIndex]['title'];
//     String moduleKey = _moduleDefinitions[_currentModuleIndex]['key'];
//
//     // Navigate to scenario screen with level data and module info
//     final result = await Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => ScenarioScreen(
//           level: level,
//           moduleTitle: moduleTitle,
//           moduleKey: moduleKey, // Pass module key for progress tracking
//         ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeInOut),
//             ),
//             child: child,
//           );
//         },
//         transitionDuration: Duration(milliseconds: 500),
//       ),
//     );
//
//     // If user completed a level, refresh the progress
//     if (result != null && result['completed'] == true) {
//       print('🔄 Level completed, refreshing progress...');
//       _coinController.reset();
//       await _fetchUserData();
//     }
//   }
// }


////dashbaord

//
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// import '../json/JsonDataManager.dart';
// import '../models/LevelData.dart';
// import '../models/ModuleData.dart';
// import 'ScenarioScreen.dart';
//
// class AIArtizenDashboard extends StatefulWidget {
//   const AIArtizenDashboard({super.key});
//
//   @override
//   _AIArtizenDashboardState createState() => _AIArtizenDashboardState();
// }
//
// class _AIArtizenDashboardState extends State<AIArtizenDashboard>
//     with TickerProviderStateMixin {
//   late AnimationController _floatingController;
//   late AnimationController _pathController;
//   late AnimationController _coinController;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   bool _isLoading = true;
//   Map<int, Map<String, dynamic>> _userProgress = {};
//   Map<String, dynamic> _userProfile = {};
//   int _totalCoins = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _floatingController = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//
//     _pathController = AnimationController(
//       duration: Duration(milliseconds: 2000),
//       vsync: this,
//     );
//
//     _coinController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     _pathController.forward();
//
//     // Fetch user data from Firebase
//     _fetchUserData();
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
//   Future<void> _fetchUserData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     await Future.wait([_fetchUserProfile(), _fetchUserProgress()]);
//     _calculateTotalCoins();
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     // Animate coins when data is loaded
//     _coinController.forward();
//   }
//
//   void _calculateTotalCoins() {
//     int totalCoins = 0;
//
//     // Calculate coins based on stars earned
//     // Each completed level gives coins: 1 star = 10 coins, 2 stars = 20 coins, 3 stars = 30 coins
//     _userProgress.forEach((levelId, progress) {
//       if (progress['completed'] == true) {
//         int stars = progress['score'] ?? 0;
//         totalCoins += stars * 10; // 10 coins per star
//       }
//     });
//
//     setState(() {
//       _totalCoins = totalCoins;
//     });
//
//     print('💰 Total coins calculated: $_totalCoins');
//   }
//
//   Future<void> _fetchUserProfile() async {
//     try {
//       final User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         print('❌ No user logged in');
//         return;
//       }
//
//       print('🔍 Fetching profile for user: ${currentUser.uid}');
//
//       // Fetch user profile data directly from users/{userId}
//       final DatabaseEvent snapshot =
//       await _database.child('users').child(currentUser.uid).once();
//
//       if (snapshot.snapshot.exists) {
//         final Map<dynamic, dynamic> profileData =
//         snapshot.snapshot.value as Map<dynamic, dynamic>;
//         _userProfile = Map<String, dynamic>.from(profileData);
//         print('✅ Found profile data: $_userProfile');
//       } else {
//         // Fallback to Firebase Auth user data
//         _userProfile = {
//           'username': currentUser.displayName ?? 'User',
//           'email': currentUser.email ?? '',
//           'avatar': '',
//           'isActive': true,
//         };
//         print('ℹ️ No profile data found, using auth data: $_userProfile');
//       }
//     } catch (e) {
//       print('❌ Error fetching user profile: $e');
//       // Fallback data
//       _userProfile = {
//         'username': 'User',
//         'email': '',
//         'avatar': '',
//         'isActive': true,
//       };
//     }
//   }
//
//   Future<void> _fetchUserProgress() async {
//     try {
//       final User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         print('❌ No user logged in');
//         return;
//       }
//
//       final String moduleTitle = JsonDataManager.getModuleTitle();
//       final String moduleKey = moduleTitle.replaceAll(' ', '_').toLowerCase();
//
//       print('🔍 Fetching progress for user: ${currentUser.uid}');
//       print('📚 Module: $moduleTitle (key: $moduleKey)');
//
//       // Fetch user progress for this module
//       final DatabaseEvent snapshot =
//       await _database
//           .child('progressUser')
//           .child(currentUser.uid)
//           .child('progress')
//           .child(moduleKey)
//           .once();
//
//       if (snapshot.snapshot.exists) {
//         final Map<dynamic, dynamic> progressData =
//         snapshot.snapshot.value as Map<dynamic, dynamic>;
//
//         print('✅ Found progress data: $progressData');
//
//         // Convert progress data to our format
//         _userProgress.clear();
//         progressData.forEach((key, value) {
//           if (key.toString().startsWith('level_')) {
//             final int levelId = int.parse(
//               key.toString().replaceFirst('level_', ''),
//             );
//             final Map<String, dynamic> levelProgress =
//             Map<String, dynamic>.from(value);
//             _userProgress[levelId] = levelProgress;
//
//             print(
//               '📊 Level $levelId progress: ${levelProgress['completed']} | Stars: ${levelProgress['score']}',
//             );
//           }
//         });
//       } else {
//         print('ℹ️ No progress data found for this module');
//       }
//     } catch (e) {
//       print('❌ Error fetching user progress: $e');
//     }
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
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Loading your progress...',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Row(
//         children: [
//           // User Profile Section
//           Expanded(
//             child: Row(
//               children: [
//                 // Profile Avatar
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 5,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(child: _getAvatarWidget()),
//                 ),
//                 SizedBox(width: 12),
//                 // User Info with Status
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               ' ${_capitalizeFirstLetter(_getUserDisplayName())}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(width: 16),
//
//           // Coins Display
//           AnimatedBuilder(
//             animation: _coinController,
//             builder: (context, child) {
//               return Transform.scale(
//                 scale: 1.0 + (_coinController.value * 0.1),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.amber.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.monetization_on,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                       SizedBox(width: 4),
//                       AnimatedBuilder(
//                         animation: _coinController,
//                         builder: (context, child) {
//                           int displayCoins = (_totalCoins * _coinController.value).round();
//                           return Text(
//                             '$displayCoins',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           SizedBox(width: 16),
//
//           // Right Section - Action Buttons
//           Row(
//             children: [
//               // Refresh button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: IconButton(
//                   icon: Icon(Icons.refresh, color: Colors.white, size: 20),
//                   onPressed: () {
//                     _coinController.reset();
//                     _fetchUserData();
//                   },
//                   padding: EdgeInsets.all(8),
//                   constraints: BoxConstraints(minWidth: 36, minHeight: 36),
//                 ),
//               ),
//               SizedBox(width: 8),
//               // Profile menu button
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1);
//   }
//
//   Widget _getAvatarWidget() {
//     String initials = _getUserInitials();
//     return Container(
//       color: Color(0xFF4A90E2),
//       child: Center(
//         child: Text(
//           initials,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getUserDisplayName() {
//     if (_userProfile['username'] != null &&
//         _userProfile['username'].isNotEmpty) {
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
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             // Character/Mascot
//             AnimatedBuilder(
//               animation: _floatingController,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(
//                     0,
//                     math.sin(_floatingController.value * math.pi) * 5,
//                   ),
//                   child: Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(40),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.psychology,
//                         size: 40,
//                         color: Color(0xFF4A90E2),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             // Single Module
//             _buildSingleModule(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSingleModule() {
//     ModuleData module = _generateSingleModule();
//
//     return Column(
//       children: [
//         // Module Header with Progress
//         _buildModuleHeader(module),
//         // Zigzag Level Layout
//         _buildZigzagModule(module.levels),
//         SizedBox(height: 20),
//       ],
//     );
//   }
//
//   Widget _buildModuleHeader(ModuleData module) {
//     int completedLevels =
//         module.levels.where((level) => level.isCompleted).length;
//     int totalLevels = module.levels.length;
//     double progress = completedLevels / totalLevels;
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 15),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//       ),
//       child: Column(
//         children: [
//           Text(
//             JsonDataManager.getModuleTitle(),
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             'Human-Centered AI Implementation in Education',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 12),
//           // Progress Bar
//           Container(
//             height: 6,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: FractionallySizedBox(
//               alignment: Alignment.centerLeft,
//               widthFactor: progress,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(3),
//                 ),
//               ),
//             ),
//           ),
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
//   Widget _buildZigzagModule(List<LevelData> levels) {
//     return Column(
//       children:
//       levels.asMap().entries.map((entry) {
//         int levelIndex = entry.key;
//         LevelData level = entry.value;
//
//         // Calculate zigzag position
//         bool isLeft = levelIndex % 2 == 0;
//         double horizontalOffset = isLeft ? -0.3 : 0.3;
//
//         return AnimatedBuilder(
//           animation: _pathController,
//           builder: (context, child) {
//             double totalLevels = 5.0;
//             double animationDelay = (levelIndex / totalLevels) * 0.7;
//             double animationDuration = 0.3;
//
//             return FadeTransition(
//               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(
//                   parent: _pathController,
//                   curve: Interval(
//                     animationDelay,
//                     (animationDelay + animationDuration).clamp(0.0, 1.0),
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
//                       animationDelay,
//                       (animationDelay + animationDuration).clamp(0.0, 1.0),
//                       curve: Curves.easeOut,
//                     ),
//                   ),
//                 ),
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     mainAxisAlignment:
//                     isLeft
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
//     Color nodeColor;
//     IconData nodeIcon;
//     Color iconColor;
//     String displayText;
//
//     if (level.isCompleted) {
//       nodeColor = Color(0xFF4CAF50);
//       nodeIcon = Icons.check;
//       iconColor = Colors.white;
//       displayText = '';
//     } else if (level.isUnlocked) {
//       nodeColor = Color(0xFFFFD700);
//       nodeIcon = Icons.play_arrow;
//       iconColor = Colors.white;
//       displayText = '${level.id}';
//     } else {
//       nodeColor = Colors.grey[400]!;
//       nodeIcon = Icons.lock;
//       iconColor = Colors.grey[600]!;
//       displayText = '';
//     }
//
//     return GestureDetector(
//       onTap: level.isUnlocked ? () => _onLevelTap(level) : null,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Main level circle
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               color: nodeColor,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 4),
//               boxShadow: [
//                 BoxShadow(
//                   color: nodeColor.withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Center(
//               child:
//               level.isCompleted
//                   ? Icon(nodeIcon, color: iconColor, size: 30)
//                   : level.isUnlocked
//                   ? Text(
//                 displayText,
//                 style: TextStyle(
//                   color: iconColor,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//                   : Icon(nodeIcon, color: iconColor, size: 25),
//             ),
//           ),
//           SizedBox(height: 6),
//           // Stars
//           if (level.isCompleted || level.isUnlocked)
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(3, (index) {
//                   bool isStarEarned = index < level.stars;
//                   return Icon(
//                     isStarEarned ? Icons.star : Icons.star_border,
//                     color:
//                     isStarEarned
//                         ? Colors.yellow
//                         : Colors.white.withOpacity(0.5),
//                     size: 16,
//                   );
//                 }),
//               ),
//             ),
//           // Level description
//           if (level.isCompleted || level.isUnlocked) SizedBox(height: 4),
//           if (level.isCompleted || level.isUnlocked)
//             Container(
//               width: 80,
//               child: Text(
//                 level.title,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.8),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   ModuleData _generateSingleModule() {
//     // Get scenarios from JsonDataManager
//     List<dynamic> scenarios = JsonDataManager.getScenarios();
//     String moduleTitle = JsonDataManager.getModuleTitle();
//
//     List<LevelData> levels = [];
//
//     // Generate levels from JSON scenarios and apply user progress
//     for (int i = 0; i < scenarios.length; i++) {
//       var scenario = scenarios[i];
//       int levelId = scenario['id'];
//
//       // Check if user has progress for this level
//       Map<String, dynamic>? levelProgress = _userProgress[levelId];
//
//       // Determine completion status
//       bool isCompleted = levelProgress?['completed'] ?? false;
//
//       // Determine unlock status - first level is always unlocked,
//       // subsequent levels unlock when previous level is completed
//       bool isUnlocked = levelId == 1; // First level is always unlocked
//       if (levelId > 1) {
//         // Check if previous level is completed
//         Map<String, dynamic>? previousLevelProgress =
//         _userProgress[levelId - 1];
//         isUnlocked = previousLevelProgress?['completed'] ?? false;
//       }
//
//       // Get stars from user progress (score = stars)
//       int stars = 0;
//       if (isCompleted && levelProgress != null) {
//         stars = levelProgress['score'] ?? 0;
//         // Ensure stars is between 0 and 3
//         stars = stars.clamp(0, 3);
//       }
//
//       print(
//         '🔧 Level $levelId: completed=$isCompleted, unlocked=$isUnlocked, stars=$stars',
//       );
//
//       levels.add(
//         LevelData(
//           id: levelId,
//           title: scenario['title'],
//           isCompleted: isCompleted,
//           isUnlocked: isUnlocked,
//           stars: stars,
//           scenarioData: scenario, // Store the full scenario data
//         ),
//       );
//     }
//
//     return ModuleData(title: moduleTitle, levels: levels);
//   }
//
//   void _onLevelTap(LevelData level) {
//     // Show level details dialog
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//         title: Text(level.title),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Level ${level.id}',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               level.scenarioData['description'] ?? 'Scenario content...',
//             ),
//             SizedBox(height: 12),
//             if (level.isCompleted)
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.amber, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       '${level.stars}/3 stars earned',
//                       style: TextStyle(
//                         color: Colors.green[700],
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     Icon(Icons.monetization_on, color: Colors.amber, size: 16),
//                     SizedBox(width: 4),
//                     Text(
//                       '${level.stars * 10} coins',
//                       style: TextStyle(
//                         color: Colors.green[700],
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Navigate to scenario screen
//               _navigateToScenario(level);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor:
//               level.isCompleted ? Colors.blue : Color(0xFFFFD700),
//             ),
//             child: Text(
//               level.isCompleted ? 'Review' : 'Start',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToScenario(LevelData level) async {
//     // Get the module title to pass to scenario screen
//     String moduleTitle = JsonDataManager.getModuleTitle();
//
//     // Navigate to scenario screen with level data and module title
//     final result = await Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder:
//             (context, animation, secondaryAnimation) => ScenarioScreen(
//           level: level,
//           moduleTitle: moduleTitle, // Pass module title here
//         ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeInOut),
//             ),
//             child: child,
//           );
//         },
//         transitionDuration: Duration(milliseconds: 500),
//       ),
//     );
//
//     // If user completed a level, refresh the progress
//     if (result != null && result['completed'] == true) {
//       print('🔄 Level completed, refreshing progress...');
//       _coinController.reset();
//       await _fetchUserData();
//     }
//   }
// }
