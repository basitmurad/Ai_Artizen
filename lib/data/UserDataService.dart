

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
    final moduleIds = ['human_centered_mindset', 'ai_ethics', 'ai_foundations_applications','ai_pedagogy','ai_professional_development'];
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