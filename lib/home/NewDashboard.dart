
import 'dart:math' as math;
import 'package:artizen/json/JsonDataManagerEthics.dart';
import 'package:flutter/material.dart';

import '../data/ModuleDefinition.dart';
import '../data/UserDataService.dart';
import '../json/JsonDataManager2.dart';
import '../json/JsonDataManager.dart';
import '../json/JsonDataManager4.dart';
import '../json/JsonDataManager5.dart';
import '../json/JsonDataManager6.dart';
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
// Replace your _moduleDefinitions with this corrected version:

  final List<ModuleDefinition> _moduleDefinitions = [
    // ✅ Module 1: Human-Centered Mindset
    ModuleDefinition(
      id: 'human_centered_mindset',
      title: 'Human-Centered Mindset',
      subtitle: 'Building empathy and understanding in AI implementation',
      color: Color(0xFF4A90E2),
      icon: Icons.favorite,
      jsonManager: 'JsonDataManager2', // ✅ Correct
      maxLevels: 3,
      isAlwaysUnlocked: true,
    ),

    // ✅ Module 2: AI Ethics (FIXED)
    ModuleDefinition(
      id: 'ai_ethics',
      title: 'AI Ethics',
      subtitle: 'Understanding ethical implications of AI systems',
      color: Color(0xFF9C27B0), // ✅ Different color
      icon: Icons.balance, // ✅ Different icon
      jsonManager: 'JsonDataManager5', // ✅ FIXED: Should be JsonDataManager5
      maxLevels: 3,
      isAlwaysUnlocked: true,
    ),

    // ✅ Module 3: AI Pedagogy
    ModuleDefinition(
      id: 'ai_pedagogy',
      title: 'AI Pedagogy',
      subtitle: 'Integrating AI into teaching and learning methodologies',
      color: Color(0xFFD32F2F),
      icon: Icons.school,
      jsonManager: 'JsonDataManager4', // ✅ Correct
      maxLevels: 2,
      isAlwaysUnlocked: true,
    ),
    ModuleDefinition(
      id: 'ai_professional_development',
      title: 'AI for Professional Development',
      subtitle: 'Leveraging AI tools for continuous teacher growth and learning',
      color: Color(0xFF2E7D32), // Green color for growth/development theme
      icon: Icons.trending_up, // Growth/development icon
      jsonManager: 'JsonDataManager6', // ✅ Uses the new JsonDataManager6
      maxLevels: 3,
      isAlwaysUnlocked: true,
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
      for (var moduleDef in _moduleDefinitions) {
        _moduleProgress[moduleDef.id] = {};
      }      _totalCoins = 0;
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
  /// Generate module from JSON data with enhanced validation
  /// Generate module from JSON data - Clean production version
  ModuleData _generateModuleFromJson(ModuleDefinition moduleDefinition) {
    try {
      dynamic educationModule;

      // Load the appropriate JSON manager
      switch (moduleDefinition.jsonManager) {
        case 'JsonDataManager2':
          educationModule = JsonDataManager2.getModule();
          break;

        case 'JsonDataManager4':
          educationModule = JsonDataManager4.getModule();
          break;
        case 'JsonDataManager5':
          educationModule = JsonDataManager5.getModule();
          break;
        case 'JsonDataManager6':
          educationModule = JsonDataManager6.getModule();
          break;
        default:
          throw Exception('Unknown JSON manager: ${moduleDefinition.jsonManager}');
      }

      if (educationModule == null) {
        throw Exception('Education module is null for ${moduleDefinition.jsonManager}');
      }

      List<LevelData> levelDataList = [];
      var moduleProgress = _moduleProgress[moduleDefinition.id] ?? {};

      for (int levelIndex = 0; levelIndex < educationModule.levels.length && levelIndex < moduleDefinition.maxLevels; levelIndex++) {
        final level = educationModule.levels[levelIndex];
        int levelId = levelIndex + 1;

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

        levelDataList.add(
          LevelData(
            id: levelId,
            title: displayTitle,
            isCompleted: isCompleted,
            isUnlocked: isUnlocked,
            stars: stars,
            scenarioData: {
              'id': levelId,
              'moduleId': moduleDefinition.id,
              'levelName': level.level,
              'levelType': level.levelType,
              'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
              'totalScenarios': level.scenarios.length,
            },
          ),
        );
      }

      return ModuleData(
        title: educationModule.moduleName,
        levels: levelDataList,
      );

    } catch (e) {
      print('❌ Error generating module ${moduleDefinition.id} from JSON: $e');
      return _generatePlaceholderModule(moduleDefinition);
    }
  }  /// Generate module from JSON data

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
    print('JSON Manager: ${moduleDefinition.jsonManager}');

    if (moduleDefinition.jsonManager != null) {
      try {
        dynamic educationModule;

        if (moduleDefinition.jsonManager == 'JsonDataManager2') {
          educationModule = JsonDataManager2.getModule();
          print("JsonDataManager2 returned: ${educationModule?.moduleName}");
        } else if (moduleDefinition.jsonManager == 'JsonDataManager4') {
          educationModule = JsonDataManager4.getModule();
          print("JsonDataManager4 returned: ${educationModule?.moduleName}");
        }
        else if (moduleDefinition.jsonManager == 'JsonDataManager6') {
          educationModule = JsonDataManager6.getModule();
          print("JsonDataManager6 returned: ${educationModule?.moduleName}");
        }
        else if (moduleDefinition.jsonManager == 'JsonDataManager5') {
          educationModule = JsonDataManager5.getModule();
          print("JsonDataManager5 returned: ${educationModule?.moduleName}");
        }
        else {
          throw Exception('Unknown JSON manager: ${moduleDefinition.jsonManager}');
        }

        print('📚 Education module loaded: ${educationModule != null}');
        print('📚 Looking for level ID: ${level.id}');

        final currentLevel = educationModule.getLevelByNumber(level.id);

        print('📚 Current level found: ${currentLevel != null}');

        if (currentLevel != null) {
          print('✅ Level found - should navigate  ${level.id}  ${level.title} ${moduleDefinition.id}');

          // ✅ UNCOMMENT THIS - Your dashboard is passing correct data!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LevelScenariosScreen(
                levelId: level.id,
                levelName: level.title,
                moduleID: moduleDefinition.id,  // ✅ This is correct!
              ),
            ),
          );
        } else {
          print('❌ Level not found - showing dialog');
          _showComingSoonDialog(moduleDefinition.title, level.title);
        }
      } catch (e) {
        print('❌ Exception caught: $e');
        _showComingSoonDialog(moduleDefinition.title, level.title);
      }
    } else {
      print('❌ No JSON manager - showing dialog');
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
