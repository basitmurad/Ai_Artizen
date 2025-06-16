// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:firebase_database/firebase_database.dart';
// // // //
// // // // import '../json/JsonDataManager.dart';
// // // //
// // // // class UserDataService {
// // // //   static final UserDataService _instance = UserDataService._internal();
// // // //   factory UserDataService() => _instance;
// // // //   UserDataService._internal();
// // // //
// // // //   final FirebaseAuth _auth = FirebaseAuth.instance;
// // // //   final DatabaseReference _database = FirebaseDatabase.instance.ref();
// // // //
// // // //   /// Fetches complete user data including profile and progress
// // // //   Future<UserDataResult> fetchUserData() async {
// // // //     try {
// // // //       final results = await Future.wait([
// // // //         fetchUserProfile(),
// // // //         fetchUserProgress(),
// // // //       ]);
// // // //
// // // //       final profile = results[0] as Map<String, dynamic>;
// // // //       final progress = results[1] as Map<int, Map<String, dynamic>>;
// // // //       final totalCoins = calculateTotalCoins(progress);
// // // //
// // // //       return UserDataResult(
// // // //         profile: profile,
// // // //         progress: progress,
// // // //         totalCoins: totalCoins,
// // // //         isSuccess: true,
// // // //       );
// // // //     } catch (e) {
// // // //       print('❌ Error fetching user data: $e');
// // // //       return UserDataResult(
// // // //         profile: _getDefaultProfile(),
// // // //         progress: {},
// // // //         totalCoins: 0,
// // // //         isSuccess: false,
// // // //         error: e.toString(),
// // // //       );
// // // //     }
// // // //   }
// // // //
// // // //   /// Fetches user profile data from Firebase
// // // //   Future<Map<String, dynamic>> fetchUserProfile() async {
// // // //     try {
// // // //       final User? currentUser = _auth.currentUser;
// // // //       if (currentUser == null) {
// // // //         print('❌ No user logged in');
// // // //         return _getDefaultProfile();
// // // //       }
// // // //
// // // //       print('🔍 Fetching profile for user: ${currentUser.uid}');
// // // //
// // // //       // Fetch user profile data directly from users/{userId}
// // // //       final DatabaseEvent snapshot = await _database
// // // //           .child('users')
// // // //           .child(currentUser.uid)
// // // //           .once();
// // // //
// // // //       if (snapshot.snapshot.exists) {
// // // //         final Map<dynamic, dynamic> profileData =
// // // //         snapshot.snapshot.value as Map<dynamic, dynamic>;
// // // //         final profile = Map<String, dynamic>.from(profileData);
// // // //         print('✅ Found profile data: $profile');
// // // //         return profile;
// // // //       } else {
// // // //         // Fallback to Firebase Auth user data
// // // //         final profile = {
// // // //           'username': currentUser.displayName ?? 'User',
// // // //           'email': currentUser.email ?? '',
// // // //           'avatar': '',
// // // //           'isActive': true,
// // // //         };
// // // //         print('ℹ️ No profile data found, using auth data: $profile');
// // // //         return profile;
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error fetching user profile: $e');
// // // //       return _getDefaultProfile();
// // // //     }
// // // //   }
// // // //
// // // //   /// Fetches user progress data for the current module
// // // //   Future<Map<int, Map<String, dynamic>>> fetchUserProgress() async {
// // // //     try {
// // // //       final User? currentUser = _auth.currentUser;
// // // //       if (currentUser == null) {
// // // //         print('❌ No user logged in');
// // // //         return {};
// // // //       }
// // // //
// // // //       final String moduleTitle = JsonDataManager.getModuleTitle();
// // // //       final String moduleKey = moduleTitle.replaceAll(' ', '_').toLowerCase();
// // // //
// // // //       print('🔍 Fetching progress for user: ${currentUser.uid}');
// // // //       print('📚 Module: $moduleTitle (key: $moduleKey)');
// // // //
// // // //       // Fetch user progress for this module
// // // //       final DatabaseEvent snapshot = await _database
// // // //           .child('progressUser')
// // // //           .child(currentUser.uid)
// // // //           .child('progress')
// // // //           .child(moduleKey)
// // // //           .once();
// // // //
// // // //       if (snapshot.snapshot.exists) {
// // // //         final Map<dynamic, dynamic> progressData =
// // // //         snapshot.snapshot.value as Map<dynamic, dynamic>;
// // // //
// // // //         print('✅ Found progress data: $progressData');
// // // //
// // // //         // Convert progress data to our format
// // // //         final Map<int, Map<String, dynamic>> userProgress = {};
// // // //         progressData.forEach((key, value) {
// // // //           if (key.toString().startsWith('level_')) {
// // // //             final int levelId = int.parse(
// // // //               key.toString().replaceFirst('level_', ''),
// // // //             );
// // // //             final Map<String, dynamic> levelProgress =
// // // //             Map<String, dynamic>.from(value);
// // // //             userProgress[levelId] = levelProgress;
// // // //
// // // //             print(
// // // //               '📊 Level $levelId progress: ${levelProgress['completed']} | Stars: ${levelProgress['score']}',
// // // //             );
// // // //           }
// // // //         });
// // // //
// // // //         return userProgress;
// // // //       } else {
// // // //         print('ℹ️ No progress data found for this module');
// // // //         return {};
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error fetching user progress: $e');
// // // //       return {};
// // // //     }
// // // //   }
// // // //
// // // //   /// Calculates total coins based on user progress
// // // //   int calculateTotalCoins(Map<int, Map<String, dynamic>> userProgress) {
// // // //     int totalCoins = 0;
// // // //
// // // //     // Calculate coins based on stars earned
// // // //     // Each completed level gives coins: 1 star = 10 coins, 2 stars = 20 coins, 3 stars = 30 coins
// // // //     userProgress.forEach((levelId, progress) {
// // // //       if (progress['completed'] == true) {
// // // //         int stars = progress['score'] ?? 0;
// // // //         totalCoins += stars * 10; // 10 coins per star
// // // //       }
// // // //     });
// // // //
// // // //     print('💰 Total coins calculated: $totalCoins');
// // // //     return totalCoins;
// // // //   }
// // // //
// // // //   /// Updates user progress for a specific level
// // // //   Future<bool> updateLevelProgress({
// // // //     required int levelId,
// // // //     required bool completed,
// // // //     required int score,
// // // //     Map<String, dynamic>? additionalData,
// // // //   }) async {
// // // //     try {
// // // //       final User? currentUser = _auth.currentUser;
// // // //       if (currentUser == null) {
// // // //         print('❌ No user logged in');
// // // //         return false;
// // // //       }
// // // //
// // // //       final String moduleTitle = JsonDataManager.getModuleTitle();
// // // //       final String moduleKey = moduleTitle.replaceAll(' ', '_').toLowerCase();
// // // //
// // // //       final Map<String, dynamic> progressData = {
// // // //         'completed': completed,
// // // //         'score': score,
// // // //         'timestamp': DateTime.now().millisecondsSinceEpoch,
// // // //         ...?additionalData,
// // // //       };
// // // //
// // // //       await _database
// // // //           .child('progressUser')
// // // //           .child(currentUser.uid)
// // // //           .child('progress')
// // // //           .child(moduleKey)
// // // //           .child('level_$levelId')
// // // //           .set(progressData);
// // // //
// // // //       print('✅ Progress updated for level $levelId: $progressData');
// // // //       return true;
// // // //     } catch (e) {
// // // //       print('❌ Error updating level progress: $e');
// // // //       return false;
// // // //     }
// // // //   }
// // // //
// // // //   /// Gets current user ID
// // // //   String? getCurrentUserId() {
// // // //     return _auth.currentUser?.uid;
// // // //   }
// // // //
// // // //   /// Checks if user is logged in
// // // //   bool isUserLoggedIn() {
// // // //     return _auth.currentUser != null;
// // // //   }
// // // //
// // // //   /// Gets default profile data
// // // //   Map<String, dynamic> _getDefaultProfile() {
// // // //     return {
// // // //       'username': 'User',
// // // //       'email': '',
// // // //       'avatar': '',
// // // //       'isActive': true,
// // // //     };
// // // //   }
// // // // }
// // // //
// // // // /// Result class for user data fetching operations
// // // // class UserDataResult {
// // // //   final Map<String, dynamic> profile;
// // // //   final Map<int, Map<String, dynamic>> progress;
// // // //   final int totalCoins;
// // // //   final bool isSuccess;
// // // //   final String? error;
// // // //
// // // //   UserDataResult({
// // // //     required this.profile,
// // // //     required this.progress,
// // // //     required this.totalCoins,
// // // //     required this.isSuccess,
// // // //     this.error,
// // // //   });
// // // // }
// // // //
// // // // /// Extension methods for easier access to profile data
// // // // extension UserProfileExtension on Map<String, dynamic> {
// // // //   String get username => this['username'] ?? 'User';
// // // //   String get email => this['email'] ?? '';
// // // //   String get avatar => this['avatar'] ?? '';
// // // //   bool get isActive => this['isActive'] ?? true;
// // // //
// // // //   String get displayName => username.isNotEmpty ? username : 'User';
// // // //
// // // //   String get initials {
// // // //     if (username == 'User') return 'U';
// // // //
// // // //     List<String> parts = username.split(' ');
// // // //     if (parts.length >= 2) {
// // // //       return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
// // // //     } else if (parts.isNotEmpty) {
// // // //       return parts[0][0].toUpperCase();
// // // //     }
// // // //     return 'U';
// // // //   }
// // // // }
// // //
// // // import 'package:firebase_database/firebase_database.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // //
// // // /// Result class to hold both user profile and progress data
// // // class UserDataResult {
// // //   final bool isSuccess;
// // //   final Map<String, dynamic> profile;
// // //   final Map<int, Map<String, dynamic>> progress;
// // //   final int totalCoins;
// // //   final String? error;
// // //
// // //   UserDataResult({
// // //     required this.isSuccess,
// // //     required this.profile,
// // //     required this.progress,
// // //     required this.totalCoins,
// // //     this.error,
// // //   });
// // // }
// // //
// // // class UserDataService {
// // //   final FirebaseDatabase _database = FirebaseDatabase.instance;
// // //   final FirebaseAuth _auth = FirebaseAuth.instance;
// // //
// // //   /// Fetch both user profile and progress data
// // //   Future<UserDataResult> fetchUserData() async {
// // //     try {
// // //       final User? currentUser = _auth.currentUser;
// // //
// // //       if (currentUser == null) {
// // //         return UserDataResult(
// // //           isSuccess: false,
// // //           profile: {},
// // //           progress: {},
// // //           totalCoins: 0,
// // //           error: 'No authenticated user',
// // //         );
// // //       }
// // //
// // //       final String userId = currentUser.uid;
// // //       print('🔍 Fetching data for user: $userId');
// // //
// // //       // Fetch user profile data
// // //       final userProfileResult = await _fetchUserProfile(userId);
// // //
// // //       // Fetch user progress data
// // //       final progressResult = await _fetchUserProgress(userId);
// // //
// // //       return UserDataResult(
// // //         isSuccess: true,
// // //         profile: userProfileResult,
// // //         progress: progressResult['levels'] ?? {},
// // //         totalCoins: progressResult['coins'] ?? 0,
// // //       );
// // //
// // //     } catch (e) {
// // //       print('❌ Error in fetchUserData: $e');
// // //       return UserDataResult(
// // //         isSuccess: false,
// // //         profile: {},
// // //         progress: {},
// // //         totalCoins: 0,
// // //         error: e.toString(),
// // //       );
// // //     }
// // //   }
// // //
// // //   /// Fetch user profile from users/{userId}
// // //   Future<Map<String, dynamic>> _fetchUserProfile(String userId) async {
// // //     try {
// // //       final DatabaseReference userRef = _database.ref().child('users').child(userId);
// // //       final DatabaseEvent event = await userRef.once();
// // //
// // //       if (event.snapshot.exists) {
// // //         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
// // //         print('✅ User profile fetched: ${data.keys.toList()}');
// // //         return data;
// // //       } else {
// // //         print('⚠️ No user profile found for $userId');
// // //         return {};
// // //       }
// // //     } catch (e) {
// // //       print('❌ Error fetching user profile: $e');
// // //       return {};
// // //     }
// // //   }
// // //
// // //   /// Fetch user progress from Progress/{userId}
// // //   Future<Map<String, dynamic>> _fetchUserProgress(String userId) async {
// // //     try {
// // //       final DatabaseReference progressRef = _database.ref().child('Progress').child(userId);
// // //       final DatabaseEvent event = await progressRef.once();
// // //
// // //       if (event.snapshot.exists) {
// // //         print('🔍 Raw Firebase data type: ${event.snapshot.value.runtimeType}');
// // //         print('🔍 Raw Firebase data: ${event.snapshot.value}');
// // //
// // //         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
// // //         print('✅ User progress fetched: ${data.keys.toList()}');
// // //
// // //         // Convert levels data to the expected format
// // //         Map<int, Map<String, dynamic>> formattedLevels = {};
// // //
// // //         if (data['levels'] != null) {
// // //           print('🔍 Levels data type: ${data['levels'].runtimeType}');
// // //           print('🔍 Levels data content: ${data['levels']}');
// // //
// // //           try {
// // //             if (data['levels'] is Map) {
// // //               final levelsData = Map<String, dynamic>.from(data['levels']);
// // //               levelsData.forEach((key, value) {
// // //                 if (value is Map) {
// // //                   final levelId = int.tryParse(key.toString());
// // //                   if (levelId != null) {
// // //                     formattedLevels[levelId] = Map<String, dynamic>.from(value);
// // //                   }
// // //                 }
// // //               });
// // //             } else if (data['levels'] is List) {
// // //               // Handle case where levels might be stored as a list
// // //               print('⚠️ Levels data is a List, not a Map. Content: ${data['levels']}');
// // //               final List<dynamic> levelsList = data['levels'] as List<dynamic>;
// // //               for (int i = 0; i < levelsList.length; i++) {
// // //                 if (levelsList[i] is Map) {
// // //                   final levelData = Map<String, dynamic>.from(levelsList[i]);
// // //                   final levelId = levelData['levelId'] ?? (i + 1);
// // //                   formattedLevels[levelId] = levelData;
// // //                 }
// // //               }
// // //             }
// // //           } catch (e) {
// // //             print('❌ Error processing levels data: $e');
// // //             print('❌ Levels raw data: ${data['levels']}');
// // //           }
// // //         }
// // //
// // //         print('📊 Formatted levels: ${formattedLevels.keys.toList()}');
// // //
// // //         // Handle scenarios data - it can be either a List or Map
// // //         dynamic scenariosData = {};
// // //         if (data['scenarios'] != null) {
// // //           if (data['scenarios'] is List) {
// // //             // Convert list of scenario IDs to a map format
// // //             final List<dynamic> scenariosList = data['scenarios'] as List<dynamic>;
// // //             scenariosData = Map<String, dynamic>.fromIterables(
// // //                 scenariosList.map((id) => id.toString()),
// // //                 scenariosList.map((id) => {'scenarioId': id, 'completed': false})
// // //             );
// // //             print('📋 Converted scenarios list to map: ${scenariosData.keys.toList()}');
// // //           } else if (data['scenarios'] is Map) {
// // //             scenariosData = Map<String, dynamic>.from(data['scenarios']);
// // //             print('📋 Scenarios already in map format: ${scenariosData.keys.toList()}');
// // //           }
// // //         }
// // //
// // //         return {
// // //           'levels': formattedLevels,
// // //           'coins': data['coins'] ?? 0,
// // //           'correctAnswers': data['correctAnswers'] ?? 0,
// // //           'totalAnswers': data['totalAnswers'] ?? 0,
// // //           'levelsCompleted': data['levelsCompleted'] ?? 0,
// // //           'lastActivity': data['lastActivity'],
// // //           'starsEarned': data['starsEarned'] ?? 0,
// // //           'scenarios': scenariosData,
// // //         };
// // //       } else {
// // //         print('⚠️ No progress data found for $userId');
// // //         return {
// // //           'levels': <int, Map<String, dynamic>>{},
// // //           'coins': 0,
// // //           'correctAnswers': 0,
// // //           'totalAnswers': 0,
// // //           'levelsCompleted': 0,
// // //           'starsEarned': 0,
// // //           'scenarios': {},
// // //         };
// // //       }
// // //     } catch (e) {
// // //       print('❌ Error fetching user progress: $e');
// // //       print('❌ Stack trace: ${StackTrace.current}');
// // //       return {
// // //         'levels': <int, Map<String, dynamic>>{},
// // //         'coins': 0,
// // //         'correctAnswers': 0,
// // //         'totalAnswers': 0,
// // //         'levelsCompleted': 0,
// // //         'starsEarned': 0,
// // //         'scenarios': {},
// // //       };
// // //     }
// // //   }
// // //
// // //   /// Update user progress when a level is completed
// // //   Future<bool> updateLevelProgress({
// // //     required int levelId,
// // //     required String levelName,
// // //     required bool isCompleted,
// // //     required int starsEarned,
// // //     required int correctAnswers,
// // //     required int totalAnswers,
// // //     int? coinsEarned,
// // //   }) async {
// // //     try {
// // //       final User? currentUser = _auth.currentUser;
// // //       if (currentUser == null) {
// // //         print('❌ No authenticated user for progress update');
// // //         return false;
// // //       }
// // //
// // //       final String userId = currentUser.uid;
// // //       final DatabaseReference progressRef = _database.ref().child('Progress').child(userId);
// // //
// // //       // Get current progress to update totals
// // //       final currentProgressSnapshot = await progressRef.once();
// // //       Map<String, dynamic> currentProgress = {};
// // //
// // //       if (currentProgressSnapshot.snapshot.exists) {
// // //         currentProgress = Map<String, dynamic>.from(currentProgressSnapshot.snapshot.value as Map);
// // //       }
// // //
// // //       // Calculate new totals
// // //       int currentCoins = currentProgress['coins'] ?? 0;
// // //       int currentCorrectAnswers = currentProgress['correctAnswers'] ?? 0;
// // //       int currentTotalAnswers = currentProgress['totalAnswers'] ?? 0;
// // //       int currentLevelsCompleted = currentProgress['levelsCompleted'] ?? 0;
// // //       int currentStarsEarned = currentProgress['starsEarned'] ?? 0;
// // //
// // //       // Update level-specific data
// // //       Map<String, dynamic> levelUpdateData = {
// // //         'levels/$levelId/levelId': levelId,
// // //         'levels/$levelId/levelName': levelName,
// // //         'levels/$levelId/isCompleted': isCompleted,
// // //         'levels/$levelId/starsEarned': starsEarned,
// // //         'levels/$levelId/correctAnswers': correctAnswers,
// // //         'levels/$levelId/totalAnswers': totalAnswers,
// // //         'levels/$levelId/lastPlayed': DateTime.now().millisecondsSinceEpoch,
// // //       };
// // //
// // //       // Update global totals only if level is newly completed
// // //       Map<String, dynamic>? existingLevel = currentProgress['levels']?[levelId.toString()];
// // //       bool wasAlreadyCompleted = existingLevel?['isCompleted'] ?? false;
// // //
// // //       if (isCompleted && !wasAlreadyCompleted) {
// // //         // Level newly completed - update totals
// // //         levelUpdateData.addAll({
// // //           'coins': currentCoins + (coinsEarned ?? (starsEarned * 10)),
// // //           'correctAnswers': currentCorrectAnswers + correctAnswers,
// // //           'totalAnswers': currentTotalAnswers + totalAnswers,
// // //           'levelsCompleted': currentLevelsCompleted + 1,
// // //           'starsEarned': currentStarsEarned + starsEarned,
// // //           'lastActivity': DateTime.now().millisecondsSinceEpoch,
// // //         });
// // //       } else if (isCompleted) {
// // //         // Level was already completed - just update specific level data and timestamp
// // //         levelUpdateData['lastActivity'] = DateTime.now().millisecondsSinceEpoch;
// // //       }
// // //
// // //       await progressRef.update(levelUpdateData);
// // //       print('✅ Progress updated for level $levelId');
// // //       return true;
// // //
// // //     } catch (e) {
// // //       print('❌ Error updating level progress: $e');
// // //       return false;
// // //     }
// // //   }
// // //
// // //   /// Get current user ID
// // //   String? getCurrentUserId() {
// // //     return _auth.currentUser?.uid;
// // //   }
// // //
// // //   /// Check if user is authenticated
// // //   bool isUserAuthenticated() {
// // //     return _auth.currentUser != null;
// // //   }
// // //
// // //   /// Sign out user
// // //   Future<void> signOut() async {
// // //     try {
// // //       await _auth.signOut();
// // //       print('✅ User signed out successfully');
// // //     } catch (e) {
// // //       print('❌ Error signing out: $e');
// // //     }
// // //   }
// // // }
// //
// //
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// //
// // /// Result class to hold both user profile and progress data
// // class UserDataResult {
// //   final bool isSuccess;
// //   final Map<String, dynamic> profile;
// //   final Map<int, Map<String, dynamic>> progress;
// //   final int totalCoins;
// //   final String? error;
// //
// //   UserDataResult({
// //     required this.isSuccess,
// //     required this.profile,
// //     required this.progress,
// //     required this.totalCoins,
// //     this.error,
// //   });
// // }
// //
// // class UserDataService {
// //   final FirebaseDatabase _database = FirebaseDatabase.instance;
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //
// //   /// Fetch both user profile and progress data
// //   Future<UserDataResult> fetchUserData() async {
// //     try {
// //       final User? currentUser = _auth.currentUser;
// //
// //       if (currentUser == null) {
// //         return UserDataResult(
// //           isSuccess: false,
// //           profile: {},
// //           progress: {},
// //           totalCoins: 0,
// //           error: 'No authenticated user',
// //         );
// //       }
// //
// //       final String userId = currentUser.uid;
// //       print('🔍 Fetching data for user: $userId');
// //
// //       // Fetch user profile data
// //       final userProfileResult = await _fetchUserProfile(userId);
// //
// //       // Fetch user progress data
// //       final progressResult = await _fetchUserProgress(userId);
// //
// //       return UserDataResult(
// //         isSuccess: true,
// //         profile: userProfileResult,
// //         progress: progressResult['levels'] ?? {},
// //         totalCoins: progressResult['coins'] ?? 0,
// //       );
// //
// //     } catch (e) {
// //       print('❌ Error in fetchUserData: $e');
// //       return UserDataResult(
// //         isSuccess: false,
// //         profile: {},
// //         progress: {},
// //         totalCoins: 0,
// //         error: e.toString(),
// //       );
// //     }
// //   }
// //
// //   /// Fetch user profile from users/{userId}
// //   Future<Map<String, dynamic>> _fetchUserProfile(String userId) async {
// //     try {
// //       final DatabaseReference userRef = _database.ref().child('users').child(userId);
// //       final DatabaseEvent event = await userRef.once();
// //
// //       if (event.snapshot.exists) {
// //         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
// //         print('✅ User profile fetched: ${data.keys.toList()}');
// //         return data;
// //       } else {
// //         print('⚠️ No user profile found for $userId');
// //         return {};
// //       }
// //     } catch (e) {
// //       print('❌ Error fetching user profile: $e');
// //       return {};
// //     }
// //   }
// //
// //   /// Fetch user progress from Progress/{userId}
// //   Future<Map<String, dynamic>> _fetchUserProgress(String userId) async {
// //     try {
// //       final DatabaseReference progressRef = _database.ref().child('Progress').child(userId);
// //       final DatabaseEvent event = await progressRef.once();
// //
// //       if (event.snapshot.exists) {
// //         print('🔍 Raw Firebase data type: ${event.snapshot.value.runtimeType}');
// //         print('🔍 Raw Firebase data: ${event.snapshot.value}');
// //
// //         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
// //         print('✅ User progress fetched: ${data.keys.toList()}');
// //
// //         // Convert levels data to the expected format
// //         Map<int, Map<String, dynamic>> formattedLevels = {};
// //
// //         if (data['levels'] != null) {
// //           print('🔍 Levels data type: ${data['levels'].runtimeType}');
// //           print('🔍 Levels data content: ${data['levels']}');
// //
// //           try {
// //             if (data['levels'] is Map) {
// //               final levelsData = Map<String, dynamic>.from(data['levels']);
// //               levelsData.forEach((key, value) {
// //                 if (value is Map) {
// //                   final levelId = int.tryParse(key.toString());
// //                   if (levelId != null) {
// //                     formattedLevels[levelId] = Map<String, dynamic>.from(value);
// //                   }
// //                 }
// //               });
// //             } else if (data['levels'] is List) {
// //               // Handle case where levels might be stored as a list
// //               print('⚠️ Levels data is a List, not a Map. Content: ${data['levels']}');
// //               final List<dynamic> levelsList = data['levels'] as List<dynamic>;
// //               for (int i = 0; i < levelsList.length; i++) {
// //                 if (levelsList[i] is Map) {
// //                   final levelData = Map<String, dynamic>.from(levelsList[i]);
// //                   final levelId = levelData['levelId'] ?? (i + 1);
// //                   formattedLevels[levelId] = levelData;
// //                 }
// //               }
// //             }
// //           } catch (e) {
// //             print('❌ Error processing levels data: $e');
// //             print('❌ Levels raw data: ${data['levels']}');
// //           }
// //         }
// //
// //         print('📊 Formatted levels: ${formattedLevels.keys.toList()}');
// //
// //         // Handle scenarios data - it can be either a List or Map
// //         dynamic scenariosData = {};
// //         if (data['scenarios'] != null) {
// //           if (data['scenarios'] is List) {
// //             // Convert list of scenario IDs to a map format
// //             final List<dynamic> scenariosList = data['scenarios'] as List<dynamic>;
// //             scenariosData = Map<String, dynamic>.fromIterables(
// //                 scenariosList.map((id) => id.toString()),
// //                 scenariosList.map((id) => {'scenarioId': id, 'completed': false})
// //             );
// //             print('📋 Converted scenarios list to map: ${scenariosData.keys.toList()}');
// //           } else if (data['scenarios'] is Map) {
// //             scenariosData = Map<String, dynamic>.from(data['scenarios']);
// //             print('📋 Scenarios already in map format: ${scenariosData.keys.toList()}');
// //           }
// //         }
// //
// //         return {
// //           'levels': formattedLevels,
// //           'coins': data['coins'] ?? 0,
// //           'correctAnswers': data['correctAnswers'] ?? 0,
// //           'totalAnswers': data['totalAnswers'] ?? 0,
// //           'levelsCompleted': data['levelsCompleted'] ?? 0,
// //           'lastActivity': data['lastActivity'],
// //           'starsEarned': data['starsEarned'] ?? 0,
// //           'scenarios': scenariosData,
// //         };
// //       } else {
// //         print('⚠️ No progress data found for $userId');
// //         return {
// //           'levels': <int, Map<String, dynamic>>{},
// //           'coins': 0,
// //           'correctAnswers': 0,
// //           'totalAnswers': 0,
// //           'levelsCompleted': 0,
// //           'starsEarned': 0,
// //           'scenarios': {},
// //         };
// //       }
// //     } catch (e) {
// //       print('❌ Error fetching user progress: $e');
// //       print('❌ Stack trace: ${StackTrace.current}');
// //       return {
// //         'levels': <int, Map<String, dynamic>>{},
// //         'coins': 0,
// //         'correctAnswers': 0,
// //         'totalAnswers': 0,
// //         'levelsCompleted': 0,
// //         'starsEarned': 0,
// //         'scenarios': {},
// //       };
// //     }
// //   }
// //
// //   /// Update user progress when a level is completed
// //   Future<bool> updateLevelProgress({
// //     required int levelId,
// //     required String levelName,
// //     required bool isCompleted,
// //     required int starsEarned,
// //     required int correctAnswers,
// //     required int totalAnswers,
// //     int? coinsEarned,
// //   }) async {
// //     try {
// //       final User? currentUser = _auth.currentUser;
// //       if (currentUser == null) {
// //         print('❌ No authenticated user for progress update');
// //         return false;
// //       }
// //
// //       final String userId = currentUser.uid;
// //       final DatabaseReference progressRef = _database.ref().child('Progress').child(userId);
// //
// //       // Get current progress to update totals
// //       final currentProgressSnapshot = await progressRef.once();
// //       Map<String, dynamic> currentProgress = {};
// //
// //       if (currentProgressSnapshot.snapshot.exists) {
// //         currentProgress = Map<String, dynamic>.from(currentProgressSnapshot.snapshot.value as Map);
// //       }
// //
// //       // Calculate new totals
// //       int currentCoins = currentProgress['coins'] ?? 0;
// //       int currentCorrectAnswers = currentProgress['correctAnswers'] ?? 0;
// //       int currentTotalAnswers = currentProgress['totalAnswers'] ?? 0;
// //       int currentLevelsCompleted = currentProgress['levelsCompleted'] ?? 0;
// //       int currentStarsEarned = currentProgress['starsEarned'] ?? 0;
// //
// //       // Update level-specific data
// //       Map<String, dynamic> levelUpdateData = {
// //         'levels/$levelId/levelId': levelId,
// //         'levels/$levelId/levelName': levelName,
// //         'levels/$levelId/isCompleted': isCompleted,
// //         'levels/$levelId/starsEarned': starsEarned,
// //         'levels/$levelId/correctAnswers': correctAnswers,
// //         'levels/$levelId/totalAnswers': totalAnswers,
// //         'levels/$levelId/lastPlayed': DateTime.now().millisecondsSinceEpoch,
// //       };
// //
// //       // Update global totals only if level is newly completed
// //       Map<String, dynamic>? existingLevel = currentProgress['levels']?[levelId.toString()];
// //       bool wasAlreadyCompleted = existingLevel?['isCompleted'] ?? false;
// //
// //       if (isCompleted && !wasAlreadyCompleted) {
// //         // Level newly completed - update totals
// //         levelUpdateData.addAll({
// //           'coins': currentCoins + (coinsEarned ?? (starsEarned * 10)),
// //           'correctAnswers': currentCorrectAnswers + correctAnswers,
// //           'totalAnswers': currentTotalAnswers + totalAnswers,
// //           'levelsCompleted': currentLevelsCompleted + 1,
// //           'starsEarned': currentStarsEarned + starsEarned,
// //           'lastActivity': DateTime.now().millisecondsSinceEpoch,
// //         });
// //       } else if (isCompleted) {
// //         // Level was already completed - just update specific level data and timestamp
// //         levelUpdateData['lastActivity'] = DateTime.now().millisecondsSinceEpoch;
// //       }
// //
// //       await progressRef.update(levelUpdateData);
// //       print('✅ Progress updated for level $levelId');
// //       return true;
// //
// //     } catch (e) {
// //       print('❌ Error updating level progress: $e');
// //       return false;
// //     }
// //   }
// //
// //   /// Get current user ID
// //   String? getCurrentUserId() {
// //     return _auth.currentUser?.uid;
// //   }
// //
// //   /// Check if user is authenticated
// //   bool isUserAuthenticated() {
// //     return _auth.currentUser != null;
// //   }
// //
// //   /// Sign out user
// //   Future<void> signOut() async {
// //     try {
// //       await _auth.signOut();
// //       print('✅ User signed out successfully');
// //     } catch (e) {
// //       print('❌ Error signing out: $e');
// //     }
// //   }
// // }
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// /// Result class to hold both user profile and progress data
// class UserDataResult {
//   final bool isSuccess;
//   final Map<String, dynamic> profile;
//   final Map<int, Map<String, dynamic>> progress;
//   final int totalCoins;
//   final String? error;
//
//   UserDataResult({
//     required this.isSuccess,
//     required this.profile,
//     required this.progress,
//     required this.totalCoins,
//     this.error,
//   });
// }
//
// class UserDataService {
//   final FirebaseDatabase _database = FirebaseDatabase.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   /// Fetch both user profile and progress data
//   Future<UserDataResult> fetchUserData() async {
//     try {
//       final User? currentUser = _auth.currentUser;
//
//       if (currentUser == null) {
//         return UserDataResult(
//           isSuccess: false,
//           profile: {},
//           progress: {},
//           totalCoins: 0,
//           error: 'No authenticated user',
//         );
//       }
//
//       final String userId = currentUser.uid;
//       print('🔍 Fetching data for user: $userId');
//
//       // Fetch user profile data
//       final userProfileResult = await _fetchUserProfile(userId);
//
//       // Fetch user progress data
//       final progressResult = await _fetchUserProgress(userId);
//
//       return UserDataResult(
//         isSuccess: true,
//         profile: userProfileResult,
//         progress: progressResult['levels'] ?? {},
//         totalCoins: progressResult['coins'] ?? 0,
//       );
//
//     } catch (e) {
//       print('❌ Error in fetchUserData: $e');
//       return UserDataResult(
//         isSuccess: false,
//         profile: {},
//         progress: {},
//         totalCoins: 0,
//         error: e.toString(),
//       );
//     }
//   }
//
//   /// Fetch user profile from users/{userId}
//   Future<Map<String, dynamic>> _fetchUserProfile(String userId) async {
//     try {
//       final DatabaseReference userRef = _database.ref().child('users').child(userId);
//       final DatabaseEvent event = await userRef.once();
//
//       if (event.snapshot.exists) {
//         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
//         print('✅ User profile fetched: ${data.keys.toList()}');
//         return data;
//       } else {
//         print('⚠️ No user profile found for $userId');
//         return {};
//       }
//     } catch (e) {
//       print('❌ Error fetching user profile: $e');
//       return {};
//     }
//   }
//
//   /// Fetch user progress from Progress/{userId}
//   Future<Map<String, dynamic>> _fetchUserProgress(String userId) async {
//     try {
//       final DatabaseReference progressRef = _database.ref().child('Progress').child(userId);
//       final DatabaseEvent event = await progressRef.once();
//
//       if (event.snapshot.exists) {
//         print('🔍 Raw Firebase data type: ${event.snapshot.value.runtimeType}');
//         print('🔍 Raw Firebase data: ${event.snapshot.value}');
//
//         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
//         print('✅ User progress fetched: ${data.keys.toList()}');
//
//         // Convert levels data to the expected format
//         Map<int, Map<String, dynamic>> formattedLevels = {};
//
//         if (data['levels'] != null) {
//           print('🔍 Levels data type: ${data['levels'].runtimeType}');
//           print('🔍 Levels data content: ${data['levels']}');
//
//           try {
//             if (data['levels'] is Map) {
//               final levelsData = Map<String, dynamic>.from(data['levels']);
//               levelsData.forEach((key, value) {
//                 if (value is Map) {
//                   final levelId = int.tryParse(key.toString());
//                   if (levelId != null) {
//                     formattedLevels[levelId] = Map<String, dynamic>.from(value);
//                   }
//                 }
//               });
//             } else if (data['levels'] is List) {
//               // Handle case where levels might be stored as a list
//               print('⚠️ Levels data is a List, not a Map. Content: ${data['levels']}');
//               final List<dynamic> levelsList = data['levels'] as List<dynamic>;
//               for (int i = 0; i < levelsList.length; i++) {
//                 if (levelsList[i] is Map) {
//                   final levelData = Map<String, dynamic>.from(levelsList[i]);
//                   final levelId = levelData['levelId'] ?? (i + 1);
//                   formattedLevels[levelId] = levelData;
//                 }
//               }
//             }
//           } catch (e) {
//             print('❌ Error processing levels data: $e');
//             print('❌ Levels raw data: ${data['levels']}');
//           }
//         }
//
//         print('📊 Formatted levels: ${formattedLevels.keys.toList()}');
//
//         // Handle scenarios data - it can be either a List or Map
//         dynamic scenariosData = {};
//         if (data['scenarios'] != null) {
//           if (data['scenarios'] is List) {
//             // Convert list of scenario IDs to a map format
//             final List<dynamic> scenariosList = data['scenarios'] as List<dynamic>;
//             scenariosData = Map<String, dynamic>.fromIterables(
//                 scenariosList.map((id) => id.toString()),
//                 scenariosList.map((id) => {'scenarioId': id, 'completed': false})
//             );
//             print('📋 Converted scenarios list to map: ${scenariosData.keys.toList()}');
//           } else if (data['scenarios'] is Map) {
//             scenariosData = Map<String, dynamic>.from(data['scenarios']);
//             print('📋 Scenarios already in map format: ${scenariosData.keys.toList()}');
//           }
//         }
//
//         return {
//           'levels': formattedLevels,
//           'coins': data['coins'] ?? 0,
//           'correctAnswers': data['correctAnswers'] ?? 0,
//           'totalAnswers': data['totalAnswers'] ?? 0,
//           'levelsCompleted': data['levelsCompleted'] ?? 0,
//           'lastActivity': data['lastActivity'],
//           'starsEarned': data['starsEarned'] ?? 0,
//           'scenarios': scenariosData,
//         };
//       } else {
//         print('⚠️ No progress data found for $userId');
//         return {
//           'levels': <int, Map<String, dynamic>>{},
//           'coins': 0,
//           'correctAnswers': 0,
//           'totalAnswers': 0,
//           'levelsCompleted': 0,
//           'starsEarned': 0,
//           'scenarios': {},
//         };
//       }
//     } catch (e) {
//       print('❌ Error fetching user progress: $e');
//       print('❌ Stack trace: ${StackTrace.current}');
//       return {
//         'levels': <int, Map<String, dynamic>>{},
//         'coins': 0,
//         'correctAnswers': 0,
//         'totalAnswers': 0,
//         'levelsCompleted': 0,
//         'starsEarned': 0,
//         'scenarios': {},
//       };
//     }
//   }
//
//   /// Update user progress when a level is completed
//   Future<bool> updateLevelProgress({
//     required int levelId,
//     required String levelName,
//     required bool isCompleted,
//     required int starsEarned,
//     required int correctAnswers,
//     required int totalAnswers,
//     int? coinsEarned,
//   }) async {
//     try {
//       final User? currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         print('❌ No authenticated user for progress update');
//         return false;
//       }
//
//       final String userId = currentUser.uid;
//       final DatabaseReference progressRef = _database.ref().child('Progress').child(userId);
//
//       // Get current progress to update totals
//       final currentProgressSnapshot = await progressRef.once();
//       Map<String, dynamic> currentProgress = {};
//
//       if (currentProgressSnapshot.snapshot.exists) {
//         currentProgress = Map<String, dynamic>.from(currentProgressSnapshot.snapshot.value as Map);
//       }
//
//       // Calculate new totals
//       int currentCoins = currentProgress['coins'] ?? 0;
//       int currentCorrectAnswers = currentProgress['correctAnswers'] ?? 0;
//       int currentTotalAnswers = currentProgress['totalAnswers'] ?? 0;
//       int currentLevelsCompleted = currentProgress['levelsCompleted'] ?? 0;
//       int currentStarsEarned = currentProgress['starsEarned'] ?? 0;
//
//       // Update level-specific data
//       Map<String, dynamic> levelUpdateData = {
//         'levels/$levelId/levelId': levelId,
//         'levels/$levelId/levelName': levelName,
//         'levels/$levelId/isCompleted': isCompleted,
//         'levels/$levelId/starsEarned': starsEarned,
//         'levels/$levelId/correctAnswers': correctAnswers,
//         'levels/$levelId/totalAnswers': totalAnswers,
//         'levels/$levelId/lastPlayed': DateTime.now().millisecondsSinceEpoch,
//       };
//
//       // Update global totals only if level is newly completed
//       Map<String, dynamic>? existingLevel = currentProgress['levels']?[levelId.toString()];
//       bool wasAlreadyCompleted = existingLevel?['isCompleted'] ?? false;
//
//       if (isCompleted && !wasAlreadyCompleted) {
//         // Level newly completed - update totals
//         levelUpdateData.addAll({
//           'coins': currentCoins + (coinsEarned ?? (starsEarned * 10)),
//           'correctAnswers': currentCorrectAnswers + correctAnswers,
//           'totalAnswers': currentTotalAnswers + totalAnswers,
//           'levelsCompleted': currentLevelsCompleted + 1,
//           'starsEarned': currentStarsEarned + starsEarned,
//           'lastActivity': DateTime.now().millisecondsSinceEpoch,
//         });
//       } else if (isCompleted) {
//         // Level was already completed - just update specific level data and timestamp
//         levelUpdateData['lastActivity'] = DateTime.now().millisecondsSinceEpoch;
//       }
//
//       await progressRef.update(levelUpdateData);
//       print('✅ Progress updated for level $levelId');
//       return true;
//
//     } catch (e) {
//       print('❌ Error updating level progress: $e');
//       return false;
//     }
//   }
//
//   /// Get current user ID
//   String? getCurrentUserId() {
//     return _auth.currentUser?.uid;
//   }
//
//   /// Check if user is authenticated
//   bool isUserAuthenticated() {
//     return _auth.currentUser != null;
//   }
//
//   /// Sign out user
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       print('✅ User signed out successfully');
//     } catch (e) {
//       print('❌ Error signing out: $e');
//     }
//   }
// }


import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Result class to hold both user profile and progress data
class UserDataResult {
  final bool isSuccess;
  final Map<String, dynamic> profile;
  final Map<int, Map<String, dynamic>> progress;
  final int totalCoins;
  final String? error;

  UserDataResult({
    required this.isSuccess,
    required this.profile,
    required this.progress,
    required this.totalCoins,
    this.error,
  });
}

/// Enhanced result class for module-specific data
class ModuleUserDataResult {
  final bool isSuccess;
  final Map<String, dynamic> profile;
  final Map<String, Map<int, Map<String, dynamic>>> moduleProgress; // Module -> Level -> Data
  final Map<String, int> moduleCoins; // Coins per module
  final int totalCoins;
  final String? error;

  ModuleUserDataResult({
    required this.isSuccess,
    required this.profile,
    required this.moduleProgress,
    required this.moduleCoins,
    required this.totalCoins,
    this.error,
  });
}

class UserDataService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch user data organized by modules
  Future<ModuleUserDataResult> fetchUserDataByModules(List<String> moduleIds) async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        return ModuleUserDataResult(
          isSuccess: false,
          profile: {},
          moduleProgress: {},
          moduleCoins: {},
          totalCoins: 0,
          error: 'No authenticated user',
        );
      }

      final String userId = currentUser.uid;
      print('🔍 Fetching module-based data for user: $userId');
      print('📚 Modules: ${moduleIds.join(', ')}');

      // Fetch user profile data
      final userProfileResult = await _fetchUserProfile(userId);

      // Fetch progress for each module
      Map<String, Map<int, Map<String, dynamic>>> allModuleProgress = {};
      Map<String, int> moduleCoins = {};
      int totalCoins = 0;

      for (String moduleId in moduleIds) {
        final moduleProgressResult = await _fetchModuleProgress(userId, moduleId);
        allModuleProgress[moduleId] = moduleProgressResult['levels'] ?? {};

        int moduleCoinTotal = moduleProgressResult['coins'] ?? 0;
        moduleCoins[moduleId] = moduleCoinTotal;
        totalCoins += moduleCoinTotal;

        print('📊 Module $moduleId: ${allModuleProgress[moduleId]?.length ?? 0} levels, $moduleCoinTotal coins');
      }

      return ModuleUserDataResult(
        isSuccess: true,
        profile: userProfileResult,
        moduleProgress: allModuleProgress,
        moduleCoins: moduleCoins,
        totalCoins: totalCoins,
      );

    } catch (e) {
      print('❌ Error in fetchUserDataByModules: $e');
      return ModuleUserDataResult(
        isSuccess: false,
        profile: {},
        moduleProgress: {},
        moduleCoins: {},
        totalCoins: 0,
        error: e.toString(),
      );
    }
  }

  /// Legacy method for backward compatibility
  Future<UserDataResult> fetchUserData() async {
    // For backward compatibility, fetch all modules and combine
    final moduleIds = ['human_centered_mindset', 'ai_ethics', 'ai_pedagogy'];
    final moduleResult = await fetchUserDataByModules(moduleIds);

    // Combine all module progress into single map (legacy format)
    Map<int, Map<String, dynamic>> combinedProgress = {};
    int globalLevelId = 1;

    for (String moduleId in moduleIds) {
      final moduleProgress = moduleResult.moduleProgress[moduleId] ?? {};
      moduleProgress.forEach((levelId, levelData) {
        // Add module information to level data
        Map<String, dynamic> enhancedLevelData = Map.from(levelData);
        enhancedLevelData['moduleId'] = moduleId;
        enhancedLevelData['originalLevelId'] = levelId;

        combinedProgress[globalLevelId] = enhancedLevelData;
        globalLevelId++;
      });
    }

    return UserDataResult(
      isSuccess: moduleResult.isSuccess,
      profile: moduleResult.profile,
      progress: combinedProgress,
      totalCoins: moduleResult.totalCoins,
      error: moduleResult.error,
    );
  }

  /// Fetch user profile from users/{userId}
  Future<Map<String, dynamic>> _fetchUserProfile(String userId) async {
    try {
      final DatabaseReference userRef = _database.ref().child('users').child(userId);
      final DatabaseEvent event = await userRef.once();

      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        print('✅ User profile fetched: ${data.keys.toList()}');
        return data;
      } else {
        print('⚠️ No user profile found for $userId');
        return {};
      }
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return {};
    }
  }

  /// Fetch progress for a specific module
  Future<Map<String, dynamic>> _fetchModuleProgress(String userId, String moduleId) async {
    try {
      // Firebase structure: Progress/{userId}/{moduleId}/
      final DatabaseReference moduleRef = _database.ref()
          .child('Progress')
          .child(userId)
          .child(moduleId);

      final DatabaseEvent event = await moduleRef.once();

      if (event.snapshot.exists) {
        print('🔍 Raw Firebase data for $moduleId: ${event.snapshot.value}');

        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        print('✅ Module $moduleId progress fetched: ${data.keys.toList()}');

        // Convert levels data to the expected format
        Map<int, Map<String, dynamic>> formattedLevels = {};

        if (data['levels'] != null) {
          try {
            if (data['levels'] is Map) {
              final levelsData = Map<String, dynamic>.from(data['levels']);
              levelsData.forEach((key, value) {
                if (value is Map) {
                  final levelId = int.tryParse(key.toString());
                  if (levelId != null) {
                    Map<String, dynamic> levelData = Map<String, dynamic>.from(value);
                    // Ensure moduleId is stored in level data
                    levelData['moduleId'] = moduleId;
                    formattedLevels[levelId] = levelData;
                  }
                }
              });
            } else if (data['levels'] is List) {
              final List<dynamic> levelsList = data['levels'] as List<dynamic>;
              for (int i = 0; i < levelsList.length; i++) {
                if (levelsList[i] is Map) {
                  Map<String, dynamic> levelData = Map<String, dynamic>.from(levelsList[i]);
                  final levelId = levelData['levelId'] ?? (i + 1);
                  levelData['moduleId'] = moduleId;
                  formattedLevels[levelId] = levelData;
                }
              }
            }
          } catch (e) {
            print('❌ Error processing levels data for $moduleId: $e');
          }
        }

        print('📊 Module $moduleId formatted levels: ${formattedLevels.keys.toList()}');

        return {
          'levels': formattedLevels,
          'coins': data['coins'] ?? 0,
          'correctAnswers': data['correctAnswers'] ?? 0,
          'totalAnswers': data['totalAnswers'] ?? 0,
          'levelsCompleted': data['levelsCompleted'] ?? 0,
          'lastActivity': data['lastActivity'],
          'starsEarned': data['starsEarned'] ?? 0,
          'scenarios': data['scenarios'] ?? {},
        };
      } else {
        print('⚠️ No progress data found for module $moduleId');
        return {
          'levels': <int, Map<String, dynamic>>{},
          'coins': 0,
          'correctAnswers': 0,
          'totalAnswers': 0,
          'levelsCompleted': 0,
          'starsEarned': 0,
          'scenarios': {},
        };
      }
    } catch (e) {
      print('❌ Error fetching progress for module $moduleId: $e');
      return {
        'levels': <int, Map<String, dynamic>>{},
        'coins': 0,
        'correctAnswers': 0,
        'totalAnswers': 0,
        'levelsCompleted': 0,
        'starsEarned': 0,
        'scenarios': {},
      };
    }
  }

  /// Update user progress for a specific module and level
  Future<bool> updateModuleLevelProgress({
    required String moduleId,
    required int levelId,
    required String levelName,
    required bool isCompleted,
    required int starsEarned,
    required int correctAnswers,
    required int totalAnswers,
    int? coinsEarned,
  }) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user for progress update');
        return false;
      }

      final String userId = currentUser.uid;

      // Firebase structure: Progress/{userId}/{moduleId}/
      final DatabaseReference moduleRef = _database.ref()
          .child('Progress')
          .child(userId)
          .child(moduleId);

      // Get current module progress
      final currentProgressSnapshot = await moduleRef.once();
      Map<String, dynamic> currentProgress = {};

      if (currentProgressSnapshot.snapshot.exists) {
        currentProgress = Map<String, dynamic>.from(currentProgressSnapshot.snapshot.value as Map);
      }

      // Calculate new totals for this module
      int currentCoins = currentProgress['coins'] ?? 0;
      int currentCorrectAnswers = currentProgress['correctAnswers'] ?? 0;
      int currentTotalAnswers = currentProgress['totalAnswers'] ?? 0;
      int currentLevelsCompleted = currentProgress['levelsCompleted'] ?? 0;
      int currentStarsEarned = currentProgress['starsEarned'] ?? 0;

      // Update level-specific data
      Map<String, dynamic> levelUpdateData = {
        'levels/$levelId/levelId': levelId,
        'levels/$levelId/levelName': levelName,
        'levels/$levelId/isCompleted': isCompleted,
        'levels/$levelId/starsEarned': starsEarned,
        'levels/$levelId/correctAnswers': correctAnswers,
        'levels/$levelId/totalAnswers': totalAnswers,
        'levels/$levelId/moduleId': moduleId,
        'levels/$levelId/lastPlayed': DateTime.now().millisecondsSinceEpoch,
      };

      // Check if level was already completed
      Map<String, dynamic>? existingLevel = currentProgress['levels']?[levelId.toString()];
      bool wasAlreadyCompleted = existingLevel?['isCompleted'] ?? false;

      if (isCompleted && !wasAlreadyCompleted) {
        // Level newly completed - update module totals
        levelUpdateData.addAll({
          'coins': currentCoins + (coinsEarned ?? (starsEarned * 10)),
          'correctAnswers': currentCorrectAnswers + correctAnswers,
          'totalAnswers': currentTotalAnswers + totalAnswers,
          'levelsCompleted': currentLevelsCompleted + 1,
          'starsEarned': currentStarsEarned + starsEarned,
          'lastActivity': DateTime.now().millisecondsSinceEpoch,
        });
      } else if (isCompleted) {
        // Level was already completed - just update timestamp
        levelUpdateData['lastActivity'] = DateTime.now().millisecondsSinceEpoch;
      }

      await moduleRef.update(levelUpdateData);
      print('✅ Progress updated for module $moduleId, level $levelId');
      return true;

    } catch (e) {
      print('❌ Error updating module level progress: $e');
      return false;
    }
  }

  /// Legacy method for backward compatibility
  Future<bool> updateLevelProgress({
    required int levelId,
    required String levelName,
    required bool isCompleted,
    required int starsEarned,
    required int correctAnswers,
    required int totalAnswers,
    int? coinsEarned,
    String? moduleId, // Optional module ID for legacy support
  }) async {
    // If moduleId is provided, use the new method
    if (moduleId != null) {
      return updateModuleLevelProgress(
        moduleId: moduleId,
        levelId: levelId,
        levelName: levelName,
        isCompleted: isCompleted,
        starsEarned: starsEarned,
        correctAnswers: correctAnswers,
        totalAnswers: totalAnswers,
        coinsEarned: coinsEarned,
      );
    }

    // Legacy behavior - determine module from level ID
    String determinedModuleId;
    if (levelId >= 1 && levelId <= 3) {
      determinedModuleId = 'human_centered_mindset';
    } else if (levelId >= 4 && levelId <= 6) {
      determinedModuleId = 'ai_ethics';
    } else if (levelId >= 7 && levelId <= 9) {
      determinedModuleId = 'ai_pedagogy';
    } else {
      determinedModuleId = 'human_centered_mindset'; // Default
    }

    // Convert global level ID to module level ID
    int moduleLevelId = ((levelId - 1) % 3) + 1;

    return updateModuleLevelProgress(
      moduleId: determinedModuleId,
      levelId: moduleLevelId,
      levelName: levelName,
      isCompleted: isCompleted,
      starsEarned: starsEarned,
      correctAnswers: correctAnswers,
      totalAnswers: totalAnswers,
      coinsEarned: coinsEarned,
    );
  }

  /// Get progress for a specific module
  Future<Map<int, Map<String, dynamic>>> getModuleProgress(String moduleId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return {};
      }

      final result = await _fetchModuleProgress(currentUser.uid, moduleId);
      return result['levels'] ?? {};
    } catch (e) {
      print('❌ Error getting module progress: $e');
      return {};
    }
  }

  /// Get coins for a specific module
  Future<int> getModuleCoins(String moduleId) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return 0;
      }

      final result = await _fetchModuleProgress(currentUser.uid, moduleId);
      return result['coins'] ?? 0;
    } catch (e) {
      print('❌ Error getting module coins: $e');
      return 0;
    }
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Check if user is authenticated
  bool isUserAuthenticated() {
    return _auth.currentUser != null;
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Error signing out: $e');
    }
  }
}