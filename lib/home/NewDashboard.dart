import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../data/ModuleDefinition.dart';
import '../data/UserDataService.dart';
import '../json/JsonDataManager1.dart';
import '../json/JsonDataManager3.dart';
import '../json/JsonDataManager4.dart';
import '../json/JsonDataManager2.dart';
import '../json/JsonDataManager5.dart';
import '../models/LevelData.dart';
import '../models/ModuleData.dart';
import '../widgets/AnimatedSphere.dart';
import '../widgets/CustomHeaderWidget.dart';
import '../widgets/LoadingIndicator.dart';
import '../widgets/ModuleHeaderWidget.dart';
import '../widgets/UserBadgesWidget.dart';
import '../widgets/ZigzagModuleWidget.dart';
import 'LeaderboardDashboard.dart';
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
  Map<String, Map<int, Map<String, dynamic>>> _moduleProgress = {};
  Map<String, dynamic> _userProfile = {};
  int _totalCoins = 0;

  final List<ModuleDefinition> _moduleDefinitions = [
    ModuleDefinition(
      id: 'human_centered_mindset',
      title: 'Human-Centered Mindset',
      subtitle: 'Building empathy and understanding in AI implementation',
      color: Color(0xFF4A90E2),
      icon: Icons.favorite,
      jsonManager: 'JsonDataManager1',
      maxLevels: 3,
      isAlwaysUnlocked: true,
    ),
    ModuleDefinition(
      id: 'ai_ethics',
      title: 'AI Ethics',
      subtitle: 'Understanding ethical implications of AI systems',
      color: Color(0xFF9C27B0),
      icon: Icons.balance,
      jsonManager: 'JsonDataManager2',
      maxLevels: 3,
      isAlwaysUnlocked: true,
    ),
    ModuleDefinition(
      id: 'ai_foundations_applications',
      title: 'AI Foundations and Applications',
      subtitle: 'Core concepts and practical applications of artificial intelligence',
      color: Color(0xFFFF6F00),
      icon: Icons.memory,
      jsonManager: 'JsonDataManager3',
      maxLevels: 3,
      isAlwaysUnlocked: true,
    ),
    ModuleDefinition(
      id: 'ai_pedagogy',
      title: 'AI Pedagogy',
      subtitle: 'Integrating AI into teaching and learning methodologies',
      color: Color(0xFFD32F2F),
      icon: Icons.school,
      jsonManager: 'JsonDataManager4',
      maxLevels: 3,
      isAlwaysUnlocked: true,
    ),
    ModuleDefinition(
      id: 'ai_professional_development',
      title: 'AI for Professional Development',
      subtitle: 'Leveraging AI tools for continuous teacher growth and learning',
      color: Color(0xFF2E7D32),
      icon: Icons.trending_up,
      jsonManager: 'JsonDataManager5',
      maxLevels: 3,
      isAlwaysUnlocked: true,
    ),
  ];
  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF4A90E2), size: 30),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'How to Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Level Progression Section
              _buildInstructionSection(
                icon: Icons.trending_up,
                color: Color(0xFF4CAF50),
                title: 'Level Progression',
                description: 'Complete scenarios in each level to unlock the next level within the same module.',
              ),
              SizedBox(height: 16),

              // Module Progression Section
              _buildInstructionSection(
                icon: Icons.lock_open,
                color: Color(0xFFFF9800),
                title: 'Module Unlocking',
                description: 'Complete ALL levels in a module to unlock the next module. Modules must be completed in order.',
              ),
              SizedBox(height: 16),

              // Scoring Section
              _buildInstructionSection(
                icon: Icons.star,
                color: Color(0xFFFFD700),
                title: 'Scoring System',
                description: 'Answer correctly to earn coins and stars. Complete activities when you get answers wrong to learn more!',
              ),
              SizedBox(height: 16),

              // Current Progress Section
              _buildCurrentProgressSection(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it!',
              style: TextStyle(
                color: Color(0xFF4A90E2),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<void> _playGameSound() async {
    try {
      if (_isPlaying) {
        // Stop the sound if it's playing
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        // Play the sound if it's not playing
        await _audioPlayer.play(AssetSource('game.mp3'));
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error playing/stopping sound: $e');
    }
  }// Helper method to build instruction sections
  Widget _buildInstructionSection({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper method to show current progress
  Widget _buildCurrentProgressSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF4A90E2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF4A90E2).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Color(0xFF4A90E2), size: 20),
              SizedBox(width: 8),
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ..._buildProgressSummary(),
        ],
      ),
    );
  }

  List<Widget> _buildProgressSummary() {
    final progressItems = <Widget>[];

    for (final module in _moduleDefinitions) {
      final progress = _moduleProgress[module.id] ?? {};
      int completedLevels = 0;

      for (int level = 1; level <= 3; level++) {
        final levelProgress = progress[level];
        if (levelProgress?['isCompleted'] == true) {
          completedLevels++;
        }
      }

      final isModuleCompleted = completedLevels == 3;
      final isModuleUnlocked = _isPreviousModuleCompleted(module.id);

      progressItems.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Icon(
                isModuleCompleted
                    ? Icons.check_circle
                    : isModuleUnlocked
                    ? Icons.play_circle_outline
                    : Icons.lock,
                color: isModuleCompleted
                    ? Colors.green
                    : isModuleUnlocked
                    ? Colors.orange
                    : Colors.grey,
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${module.title}: $completedLevels/3 levels',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return progressItems;
  }
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchUserData();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
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
    _audioPlayer.dispose();

    super.dispose();
  }
  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);

    try {
      final result = await _userDataService.fetchUserData();

      if (result.isSuccess) {
        setState(() {
          _userProfile = result.profile;
          _totalCoins = result.totalCoins;
          _moduleProgress = _organizeProgressByModule(result.progress);
        });

        // Add debug output
        _debugProgressStatus();

      } else {
        _setDefaultUserData();
      }
    } catch (e) {
      _setDefaultUserData();
    } finally {
      setState(() => _isLoading = false);
      _coinController.forward();
    }
  }
  Map<String, Map<int, Map<String, dynamic>>> _organizeProgressByModule(
      Map<int, Map<String, dynamic>> rawProgress) {
    final organized = <String, Map<int, Map<String, dynamic>>>{};

    for (final module in _moduleDefinitions) {
      organized[module.id] = {};

      for (int level = 1; level <= module.maxLevels; level++) {
        final globalLevelId = _getGlobalLevelId(level, module.id);
        if (rawProgress.containsKey(globalLevelId)) {
          organized[module.id]![level] = rawProgress[globalLevelId]!;
        }
      }
    }

    return organized;
  }

  // Update this function
  String? _determineModuleFromLevelId(int levelId) {
    if (levelId >= 1 && levelId <= 3) return 'human_centered_mindset';
    if (levelId >= 4 && levelId <= 6) return 'ai_ethics';
    if (levelId >= 7 && levelId <= 9) return 'ai_foundations_applications';
    if (levelId >= 10 && levelId <= 12) return 'ai_pedagogy';
    if (levelId >= 13 && levelId <= 15) return 'ai_professional_development';
    return 'unknown_module'; // Add a fallback value
  }

// Update this method
  void _debugLevelCompletion(int globalLevelId) {
    print('\n🔍 === LEVEL COMPLETION DEBUG ===');
    print('Checking global level: $globalLevelId');

    // Find which module this global level belongs to
    final moduleId = _determineModuleFromLevelId(globalLevelId);

    if (moduleId == null) {
      print('   !! Error: Could not determine module for level $globalLevelId');
      print('🔍 === END DEBUG ===\n');
      return;
    }

    final moduleLevelId = _getModuleLevelId(globalLevelId, moduleId);
    print('Module: $moduleId, Module Level: $moduleLevelId');

    // Check progress - handle null case safely
    final moduleProgress = _moduleProgress[moduleId] ?? {};
    final levelProgress = moduleProgress[moduleLevelId];

    print('Level Progress: ${levelProgress ?? "No data"}');

    if (levelProgress != null) {
      print('isCompleted: ${levelProgress['isCompleted']}');
      print('totalAnswers: ${levelProgress['totalAnswers']}');
      print('correctAnswers: ${levelProgress['correctAnswers']}');
      print('totalScenarios: ${levelProgress['totalScenarios']}');
    }

    // Check if next level should be unlocked
    final nextGlobalLevel = globalLevelId + 1;
    final nextModuleId = _determineModuleFromLevelId(nextGlobalLevel);

    if (nextModuleId != null) {
      final nextModuleLevelId = _getModuleLevelId(nextGlobalLevel, nextModuleId);
      final nextModuleProgress = _moduleProgress[nextModuleId] ?? {};
      final isNextUnlocked = _isLevelUnlocked(nextModuleLevelId, nextModuleId, nextModuleProgress);
      print('Is Next Level Unlocked: $isNextUnlocked');
    } else {
      print('   Next level $nextGlobalLevel is beyond the defined modules');
    }

    print('🔍 === END DEBUG ===\n');
  }

  // String? _determineModuleFromLevelId(int levelId) {
  //   if (levelId >= 1 && levelId <= 3) return 'human_centered_mindset';
  //   if (levelId >= 4 && levelId <= 6) return 'ai_ethics';
  //   if (levelId >= 7 && levelId <= 9) return 'ai_foundations_applications';
  //   if (levelId >= 10 && levelId <= 12) return 'ai_pedagogy';
  //   if (levelId >= 13 && levelId <= 15) return 'ai_professional_development';
  //   return null;
  // }

  int _getModuleLevelId(int globalLevelId, String moduleId) {
    // Use module ID from progress data instead of position
    switch (moduleId) {
      case 'human_centered_mindset': return globalLevelId;
      case 'ai_ethics': return globalLevelId - 3;
      case 'ai_foundations_applications': return globalLevelId - 6;
      case 'ai_pedagogy': return globalLevelId - 9;
      case 'ai_professional_development': return globalLevelId - 12;
      default: return globalLevelId;
    }
  }


  void _setDefaultUserData() {
    setState(() {
      _userProfile = {'username': 'User', 'email': '', 'avatar': ''};
      _moduleProgress = _moduleDefinitions.fold({},
              (map, module) => map..[module.id] = {});
      _totalCoins = 0;
    });
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
            colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF6A5ACD)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomHeaderWidget(
                userInitials: _getUserInitials(),
                userDisplayName: _getUserDisplayName(),
                coinController: _coinController,
                totalCoins: _totalCoins,
                onLeaderboardTap: _navigateToLeaderboard,
                onRefreshTap: _handleRefresh,
              ),

              // _buildHeader(),
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


  void _navigateToLeaderboard() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardDashboard()));
  }

  String _getUserDisplayName() => _userProfile['username']?.isNotEmpty == true
      ? _userProfile['username']
      : 'User';

  String _getUserInitials() {
    final name = _getUserDisplayName();
    if (name == 'User') return 'U';
    final parts = name.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : parts[0][0].toUpperCase();
  }

  Widget _buildGamePath() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFloatingMascot(),
                SizedBox(height: 25),

                Text(
                  "🚀 Start Your AI Learning Journey",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12),

                Text(
                  "Need guidance? Tap below to see how to unlock levels and progress!",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _showInstructionsDialog,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                    ),

                    SizedBox(width: 20),

                    // Update the sound button in your widget
                    GestureDetector(
                      onTap: _playGameSound,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.stop : Icons.volume_up,
                          color: Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ..._buildAllModules(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Widget _buildGamePath() {
  //   return SingleChildScrollView(
  //     physics: BouncingScrollPhysics(),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //       child: Column(
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               _buildFloatingMascot(),
  //               SizedBox(height: 25),
  //
  //               Text(
  //                 "🚀 Start Your AI Learning Journey",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //
  //               SizedBox(height: 12),
  //
  //               Text(
  //                 "Need guidance? Tap below to see how to unlock levels and progress!",
  //                 style: TextStyle(
  //                   color: Colors.white.withOpacity(0.8),
  //                   fontSize: 14,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //
  //               SizedBox(height: 20),
  //
  //               GestureDetector(
  //                 onTap: _showInstructionsDialog,
  //                 child: Container(
  //                   padding: EdgeInsets.all(16),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     shape: BoxShape.circle,
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.2),
  //                         blurRadius: 12,
  //                         offset: Offset(0, 6),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Icon(
  //                     Icons.help_outline,
  //                     color: Color(0xFF4A90E2),
  //                     size: 28,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //           ..._buildAllModules(),
  //           SizedBox(height: 100),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFloatingMascot() {
    return AnimatedSphere(
      size: 80,
      primaryColor: Color(0xFF4A90E2),
      secondaryColor: Color(0xFF7B68EE),
      child: Icon(Icons.psychology, size: 40, color: Colors.white),
    );
  }

  List<Widget> _buildAllModules() {
    return _moduleDefinitions.asMap().entries.map((entry) {
      final i = entry.key;
      final module = entry.value;
      return AnimatedBuilder(
        animation: _pathController,
        builder: (context, _) {
          final delay = 0.2 + (i * 0.3);
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: _pathController,
              curve: Interval(delay.clamp(0.0, 0.8), (delay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOut),
            )),
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(
                parent: _pathController,
                curve: Interval(delay.clamp(0.0, 0.8), (delay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOut),
              )),
              child: _buildModule(module),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildModule(ModuleDefinition moduleDefinition) {
    final moduleData = _generateModuleData(moduleDefinition);
    _debugLevelStatus(moduleDefinition.id, 1); // Level 1
    _debugLevelStatus(moduleDefinition.id, 2); // Level 2
    _debugLevelStatus(moduleDefinition.id, 3); // Level 3
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
    );
  }

  Widget _buildUserBadges(ModuleDefinition moduleDefinition) {
    return UserBadgesWidget(
      userProgress: _moduleProgress[moduleDefinition.id] ?? {},
      title: 'Module Achievements',
      maxLevels: moduleDefinition.maxLevels,
      showEmptyState: true,
      emptyStateText: 'Complete levels to earn badges!',
    );
  }

  Widget _buildZigzagModule(List<LevelData> levels, ModuleDefinition moduleDefinition) {
    return ZigzagModuleWidget(
      levels: levels.map((level) => ZigzagLevelData(
        id: level.id,
        title: level.title,
        isCompleted: level.isCompleted,
        isUnlocked: level.isUnlocked,
        stars: level.stars,
        data: level.scenarioData,
      )).toList(),
      onLevelTap: (zigzagLevel) {
        final level = levels.firstWhere((l) => l.id == zigzagLevel.id);
        _onLevelTap(level, moduleDefinition);
      },
      showConnectors: true,
      levelSize: 70,
      pathColor: Colors.white,
    );
  }

  Widget _buildModuleBadge(ModuleData module, ModuleDefinition moduleDefinition) {
    final isCompleted = module.levels.every((level) => level.isCompleted);
    final isUnlocked = _isPreviousModuleCompleted(moduleDefinition.id);

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: isCompleted ? () => _onBadgeTap(module, moduleDefinition) : null,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isCompleted
                ? moduleDefinition.color
                : isUnlocked
                ? Colors.grey[400]
                : Colors.grey[600],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [BoxShadow(
              color: (isCompleted ? moduleDefinition.color : Colors.grey[400]!).withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            )],
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.military_tech, color: Colors.white, size: 35)
                : isUnlocked
                ? Icon(Icons.play_arrow, color: Colors.grey[600], size: 30)
                : Icon(Icons.lock, color: Colors.grey[600], size: 30),
          ),
        ),
      ),
    );
  }

// Debug method to print current progress status
  void _debugProgressStatus() {
    print('\n🔍 === PROGRESS DEBUG ===');
    for (final module in _moduleDefinitions) {
      final progress = _moduleProgress[module.id] ?? {};
      print('📊 Module: ${module.id}');
      for (int level = 1; level <= 3; level++) {
        final levelProgress = progress[level];
        final globalLevel = _getGlobalLevelId(level, module.id);
        final isCompleted = levelProgress?['isCompleted'] ?? false;
        final isUnlocked = _isLevelUnlocked(level, module.id, progress);
        print('   Level $level (Global: $globalLevel) - Completed: $isCompleted, Unlocked: $isUnlocked');
      }
      final moduleCompleted = _isPreviousModuleCompleted(module.id);
      print('   Module Unlocked: $moduleCompleted');
      print('   ---');
    }
    print('🔍 === END DEBUG ===\n');
  }

  ModuleData _generateModuleData(ModuleDefinition moduleDefinition) {
    if (moduleDefinition.jsonManager == null) {
      return _generatePlaceholderModule(moduleDefinition);
    }

    try {
      return _generateModuleFromJson(moduleDefinition);
    } catch (e) {
      return _generatePlaceholderModule(moduleDefinition);
    }
  }
  ModuleData _generateModuleFromJson(ModuleDefinition moduleDefinition) {
    dynamic educationModule;
    switch (moduleDefinition.jsonManager) {
      case 'JsonDataManager1': educationModule = JsonDataManager1.getModule(); break;
      case 'JsonDataManager2': educationModule = JsonDataManager2.getModule(); break;
      case 'JsonDataManager3': educationModule = JsonDataManager3.getModule(); break;
      case 'JsonDataManager4': educationModule = JsonDataManager4.getModule(); break;
      case 'JsonDataManager5': educationModule = JsonDataManager5.getModule(); break;
      default: throw Exception('Unknown JSON manager');
    }

    final moduleProgress = _moduleProgress[moduleDefinition.id] ?? {};
    final levels = <LevelData>[];

    for (int i = 0; i < educationModule.levels.length && i < moduleDefinition.maxLevels; i++) {
      final level = educationModule.levels[i];
      final levelId = i + 1; // UI level ID (1-3)
      final levelProgress = moduleProgress[levelId];

      // Check completion status - look for global level completion in Firebase
      final globalLevelId = _getGlobalLevelId(levelId, moduleDefinition.id);
      final isCompleted = _isLevelCompleted(globalLevelId, levelProgress);

      levels.add(LevelData(
        id: levelId,
        title: _formatLevelTitle(level.level),
        isCompleted: isCompleted,
        isUnlocked: _isLevelUnlocked(levelId, moduleDefinition.id, moduleProgress),
        stars: _calculateStars(levelProgress),
        scenarioData: {
          'id': levelId,
          'moduleId': moduleDefinition.id,
          'levelName': level.level,
          'levelType': level.levelType,
          'scenarios': level.scenarios.map((s) => s.toJson()).toList(),
        },
      ));
    }

    return ModuleData(title: educationModule.moduleName, levels: levels);
  }

  // void _debugLevelCompletion(int globalLevelId) {
  //   print('\n🔍 === LEVEL COMPLETION DEBUG ===');
  //   print('Checking global level: $globalLevelId');
  //
  //   // Find which module this global level belongs to
  //   final moduleId = _determineModuleFromLevelId(globalLevelId);
  //   final moduleLevelId = _getModuleLevelId(globalLevelId, moduleId!);
  //
  //   print('Module: $moduleId, Module Level: $moduleLevelId');
  //
  //   // Check progress
  //   final moduleProgress = _moduleProgress[moduleId] ?? {};
  //   final levelProgress = moduleProgress[moduleLevelId];
  //
  //   print('Level Progress: $levelProgress');
  //
  //   if (levelProgress != null) {
  //     print('isCompleted: ${levelProgress['isCompleted']}');
  //     print('totalAnswers: ${levelProgress['totalAnswers']}');
  //     print('correctAnswers: ${levelProgress['correctAnswers']}');
  //     print('totalScenarios: ${levelProgress['totalScenarios']}');
  //   }
  //
  //   // Check if next level should be unlocked
  //   final nextGlobalLevel = globalLevelId + 1;
  //   final nextModuleId = _determineModuleFromLevelId(nextGlobalLevel);
  //   final nextModuleLevelId = _getModuleLevelId(nextGlobalLevel, nextModuleId!);
  //
  //   print('\nNext Level Check:');
  //   print('Next Global Level: $nextGlobalLevel');
  //   print('Next Module: $nextModuleId, Next Module Level: $nextModuleLevelId');
  //
  //   final nextModuleProgress = _moduleProgress[nextModuleId] ?? {};
  //   final isNextUnlocked = _isLevelUnlocked(nextModuleLevelId, nextModuleId, nextModuleProgress);
  //
  //   print('Is Next Level Unlocked: $isNextUnlocked');
  //   print('🔍 === END DEBUG ===\n');
  // }
  bool _isLevelCompleted(int globalLevelId, Map<String, dynamic>? levelProgress) {
    if (levelProgress == null) return false;

    // 1. Check explicit completion flag
    if (levelProgress['isCompleted'] == true) return true;

    // 2. Check scenario completion stats
    final totalAnswers = levelProgress['totalAnswers'] ?? 0;
    final totalScenarios = levelProgress['totalScenarios'] ?? 5;

    return totalAnswers >= totalScenarios;
  }

  int _calculateStars(Map<String, dynamic>? levelProgress) {
    if (levelProgress == null) return 0;
    if (!_isLevelCompleted(0, levelProgress)) return 0; // Use 0 as placeholder for global ID

    final correct = levelProgress['correctAnswers'] ?? 0;
    final total = levelProgress['totalAnswers'] ?? 1;

    if (total == 0) return 0;

    final ratio = correct / total;

    if (ratio >= 0.9) return 3;
    if (ratio >= 0.7) return 2;
    if (ratio >= 0.5) return 1;
    return 0;
  }
  bool _isLevelUnlocked(int levelId, String moduleId, Map<int, Map<String, dynamic>> progress) {
    // First module level 1 always unlocked
    if (moduleId == 'human_centered_mindset' && levelId == 1) return true;

    // Level 1 unlocked if previous module completed
    if (levelId == 1) return _isPreviousModuleCompleted(moduleId);

    // Higher levels unlocked if previous level completed
    final previousLevelId = levelId - 1;
    final previousLevelProgress = progress[previousLevelId];

    // Get global ID for proper completion check
    final previousGlobalLevelId = _getGlobalLevelId(previousLevelId, moduleId);

    return _isLevelCompleted(previousGlobalLevelId, previousLevelProgress);
  }
  void _debugLevelStatus(String moduleId, int levelId) {
    final progress = _moduleProgress[moduleId] ?? {};
    final levelProgress = progress[levelId];
    final globalId = _getGlobalLevelId(levelId, moduleId);

    print('🔓 Module: $moduleId Level: $levelId (Global: $globalId)');
    print('   isCompleted: ${levelProgress?['isCompleted'] ?? false}');
    print('   totalAnswers: ${levelProgress?['totalAnswers'] ?? 0}');
    print('   totalScenarios: ${levelProgress?['totalScenarios'] ?? 5}');
    print('   Unlocked: ${_isLevelUnlocked(levelId, moduleId, progress)}');
  }
  bool _isPreviousModuleCompleted(String currentModuleId) {
    final moduleOrder = [
      'human_centered_mindset',
      'ai_ethics',
      'ai_foundations_applications',
      'ai_pedagogy',
      'ai_professional_development'
    ];

    final currentIndex = moduleOrder.indexOf(currentModuleId);
    if (currentIndex <= 0) return true; // First module is always available

    final previousModuleId = moduleOrder[currentIndex - 1];
    final previousModuleProgress = _moduleProgress[previousModuleId] ?? {};

    // Check if all levels in previous module are completed
    for (int level = 1; level <= 3; level++) {
      final levelProgress = previousModuleProgress[level];
      if (levelProgress?['isCompleted'] != true) {
        return false;
      }
    }
    return true;
  }


  ModuleData _generatePlaceholderModule(ModuleDefinition moduleDefinition) {
    final types = ['Acquire', 'Deepen', 'Create'];
    final progress = _moduleProgress[moduleDefinition.id] ?? {};

    return ModuleData(
      title: moduleDefinition.title,
      levels: List.generate(moduleDefinition.maxLevels, (i) {
        final levelId = i + 1;
        final levelProgress = progress[levelId];

        return LevelData(
          id: levelId,
          title: '${levelId}. ${types[i % types.length]}',
          isCompleted: levelProgress?['isCompleted'] ?? false,
          isUnlocked: _isLevelUnlocked(levelId, moduleDefinition.id, progress),
          stars: _calculateStars(levelProgress),
          scenarioData: {
            'id': levelId,
            'moduleId': moduleDefinition.id,
            'levelName': 'Level $levelId',
            'levelType': types[i % types.length],
            'scenarios': [],
          },
        );
      }),
    );
  }

  String _formatLevelTitle(String title) {
    final match = RegExp(r'Level (\d+) \((.+)\)').firstMatch(title);
    return match != null ? '${match.group(1)}. ${match.group(2)}' : title;
  }

  int _getGlobalLevelId(int moduleLevelId, String moduleId) {
    final moduleIndex = _moduleDefinitions.indexWhere((m) => m.id == moduleId);
    return (moduleIndex * 3) + moduleLevelId;
  }

  void _onLevelTap(LevelData level, ModuleDefinition moduleDefinition) {
    final globalLevelId = _getGlobalLevelId(level.id, moduleDefinition.id);
    _debugLevelCompletion(globalLevelId);
    try {
      dynamic educationModule;
      switch (moduleDefinition.jsonManager) {
        case 'JsonDataManager1':
          educationModule = JsonDataManager1.getModule();
          break;
        case 'JsonDataManager2':
          educationModule = JsonDataManager2.getModule();
          break;
        case 'JsonDataManager3':
          educationModule = JsonDataManager3.getModule();
          break;
        case 'JsonDataManager4':
          educationModule = JsonDataManager4.getModule();
          break;
        case 'JsonDataManager5':
          educationModule = JsonDataManager5.getModule();
          break;
        default:
          throw Exception('Unknown JSON manager');
      }

      // Check if the level exists in the module
      if (level.id <= educationModule.levels.length) {

        print("Id is  ${level.id}" );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LevelScenariosScreen(
              levelId: level.id, // Always use global level ID
              levelName: level.title,
              moduleID: moduleDefinition.id,
            ),
          ),
        );
        return;
      }
    } catch (e) {
      print('Error navigating to level: $e'); // Add debugging
    }

    _showComingSoonDialog(moduleDefinition.title, level.title);
  }

  void _showComingSoonDialog(String module, String level) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.construction, color: Color(0xFF9C27B0), size: 30),
          SizedBox(width: 10),
          Text('Coming Soon!'),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$module - $level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text('This level is currently under development. Stay tuned!', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it!', style: TextStyle(color: Color(0xFF9C27B0))),
          ),
        ],
      ),
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
}

