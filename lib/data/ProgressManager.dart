// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import '../models/JsonModel.dart';
// //
// // class ProgressManager {
// //   final FirebaseAuth _auth;
// //   final DatabaseReference _database;
// //   final String moduleID;
// //   final String moduleName;
// //   final int levelId;
// //   final String levelName;
// //
// //   ProgressManager({
// //     required FirebaseAuth auth,
// //     required DatabaseReference database,
// //     required this.moduleID,
// //     required this.moduleName,
// //     required this.levelId,
// //     required this.levelName,
// //   }) : _auth = auth, _database = database;
// //
// //   /// Load user data for the specific module
// //   Future<Map<String, dynamic>> loadUserData() async {
// //     try {
// //       User? user = _auth.currentUser;
// //       if (user == null) {
// //         return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
// //       }
// //
// //       DatabaseReference moduleRef = _database
// //           .child('Progress')
// //           .child(user.uid)
// //           .child(moduleID);
// //
// //       DataSnapshot snapshot = await moduleRef.get();
// //
// //       if (snapshot.exists) {
// //         Map<String, dynamic> moduleData = Map<String, dynamic>.from(
// //           snapshot.value as Map,
// //         );
// //
// //         print('✅ Loaded user data for module $moduleID: '
// //             'coins=${moduleData['coins'] ?? 0}, '
// //             'correct=${moduleData['correctAnswers'] ?? 0}/'
// //             '${moduleData['totalAnswers'] ?? 0}');
// //
// //         return {
// //           'coins': moduleData['coins'] ?? 0,
// //           'correctAnswers': moduleData['correctAnswers'] ?? 0,
// //           'totalAnswers': moduleData['totalAnswers'] ?? 0,
// //         };
// //       } else {
// //         print('📝 No existing data for module $moduleID, starting fresh');
// //         return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
// //       }
// //     } catch (e) {
// //       print('❌ Error loading user data: $e');
// //       return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
// //     }
// //   }
// //
// //   /// Update progress for a specific scenario
// //   /// Returns updated coin count
// //   Future<int> updateScenarioProgress({
// //     required Scenario scenario,
// //     required bool isCorrect,
// //     required Map<String, dynamic> currentUserData,
// //   }) async {
// //     try {
// //       User? user = _auth.currentUser;
// //       if (user == null) return currentUserData['coins'] ?? 0;
// //
// //       int globalLevelId = _getGlobalLevelId(levelId, moduleID);
// //
// //       // Check if this scenario was already answered correctly
// //       DatabaseReference scenarioRef = _database
// //           .child('Progress')
// //           .child(user.uid)
// //           .child(moduleID)
// //           .child('scenarios')
// //           .child(scenario.id.toString());
// //
// //       DataSnapshot scenarioSnapshot = await scenarioRef.get();
// //
// //       bool wasAlreadyCorrect = false;
// //       int currentAttempts = 0;
// //
// //       if (scenarioSnapshot.exists) {
// //         Map<String, dynamic> scenarioData = Map<String, dynamic>.from(
// //           scenarioSnapshot.value as Map,
// //         );
// //         wasAlreadyCorrect = scenarioData['isCorrect'] ?? false;
// //         currentAttempts = scenarioData['attempts'] ?? 0;
// //       }
// //
// //       // Calculate coin reward
// //       int coinsToAdd = _calculateCoinReward(
// //         isCorrect: isCorrect,
// //         wasAlreadyCorrect: wasAlreadyCorrect,
// //         attempts: currentAttempts,
// //       );
// //
// //       // Update user stats
// //       int newTotalAnswers = currentUserData['totalAnswers'] + 1;
// //       int newCorrectAnswers = currentUserData['correctAnswers'];
// //       int newCoins = currentUserData['coins'] + coinsToAdd;
// //
// //       // Only increment correct answers if this is the first correct attempt
// //       if (isCorrect && !wasAlreadyCorrect) {
// //         newCorrectAnswers++;
// //       }
// //
// //       // Update module progress
// //       DatabaseReference moduleRef = _database
// //           .child('Progress')
// //           .child(user.uid)
// //           .child(moduleID);
// //
// //       await moduleRef.update({
// //         'moduleName': moduleName,
// //         'coins': newCoins,
// //         'correctAnswers': newCorrectAnswers,
// //         'totalAnswers': newTotalAnswers,
// //         'lastActivity': ServerValue.timestamp,
// //       });
// //
// //       // Update scenario-specific progress
// //       await scenarioRef.set({
// //         'scenarioId': scenario.id,
// //         'scenarioTitle': scenario.title,
// //         'levelId': globalLevelId,
// //         'uiLevelId': levelId,
// //         'levelName': levelName,
// //         'moduleId': moduleID,
// //         'isCorrect': isCorrect,
// //         'timestamp': ServerValue.timestamp,
// //         'attempts': currentAttempts + 1,
// //         'coinsEarned': coinsToAdd,
// //       });
// //
// //       print('✅ Scenario ${scenario.id} progress updated:');
// //       print('   Module: $moduleID');
// //       print('   Was already correct: $wasAlreadyCorrect');
// //       print('   Current attempt: ${currentAttempts + 1}');
// //       print('   Coins earned this attempt: $coinsToAdd');
// //       print('   Total coins: $newCoins');
// //
// //       return newCoins;
// //     } catch (e) {
// //       print('❌ Error updating scenario progress: $e');
// //       return currentUserData['coins'] ?? 0;
// //     }
// //   }
// //
// //   /// Update level progress
// //   Future<void> updateLevelProgress({
// //     required bool isCorrect,
// //     required int totalScenarios,
// //   }) async {
// //     try {
// //       User? user = _auth.currentUser;
// //       if (user == null) return;
// //
// //       int globalLevelId = _getGlobalLevelId(levelId, moduleID);
// //
// //       DatabaseReference levelRef = _database
// //           .child('Progress')
// //           .child(user.uid)
// //           .child(moduleID)
// //           .child('levels')
// //           .child(globalLevelId.toString());
// //
// //       DataSnapshot levelSnapshot = await levelRef.get();
// //       Map<String, dynamic> levelData = {};
// //
// //       if (levelSnapshot.exists) {
// //         levelData = Map<String, dynamic>.from(levelSnapshot.value as Map);
// //       }
// //
// //       int levelCorrectAnswers = (levelData['correctAnswers'] ?? 0);
// //       int levelTotalAnswers = (levelData['totalAnswers'] ?? 0);
// //
// //       if (isCorrect) {
// //         levelCorrectAnswers++;
// //       }
// //       levelTotalAnswers++;
// //
// //       await levelRef.set({
// //         'levelId': globalLevelId,
// //         'uiLevelId': levelId,
// //         'levelName': levelName,
// //         'moduleId': moduleID,
// //         'correctAnswers': levelCorrectAnswers,
// //         'totalAnswers': levelTotalAnswers,
// //         'lastPlayed': ServerValue.timestamp,
// //         'isCompleted': levelTotalAnswers >= totalScenarios,
// //         'totalScenarios': totalScenarios,
// //       });
// //
// //       print('✅ Level $globalLevelId (UI: $levelId) progress updated in module $moduleID');
// //     } catch (e) {
// //       print('❌ Error updating level progress: $e');
// //     }
// //   }
// //
// //   /// Award level completion bonus
// //   Future<int> awardLevelCompletionBonus({
// //     required int stars,
// //     required int currentCoins,
// //   }) async {
// //     try {
// //       User? user = _auth.currentUser;
// //       if (user == null) return currentCoins;
// //
// //       int globalLevelId = _getGlobalLevelId(levelId, moduleID);
// //
// //       // Check if level completion bonus was already awarded
// //       DatabaseReference levelRef = _database
// //           .child('Progress')
// //           .child(user.uid)
// //           .child(moduleID)
// //           .child('levels')
// //           .child(globalLevelId.toString());
// //
// //       DataSnapshot levelSnapshot = await levelRef.get();
// //       if (levelSnapshot.exists) {
// //         Map<String, dynamic> levelData = Map<String, dynamic>.from(
// //           levelSnapshot.value as Map,
// //         );
// //
// //         bool bonusAwarded = levelData['completionBonusAwarded'] ?? false;
// //         if (bonusAwarded) {
// //           print('🏆 Level completion bonus already awarded for level $globalLevelId');
// //           return currentCoins;
// //         }
// //       }
// //
// //       int bonusCoins = _calculateCompletionBonus(stars);
// //       int newTotalCoins = currentCoins + bonusCoins;
// //
// //       DatabaseReference moduleRef = _database
// //           .child('Progress')
// //           .child(user.uid)
// //           .child(moduleID);
// //
// //       // Get current module data
// //       DataSnapshot snapshot = await moduleRef.get();
// //       Map<String, dynamic> moduleData = {};
// //       if (snapshot.exists) {
// //         moduleData = Map<String, dynamic>.from(snapshot.value as Map);
// //       }
// //
// //       // Count completed levels in this module
// //       int completedLevelsCount = _countCompletedLevels(moduleData);
// //       completedLevelsCount++; // Add current level
// //
// //       int currentStarsEarned = moduleData['starsEarned'] ?? 0;
// //
// //       // Update module data
// //       await moduleRef.update({
// //         'coins': newTotalCoins,
// //         'levelsCompleted': completedLevelsCount,
// //         'starsEarned': currentStarsEarned + stars,
// //         'lastLevelCompleted': globalLevelId,
// //         'lastLevelCompletedName': levelName,
// //         'lastCompletionDate': ServerValue.timestamp,
// //       });
// //
// //       // Mark completion bonus as awarded
// //       await levelRef.update({
// //         'completionBonusAwarded': true,
// //         'completionBonusCoins': bonusCoins,
// //         'starsEarned': stars,
// //       });
// //
// //       print('🏆 Level completion bonus awarded:');
// //       print('   Global Level ID: $globalLevelId');
// //       print('   UI Level ID: $levelId');
// //       print('   Module: $moduleID');
// //       print('   Stars: $stars');
// //       print('   Bonus Coins: $bonusCoins');
// //       print('   Total Coins: $newTotalCoins');
// //
// //       return newTotalCoins;
// //     } catch (e) {
// //       print('❌ Error awarding level completion bonus: $e');
// //       return currentCoins;
// //     }
// //   }
// //
// //   /// Calculate coin reward based on scenario attempt
// //   int _calculateCoinReward({
// //     required bool isCorrect,
// //     required bool wasAlreadyCorrect,
// //     required int attempts,
// //   }) {
// //     if (!isCorrect) {
// //       return 0; // No coins for wrong answers
// //     }
// //
// //     if (wasAlreadyCorrect) {
// //       return 0; // No additional coins if already answered correctly
// //     }
// //
// //     // First correct attempt gets full reward
// //     if (attempts == 0) {
// //       return 10;
// //     }
// //
// //     // Reduced rewards for subsequent attempts
// //     switch (attempts) {
// //       case 1:
// //         return 7; // Second attempt
// //       case 2:
// //         return 5; // Third attempt
// //       case 3:
// //         return 3; // Fourth attempt
// //       default:
// //         return 1; // Fifth+ attempts get minimal reward
// //     }
// //   }
// //
// //   /// Calculate completion bonus based on stars
// //   int _calculateCompletionBonus(int stars) {
// //     switch (stars) {
// //       case 3:
// //         return 50;
// //       case 2:
// //         return 30;
// //       case 1:
// //         return 20;
// //       default:
// //         return 10;
// //     }
// //   }
// //
// //   /// Count completed levels in module
// //   int _countCompletedLevels(Map<String, dynamic> moduleData) {
// //     int completedLevelsCount = 0;
// //     Map<String, dynamic> levelsData = moduleData['levels'] ?? {};
// //
// //     for (var levelEntry in levelsData.entries) {
// //       Map<String, dynamic> levelInfo = Map<String, dynamic>.from(
// //         levelEntry.value as Map,
// //       );
// //       bool isCompleted = levelInfo['isCompleted'] ?? false;
// //       if (isCompleted) {
// //         completedLevelsCount++;
// //       }
// //     }
// //
// //     return completedLevelsCount;
// //   }
// //
// //   /// Convert UI level ID to global level ID
// //   int _getGlobalLevelId(int uiLevelId, String moduleID) {
// //     switch (moduleID) {
// //       case 'human_centered_mindset':
// //         return uiLevelId; // UI 1-3 → Global 1-3
// //       case 'ai_ethics':
// //         return uiLevelId + 3; // UI 1-3 → Global 4-6
// //       case 'ai_foundations_applications':
// //         return uiLevelId + 6; // UI 1-3 → Global 7-9
// //       case 'ai_pedagogy':
// //         return uiLevelId + 9; // UI 1-3 → Global 10-12
// //       case 'ai_professional_development':
// //         return uiLevelId + 12; // UI 1-3 → Global 13-15
// //       default:
// //         return uiLevelId;
// //     }
// //   }
// //
// //   /// Get coin stream for real-time updates
// //   Stream<DatabaseEvent> getCoinStream() {
// //     User? user = _auth.currentUser;
// //     if (user == null) {
// //       return Stream.empty();
// //     }
// //
// //     return _database
// //         .child('Progress')
// //         .child(user.uid)
// //         .child(moduleID)
// //         .child('coins')
// //         .onValue;
// //   }
// // }
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../models/JsonModel.dart';
//
// class ProgressManager {
//   final FirebaseAuth _auth;
//   final DatabaseReference _database;
//   final String moduleID;
//   final String moduleName;
//   final int levelId;
//   final String levelName;
//
//   ProgressManager({
//     required FirebaseAuth auth,
//     required DatabaseReference database,
//     required this.moduleID,
//     required this.moduleName,
//     required this.levelId,
//     required this.levelName,
//   }) : _auth = auth, _database = database;
//
//   /// Load user data for the specific module
//   Future<Map<String, dynamic>> loadUserData() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) {
//         return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
//       }
//
//       DatabaseReference moduleRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID);
//
//       DataSnapshot snapshot = await moduleRef.get();
//
//       if (snapshot.exists) {
//         Map<String, dynamic> moduleData = Map<String, dynamic>.from(
//           snapshot.value as Map,
//         );
//
//         print('✅ Loaded user data for module $moduleID: '
//             'coins=${moduleData['coins'] ?? 0}, '
//             'correct=${moduleData['correctAnswers'] ?? 0}/'
//             '${moduleData['totalAnswers'] ?? 0}');
//
//         return {
//           'coins': moduleData['coins'] ?? 0,
//           'correctAnswers': moduleData['correctAnswers'] ?? 0,
//           'totalAnswers': moduleData['totalAnswers'] ?? 0,
//         };
//       } else {
//         print('📝 No existing data for module $moduleID, starting fresh');
//         return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
//       }
//     } catch (e) {
//       print('❌ Error loading user data: $e');
//       return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
//     }
//   }
//
//
//   /// Update progress for a specific scenario
//   /// Returns updated coin count
//   Future<int> updateScenarioProgress({
//     required Scenario scenario,
//     required bool isCorrect,
//     required Map<String, dynamic> currentUserData,
//     List<int>? selectedReasoningIndices,
//     List<String>? reasoningOptions,
//     int? userAnswer,
//   }) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return currentUserData['coins'] ?? 0;
//
//       int globalLevelId = _getGlobalLevelId(levelId, moduleID);
//
//       // Check if this scenario was already answered correctly
//       DatabaseReference scenarioRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID)
//           .child('scenarios')
//           .child(scenario.id.toString());
//
//       DataSnapshot scenarioSnapshot = await scenarioRef.get();
//
//       bool wasAlreadyCorrect = false;
//       int currentAttempts = 0;
//       Map<String, dynamic> existingData = {};
//
//       if (scenarioSnapshot.exists) {
//         existingData = Map<String, dynamic>.from(scenarioSnapshot.value as Map);
//         wasAlreadyCorrect = existingData['isCorrect'] ?? false;
//         currentAttempts = existingData['attempts'] ?? 0;
//       }
//
//       // Calculate coin reward
//       int coinsToAdd = _calculateCoinReward(
//         isCorrect: isCorrect,
//         wasAlreadyCorrect: wasAlreadyCorrect,
//         attempts: currentAttempts,
//       );
//
//       // Update user stats
//       int newTotalAnswers = currentUserData['totalAnswers'] + 1;
//       int newCorrectAnswers = currentUserData['correctAnswers'];
//       int newCoins = currentUserData['coins'] + coinsToAdd;
//
//       // Only increment correct answers if this is the first correct attempt
//       if (isCorrect && !wasAlreadyCorrect) {
//         newCorrectAnswers++;
//       }
//
//       // Update module progress
//       DatabaseReference moduleRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID);
//
//       await moduleRef.update({
//         'moduleName': moduleName,
//         'coins': newCoins,
//         'correctAnswers': newCorrectAnswers,
//         'totalAnswers': newTotalAnswers,
//         'lastActivity': ServerValue.timestamp,
//       });
//
//       // Prepare scenario data - PRESERVE existing reasoning if it exists
//       Map<String, dynamic> scenarioData = {
//         'scenarioId': scenario.id,
//         'scenarioTitle': scenario.title,
//         'levelId': globalLevelId,
//         'uiLevelId': levelId,
//         'levelName': levelName,
//         'moduleId': moduleID,
//         'isCorrect': isCorrect,
//         'timestamp': ServerValue.timestamp,
//         'attempts': currentAttempts + 1,
//         'coinsEarned': coinsToAdd,
//       };
//
//       // Add reasoning data if provided
//       if (selectedReasoningIndices != null &&
//           reasoningOptions != null &&
//           userAnswer != null &&
//           selectedReasoningIndices.isNotEmpty) {
//
//         List<String> reasoningTexts = selectedReasoningIndices
//             .map((index) => reasoningOptions[index])
//             .toList();
//
//         scenarioData['reasoning'] = {
//           'selectedReasoningIndices': selectedReasoningIndices,
//           'selectedReasoningTexts': reasoningTexts,
//           'userAnswer': userAnswer,
//           'correctAnswer': scenario.correctAnswer,
//           'reasoningTimestamp': ServerValue.timestamp,
//         };
//       } else if (existingData.containsKey('reasoning')) {
//         // Preserve existing reasoning data
//         scenarioData['reasoning'] = existingData['reasoning'];
//       }
//
//       // Update scenario progress using update() instead of set() to be safer
//       await scenarioRef.update(scenarioData);
//
//       print('✅ Scenario ${scenario.id} progress updated:');
//       print('   Module: $moduleID');
//       print('   Path: Progress/${user.uid}/$moduleID/scenarios/${scenario.id}');
//       print('   Was already correct: $wasAlreadyCorrect');
//       print('   Current attempt: ${currentAttempts + 1}');
//       print('   Coins earned: $coinsToAdd');
//       print('   Total coins: $newCoins');
//       print('   Reasoning saved: ${selectedReasoningIndices?.isNotEmpty ?? false}');
//
//       return newCoins;
//     } catch (e) {
//       print('❌ Error updating scenario progress: $e');
//       return currentUserData['coins'] ?? 0;
//     }
//   }
//
//   /// DEPRECATED - Use updateScenarioProgress with reasoning parameters instead
//   @deprecated
//   Future<void> saveScenarioReasoning({
//     required Scenario scenario,
//     required List<int> selectedReasoningIndices,
//     required List<String> reasoningOptions,
//     required int userAnswer,
//   }) async {
//     print('⚠️ saveScenarioReasoning is deprecated. Use updateScenarioProgress with reasoning parameters.');
//
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       DatabaseReference scenarioRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID)
//           .child('scenarios')
//           .child(scenario.id.toString());
//
//       List<String> reasoningTexts = selectedReasoningIndices
//           .map((index) => reasoningOptions[index])
//           .toList();
//
//       Map<String, dynamic> reasoningData = {
//         'selectedReasoningIndices': selectedReasoningIndices,
//         'selectedReasoningTexts': reasoningTexts,
//         'userAnswer': userAnswer,
//         'correctAnswer': scenario.correctAnswer,
//         'reasoningTimestamp': ServerValue.timestamp,
//       };
//
//       await scenarioRef.update({'reasoning': reasoningData});
//       print('✅ Reasoning saved for scenario ${scenario.id}');
//     } catch (e) {
//       print('❌ Error saving reasoning: $e');
//     }
//   }
//   /// Update level progress
//   Future<void> updateLevelProgress({
//     required bool isCorrect,
//     required int totalScenarios,
//   }) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return;
//
//       int globalLevelId = _getGlobalLevelId(levelId, moduleID);
//
//       DatabaseReference levelRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID)
//           .child('levels')
//           .child(levelId.toString()); // Using UI level ID to match your structure
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
//         'levelId': globalLevelId,
//         'uiLevelId': levelId,
//         'levelName': levelName,
//         'moduleId': moduleID,
//         'correctAnswers': levelCorrectAnswers,
//         'totalAnswers': levelTotalAnswers,
//         'lastPlayed': ServerValue.timestamp,
//         'isCompleted': levelTotalAnswers >= totalScenarios,
//         'totalScenarios': totalScenarios,
//       });
//
//       print('✅ Level $globalLevelId (UI: $levelId) progress updated in module $moduleID');
//     } catch (e) {
//       print('❌ Error updating level progress: $e');
//     }
//   }
//
//
//
//   /// Load scenario reasoning data (optional - for future use)
//   Future<Map<String, dynamic>?> loadScenarioReasoning(Scenario scenario) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return null;
//
//       DatabaseReference reasoningRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID)
//           .child('levels')
//           .child(levelId.toString())
//           .child('scenarios')
//           .child(scenario.id.toString())
//           .child('reasoning');
//
//       DataSnapshot snapshot = await reasoningRef.get();
//
//       if (snapshot.exists) {
//         return Map<String, dynamic>.from(snapshot.value as Map);
//       }
//
//       return null;
//     } catch (e) {
//       print('❌ Error loading scenario reasoning: $e');
//       return null;
//     }
//   }
//
//   /// Award level completion bonus
//   Future<int> awardLevelCompletionBonus({
//     required int stars,
//     required int currentCoins,
//   }) async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) return currentCoins;
//
//       int globalLevelId = _getGlobalLevelId(levelId, moduleID);
//
//       // Check if level completion bonus was already awarded
//       DatabaseReference levelRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID)
//           .child('levels')
//           .child(levelId.toString()); // Using UI level ID
//
//       DataSnapshot levelSnapshot = await levelRef.get();
//       if (levelSnapshot.exists) {
//         Map<String, dynamic> levelData = Map<String, dynamic>.from(
//           levelSnapshot.value as Map,
//         );
//
//         bool bonusAwarded = levelData['completionBonusAwarded'] ?? false;
//         if (bonusAwarded) {
//           print('🏆 Level completion bonus already awarded for level $levelId');
//           return currentCoins;
//         }
//       }
//
//       int bonusCoins = _calculateCompletionBonus(stars);
//       int newTotalCoins = currentCoins + bonusCoins;
//
//       DatabaseReference moduleRef = _database
//           .child('Progress')
//           .child(user.uid)
//           .child(moduleID);
//
//       // Get current module data
//       DataSnapshot snapshot = await moduleRef.get();
//       Map<String, dynamic> moduleData = {};
//       if (snapshot.exists) {
//         moduleData = Map<String, dynamic>.from(snapshot.value as Map);
//       }
//
//       // Count completed levels in this module
//       int completedLevelsCount = _countCompletedLevels(moduleData);
//       completedLevelsCount++; // Add current level
//
//       int currentStarsEarned = moduleData['starsEarned'] ?? 0;
//
//       // Update module data
//       await moduleRef.update({
//         'coins': newTotalCoins,
//         'levelsCompleted': completedLevelsCount,
//         'starsEarned': currentStarsEarned + stars,
//         'lastLevelCompleted': globalLevelId,
//         'lastLevelCompletedName': levelName,
//         'lastCompletionDate': ServerValue.timestamp,
//       });
//
//       // Mark completion bonus as awarded
//       await levelRef.update({
//         'completionBonusAwarded': true,
//         'completionBonusCoins': bonusCoins,
//         'starsEarned': stars,
//       });
//
//       print('🏆 Level completion bonus awarded:');
//       print('   Global Level ID: $globalLevelId');
//       print('   UI Level ID: $levelId');
//       print('   Module: $moduleID');
//       print('   Stars: $stars');
//       print('   Bonus Coins: $bonusCoins');
//       print('   Total Coins: $newTotalCoins');
//
//       return newTotalCoins;
//     } catch (e) {
//       print('❌ Error awarding level completion bonus: $e');
//       return currentCoins;
//     }
//   }
//
//   /// Calculate coin reward based on scenario attempt
//   int _calculateCoinReward({
//     required bool isCorrect,
//     required bool wasAlreadyCorrect,
//     required int attempts,
//   }) {
//     if (!isCorrect) {
//       return 0; // No coins for wrong answers
//     }
//
//     if (wasAlreadyCorrect) {
//       return 0; // No additional coins if already answered correctly
//     }
//
//     // First correct attempt gets full reward
//     if (attempts == 0) {
//       return 10;
//     }
//
//     // Reduced rewards for subsequent attempts
//     switch (attempts) {
//       case 1:
//         return 7; // Second attempt
//       case 2:
//         return 5; // Third attempt
//       case 3:
//         return 3; // Fourth attempt
//       default:
//         return 1; // Fifth+ attempts get minimal reward
//     }
//   }
//
//   /// Calculate completion bonus based on stars
//   int _calculateCompletionBonus(int stars) {
//     switch (stars) {
//       case 3:
//         return 50;
//       case 2:
//         return 30;
//       case 1:
//         return 20;
//       default:
//         return 10;
//     }
//   }
//
//   /// Count completed levels in module
//   int _countCompletedLevels(Map<String, dynamic> moduleData) {
//     int completedLevelsCount = 0;
//     Map<String, dynamic> levelsData = moduleData['levels'] ?? {};
//
//     for (var levelEntry in levelsData.entries) {
//       Map<String, dynamic> levelInfo = Map<String, dynamic>.from(
//         levelEntry.value as Map,
//       );
//       bool isCompleted = levelInfo['isCompleted'] ?? false;
//       if (isCompleted) {
//         completedLevelsCount++;
//       }
//     }
//
//     return completedLevelsCount;
//   }
//
//   /// Convert UI level ID to global level ID
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
//   /// Get coin stream for real-time updates
//   Stream<DatabaseEvent> getCoinStream() {
//     User? user = _auth.currentUser;
//     if (user == null) {
//       return Stream.empty();
//     }
//
//     return _database
//         .child('Progress')
//         .child(user.uid)
//         .child(moduleID)
//         .child('coins')
//         .onValue;
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/JsonModel.dart';

class ProgressManager {
  final FirebaseAuth _auth;
  final DatabaseReference _database;
  final String moduleID;
  final String moduleName;
  final int levelId;
  final String levelName;

  ProgressManager({
    required FirebaseAuth auth,
    required DatabaseReference database,
    required this.moduleID,
    required this.moduleName,
    required this.levelId,
    required this.levelName,
  }) : _auth = auth, _database = database;

  /// Load user data for the specific module
  Future<Map<String, dynamic>> loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
      }

      DatabaseReference moduleRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID);

      DataSnapshot snapshot = await moduleRef.get();

      if (snapshot.exists) {
        Map<String, dynamic> moduleData = Map<String, dynamic>.from(
          snapshot.value as Map,
        );

        print('✅ Loaded user data for module $moduleID: '
            'coins=${moduleData['coins'] ?? 0}, '
            'correct=${moduleData['correctAnswers'] ?? 0}/'
            '${moduleData['totalAnswers'] ?? 0}');

        return {
          'coins': moduleData['coins'] ?? 0,
          'correctAnswers': moduleData['correctAnswers'] ?? 0,
          'totalAnswers': moduleData['totalAnswers'] ?? 0,
        };
      } else {
        print('📝 No existing data for module $moduleID, starting fresh');
        return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      return {'coins': 0, 'correctAnswers': 0, 'totalAnswers': 0};
    }
  }

  /// Update progress for a specific scenario with user feedback
  /// Returns updated coin count
  Future<int> updateScenarioProgress({
    required Scenario scenario,
    required bool isCorrect,
    required Map<String, dynamic> currentUserData,
    String? userFeedback,
    int? userAnswer,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return currentUserData['coins'] ?? 0;

      int globalLevelId = _getGlobalLevelId(levelId, moduleID);

      // Check if this scenario was already answered correctly
      DatabaseReference scenarioRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('scenarios')
          .child(scenario.id.toString());

      DataSnapshot scenarioSnapshot = await scenarioRef.get();

      bool wasAlreadyCorrect = false;
      int currentAttempts = 0;
      Map<String, dynamic> existingData = {};

      if (scenarioSnapshot.exists) {
        existingData = Map<String, dynamic>.from(scenarioSnapshot.value as Map);
        wasAlreadyCorrect = existingData['isCorrect'] ?? false;
        currentAttempts = existingData['attempts'] ?? 0;
      }

      // Calculate coin reward
      int coinsToAdd = _calculateCoinReward(
        isCorrect: isCorrect,
        wasAlreadyCorrect: wasAlreadyCorrect,
        attempts: currentAttempts,
      );

      // Update user stats
      int newTotalAnswers = currentUserData['totalAnswers'] + 1;
      int newCorrectAnswers = currentUserData['correctAnswers'];
      int newCoins = currentUserData['coins'] + coinsToAdd;

      // Only increment correct answers if this is the first correct attempt
      if (isCorrect && !wasAlreadyCorrect) {
        newCorrectAnswers++;
      }

      // Update module progress
      DatabaseReference moduleRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID);

      await moduleRef.update({
        'moduleName': moduleName,
        'coins': newCoins,
        'correctAnswers': newCorrectAnswers,
        'totalAnswers': newTotalAnswers,
        'lastActivity': ServerValue.timestamp,
      });

      // Prepare scenario data - PRESERVE existing feedback if it exists
      Map<String, dynamic> scenarioData = {
        'scenarioId': scenario.id,
        'scenarioTitle': scenario.title,
        'levelId': globalLevelId,
        'uiLevelId': levelId,
        'levelName': levelName,
        'moduleId': moduleID,
        'isCorrect': isCorrect,
        'timestamp': ServerValue.timestamp,
        'attempts': currentAttempts + 1,
        'coinsEarned': coinsToAdd,
      };

      // Add feedback data if provided
      if (userFeedback != null && userFeedback.trim().isNotEmpty && userAnswer != null) {
        scenarioData['feedback'] = {
          'userFeedback': userFeedback.trim(),
          'userAnswer': userAnswer,
          'correctAnswer': scenario.correctAnswer,
          'feedbackTimestamp': ServerValue.timestamp,
          'feedbackLength': userFeedback.trim().length,
        };
      } else if (existingData.containsKey('feedback')) {
        // Preserve existing feedback data
        scenarioData['feedback'] = existingData['feedback'];
      }

      // Update scenario progress using update() instead of set() to be safer
      await scenarioRef.update(scenarioData);

      print('✅ Scenario ${scenario.id} progress updated:');
      print('   Module: $moduleID');
      print('   Path: Progress/${user.uid}/$moduleID/scenarios/${scenario.id}');
      print('   Was already correct: $wasAlreadyCorrect');
      print('   Current attempt: ${currentAttempts + 1}');
      print('   Coins earned: $coinsToAdd');
      print('   Total coins: $newCoins');
      print('   Feedback saved: ${userFeedback?.trim().isNotEmpty ?? false}');
      if (userFeedback?.trim().isNotEmpty == true) {
        print('   Feedback length: ${userFeedback!.trim().length} characters');
      }

      return newCoins;
    } catch (e) {
      print('❌ Error updating scenario progress: $e');
      return currentUserData['coins'] ?? 0;
    }
  }

  /// Save user feedback for a scenario (separate method if needed)
  Future<void> saveScenarioFeedback({
    required Scenario scenario,
    required String userFeedback,
    required int userAnswer,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DatabaseReference scenarioRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('scenarios')
          .child(scenario.id.toString());

      Map<String, dynamic> feedbackData = {
        'userFeedback': userFeedback.trim(),
        'userAnswer': userAnswer,
        'correctAnswer': scenario.correctAnswer,
        'feedbackTimestamp': ServerValue.timestamp,
        'feedbackLength': userFeedback.trim().length,
      };

      await scenarioRef.update({'feedback': feedbackData});
      print('✅ Feedback saved for scenario ${scenario.id}');
      print('   Feedback: "${userFeedback.trim()}"');
    } catch (e) {
      print('❌ Error saving feedback: $e');
    }
  }

  /// Load user feedback for a scenario
  Future<Map<String, dynamic>?> loadScenarioFeedback(Scenario scenario) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DatabaseReference feedbackRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('scenarios')
          .child(scenario.id.toString())
          .child('feedback');

      DataSnapshot snapshot = await feedbackRef.get();

      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }

      return null;
    } catch (e) {
      print('❌ Error loading scenario feedback: $e');
      return null;
    }
  }

  /// Get all user feedback for the module (for analytics/review)
  Future<Map<String, dynamic>> getAllModuleFeedback() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return {};

      DatabaseReference scenariosRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('scenarios');

      DataSnapshot snapshot = await scenariosRef.get();

      if (!snapshot.exists) return {};

      Map<String, dynamic> allFeedback = {};
      Map<String, dynamic> scenariosData = Map<String, dynamic>.from(
        snapshot.value as Map,
      );

      for (var entry in scenariosData.entries) {
        String scenarioId = entry.key;
        Map<String, dynamic> scenarioData = Map<String, dynamic>.from(
          entry.value as Map,
        );

        if (scenarioData.containsKey('feedback')) {
          allFeedback[scenarioId] = scenarioData['feedback'];
        }
      }

      print('✅ Retrieved feedback for ${allFeedback.length} scenarios in module $moduleID');
      return allFeedback;
    } catch (e) {
      print('❌ Error loading module feedback: $e');
      return {};
    }
  }

  /// DEPRECATED - Use updateScenarioProgress with reasoning parameters instead
  @deprecated
  Future<void> saveScenarioReasoning({
    required Scenario scenario,
    required List<int> selectedReasoningIndices,
    required List<String> reasoningOptions,
    required int userAnswer,
  }) async {
    print('⚠️ saveScenarioReasoning is deprecated. Use updateScenarioProgress with feedback parameters or saveScenarioFeedback.');

    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      DatabaseReference scenarioRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('scenarios')
          .child(scenario.id.toString());

      List<String> reasoningTexts = selectedReasoningIndices
          .map((index) => reasoningOptions[index])
          .toList();

      Map<String, dynamic> reasoningData = {
        'selectedReasoningIndices': selectedReasoningIndices,
        'selectedReasoningTexts': reasoningTexts,
        'userAnswer': userAnswer,
        'correctAnswer': scenario.correctAnswer,
        'reasoningTimestamp': ServerValue.timestamp,
      };

      await scenarioRef.update({'reasoning': reasoningData});
      print('✅ Reasoning saved for scenario ${scenario.id}');
    } catch (e) {
      print('❌ Error saving reasoning: $e');
    }
  }

  /// Update level progress
  Future<void> updateLevelProgress({
    required bool isCorrect,
    required int totalScenarios,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return;

      int globalLevelId = _getGlobalLevelId(levelId, moduleID);

      DatabaseReference levelRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('levels')
          .child(levelId.toString()); // Using UI level ID to match your structure

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
        'levelId': globalLevelId,
        'uiLevelId': levelId,
        'levelName': levelName,
        'moduleId': moduleID,
        'correctAnswers': levelCorrectAnswers,
        'totalAnswers': levelTotalAnswers,
        'lastPlayed': ServerValue.timestamp,
        'isCompleted': levelTotalAnswers >= totalScenarios,
        'totalScenarios': totalScenarios,
      });

      print('✅ Level $globalLevelId (UI: $levelId) progress updated in module $moduleID');
    } catch (e) {
      print('❌ Error updating level progress: $e');
    }
  }

  /// Load scenario reasoning data (optional - for backward compatibility)
  Future<Map<String, dynamic>?> loadScenarioReasoning(Scenario scenario) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DatabaseReference reasoningRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('scenarios')
          .child(scenario.id.toString())
          .child('reasoning');

      DataSnapshot snapshot = await reasoningRef.get();

      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }

      return null;
    } catch (e) {
      print('❌ Error loading scenario reasoning: $e');
      return null;
    }
  }

  /// Award level completion bonus
  Future<int> awardLevelCompletionBonus({
    required int stars,
    required int currentCoins,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return currentCoins;

      int globalLevelId = _getGlobalLevelId(levelId, moduleID);

      // Check if level completion bonus was already awarded
      DatabaseReference levelRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID)
          .child('levels')
          .child(levelId.toString()); // Using UI level ID

      DataSnapshot levelSnapshot = await levelRef.get();
      if (levelSnapshot.exists) {
        Map<String, dynamic> levelData = Map<String, dynamic>.from(
          levelSnapshot.value as Map,
        );

        bool bonusAwarded = levelData['completionBonusAwarded'] ?? false;
        if (bonusAwarded) {
          print('🏆 Level completion bonus already awarded for level $levelId');
          return currentCoins;
        }
      }

      int bonusCoins = _calculateCompletionBonus(stars);
      int newTotalCoins = currentCoins + bonusCoins;

      DatabaseReference moduleRef = _database
          .child('Progress')
          .child(user.uid)
          .child(moduleID);

      // Get current module data
      DataSnapshot snapshot = await moduleRef.get();
      Map<String, dynamic> moduleData = {};
      if (snapshot.exists) {
        moduleData = Map<String, dynamic>.from(snapshot.value as Map);
      }

      // Count completed levels in this module
      int completedLevelsCount = _countCompletedLevels(moduleData);
      completedLevelsCount++; // Add current level

      int currentStarsEarned = moduleData['starsEarned'] ?? 0;

      // Update module data
      await moduleRef.update({
        'coins': newTotalCoins,
        'levelsCompleted': completedLevelsCount,
        'starsEarned': currentStarsEarned + stars,
        'lastLevelCompleted': globalLevelId,
        'lastLevelCompletedName': levelName,
        'lastCompletionDate': ServerValue.timestamp,
      });

      // Mark completion bonus as awarded
      await levelRef.update({
        'completionBonusAwarded': true,
        'completionBonusCoins': bonusCoins,
        'starsEarned': stars,
      });

      print('🏆 Level completion bonus awarded:');
      print('   Global Level ID: $globalLevelId');
      print('   UI Level ID: $levelId');
      print('   Module: $moduleID');
      print('   Stars: $stars');
      print('   Bonus Coins: $bonusCoins');
      print('   Total Coins: $newTotalCoins');

      return newTotalCoins;
    } catch (e) {
      print('❌ Error awarding level completion bonus: $e');
      return currentCoins;
    }
  }

  /// Calculate coin reward based on scenario attempt
  int _calculateCoinReward({
    required bool isCorrect,
    required bool wasAlreadyCorrect,
    required int attempts,
  }) {
    if (!isCorrect) {
      return 0; // No coins for wrong answers
    }

    if (wasAlreadyCorrect) {
      return 0; // No additional coins if already answered correctly
    }

    // First correct attempt gets full reward
    if (attempts == 0) {
      return 10;
    }

    // Reduced rewards for subsequent attempts
    switch (attempts) {
      case 1:
        return 7; // Second attempt
      case 2:
        return 5; // Third attempt
      case 3:
        return 3; // Fourth attempt
      default:
        return 1; // Fifth+ attempts get minimal reward
    }
  }

  /// Calculate completion bonus based on stars
  int _calculateCompletionBonus(int stars) {
    switch (stars) {
      case 3:
        return 50;
      case 2:
        return 30;
      case 1:
        return 20;
      default:
        return 10;
    }
  }

  /// Count completed levels in module
  int _countCompletedLevels(Map<String, dynamic> moduleData) {
    int completedLevelsCount = 0;
    Map<String, dynamic> levelsData = moduleData['levels'] ?? {};

    for (var levelEntry in levelsData.entries) {
      Map<String, dynamic> levelInfo = Map<String, dynamic>.from(
        levelEntry.value as Map,
      );
      bool isCompleted = levelInfo['isCompleted'] ?? false;
      if (isCompleted) {
        completedLevelsCount++;
      }
    }

    return completedLevelsCount;
  }

  /// Convert UI level ID to global level ID
  int _getGlobalLevelId(int uiLevelId, String moduleID) {
    switch (moduleID) {
      case 'human_centered_mindset':
        return uiLevelId; // UI 1-3 → Global 1-3
      case 'ai_ethics':
        return uiLevelId + 3; // UI 1-3 → Global 4-6
      case 'ai_foundations_applications':
        return uiLevelId + 6; // UI 1-3 → Global 7-9
      case 'ai_pedagogy':
        return uiLevelId + 9; // UI 1-3 → Global 10-12
      case 'ai_professional_development':
        return uiLevelId + 12; // UI 1-3 → Global 13-15
      default:
        return uiLevelId;
    }
  }

  /// Get coin stream for real-time updates
  Stream<DatabaseEvent> getCoinStream() {
    User? user = _auth.currentUser;
    if (user == null) {
      return Stream.empty();
    }

    return _database
        .child('Progress')
        .child(user.uid)
        .child(moduleID)
        .child('coins')
        .onValue;
  }
}