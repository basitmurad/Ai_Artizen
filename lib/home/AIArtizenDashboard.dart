
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../data/UserDataService.dart';
import '../json/JsonDataManager.dart';
import '../models/LevelData.dart';
import '../models/ModuleData.dart';
import '../widgets/DashboardHeader.dart';
import '../widgets/LevelDetailsDialog.dart';
import '../widgets/LoadingIndicator.dart';

class AIArtizenDashboard extends StatefulWidget {
  const AIArtizenDashboard({super.key});

  @override
  _AIArtizenDashboardState createState() => _AIArtizenDashboardState();
}

class _AIArtizenDashboardState extends State<AIArtizenDashboard>
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

  // Level tap handler
  late LevelTapHandler _levelTapHandler;

  // Module definitions
  final List<Map<String, dynamic>> _moduleDefinitions = [
    {
      'id': 1,
      'title': 'Human-Centered Mindset',
      'subtitle': 'Building empathy and understanding in AI implementation',
      'color': Color(0xFF4A90E2),
      'icon': Icons.favorite,
    },
    {
      'id': 2,
      'title': 'AI Ethics',
      'subtitle': 'Responsible AI practices and ethical considerations',
      'color': Color(0xFF7B68EE),
      'icon': Icons.balance,
    },
    {
      'id': 3,
      'title': 'AI Foundations and Applications',
      'subtitle': 'Core concepts and practical implementations',
      'color': Color(0xFF50C878),
      'icon': Icons.settings,
    },
    {
      'id': 4,
      'title': 'AI Pedagogy',
      'subtitle': 'Teaching and learning with AI technologies',
      'color': Color(0xFFFF6B6B),
      'icon': Icons.school,
    },
    {
      'id': 5,
      'title': 'AI for Professional Development',
      'subtitle': 'Advancing careers through AI competency',
      'color': Color(0xFFFFD93D),
      'icon': Icons.trending_up,
    },
  ];

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
    _levelTapHandler = LevelTapHandler(
      context: context,
      onLevelCompleted: _handleLevelCompleted,
    );
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
            ..._buildAllModules(),
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

  List<Widget> _buildAllModules() {
    List<Widget> moduleWidgets = [];

    for (int moduleIndex = 0; moduleIndex < _moduleDefinitions.length; moduleIndex++) {
      final moduleDefinition = _moduleDefinitions[moduleIndex];
      final moduleData = _generateModuleData(moduleDefinition, moduleIndex);

      moduleWidgets.add(_buildModule(moduleData, moduleIndex));

      // Add spacing between modules
      if (moduleIndex < _moduleDefinitions.length - 1) {
        moduleWidgets.add(SizedBox(height: 40));
      }
    }

    return moduleWidgets;
  }

  Widget _buildModule(ModuleData module, int moduleIndex) {
    return AnimatedBuilder(
      animation: _pathController,
      builder: (context, child) {
        double moduleDelay = (moduleIndex * 0.2).clamp(0.0, 0.8);

        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _pathController,
              curve: Interval(
                moduleDelay,
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
                  moduleDelay,
                  (moduleDelay + 0.4).clamp(0.0, 1.0),
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildModuleHeader(module),
                _buildZigzagModule(module.levels, moduleIndex),
                _buildModuleBadge(module),
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

    // Find module definition for colors and icon
    final moduleDefinition = _moduleDefinitions.firstWhere(
          (def) => def['title'] == module.title,
      orElse: () => _moduleDefinitions[0],
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: moduleDefinition['color'].withOpacity(0.2),
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
                  color: moduleDefinition['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  moduleDefinition['icon'],
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
                      moduleDefinition['subtitle'],
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

  Widget _buildZigzagModule(List<LevelData> levels, int moduleIndex) {
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
            double baseModuleDelay = (moduleIndex * 0.2).clamp(0.0, 0.8);
            double levelDelay = baseModuleDelay + 0.1 + (levelIndex / totalLevels) * 0.4;
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
          if (level.isCompleted || level.isUnlocked) _buildStarsDisplay(level),
          if (level.isCompleted || level.isUnlocked) SizedBox(height: 4),
          if (level.isCompleted || level.isUnlocked) _buildLevelTitle(level),
        ],
      ),
    );
  }

  Widget _buildModuleBadge(ModuleData module) {
    bool isModuleCompleted = module.levels.every((level) => level.isCompleted);

    // Find module definition for colors
    final moduleDefinition = _moduleDefinitions.firstWhere(
          (def) => def['title'] == module.title,
      orElse: () => _moduleDefinitions[0],
    );

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: isModuleCompleted ? () => _onBadgeTap(module) : null,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isModuleCompleted
                ? moduleDefinition['color']
                : Colors.grey[400],
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: (isModuleCompleted
                    ? moduleDefinition['color']
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

  Widget _buildStarsDisplay(LevelData level) {
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
          bool isStarEarned = index < level.stars;
          return Icon(
            isStarEarned ? Icons.star : Icons.star_border,
            color: isStarEarned ? Colors.yellow : Colors.white.withOpacity(0.5),
            size: 16,
          );
        }),
      ),
    );
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
    _levelTapHandler.handleLevelTap(level);
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

  ModuleData _generateModuleData(Map<String, dynamic> moduleDefinition, int moduleIndex) {
    // For the first module, use actual JSON data
    if (moduleIndex == 0) {
      return _generateSingleModule();
    }

    // For other modules, generate sample data
    List<LevelData> levels = [];
    int moduleId = moduleDefinition['id'];

    for (int i = 1; i <= 5; i++) {
      int levelId = (moduleId - 1) * 5 + i; // Unique level IDs across modules

      // Check if user has progress for this level
      Map<String, dynamic>? levelProgress = _userProgress[levelId];
      bool isCompleted = levelProgress?['completed'] ?? false;

      // First level of first module is always unlocked
      // Other levels unlock when previous level is completed
      bool isUnlocked = false;
      if (moduleIndex == 0 && i == 1) {
        isUnlocked = true;
      } else if (i == 1) {
        // First level of other modules unlocks when previous module is completed
        int previousModuleLastLevel = ((moduleId - 2) * 5) + 5;
        Map<String, dynamic>? prevProgress = _userProgress[previousModuleLastLevel];
        isUnlocked = prevProgress?['completed'] ?? false;
      } else {
        // Other levels unlock when previous level is completed
        Map<String, dynamic>? previousLevelProgress = _userProgress[levelId - 1];
        isUnlocked = previousLevelProgress?['completed'] ?? false;
      }

      int stars = 0;
      if (isCompleted && levelProgress != null) {
        stars = (levelProgress['score'] ?? 0).clamp(0, 3);
      }

      levels.add(
        LevelData(
          id: levelId,
          title: 'Level $i',
          isCompleted: isCompleted,
          isUnlocked: isUnlocked,
          stars: stars,
          scenarioData: {
            'id': levelId,
            'title': '${moduleDefinition['title']} - Level $i',
            'description': 'Level $i of ${moduleDefinition['title']} module',
          },
        ),
      );
    }

    return ModuleData(
      title: moduleDefinition['title'],
      levels: levels,
    );
  }

  ModuleData _generateSingleModule() {
    List<dynamic> scenarios = JsonDataManager.getScenarios();
    String moduleTitle = JsonDataManager.getModuleTitle();

    List<LevelData> levels = [];

    for (int i = 0; i < scenarios.length; i++) {
      var scenario = scenarios[i];
      int levelId = scenario['id'];

      Map<String, dynamic>? levelProgress = _userProgress[levelId];

      bool isCompleted = levelProgress?['completed'] ?? false;

      bool isUnlocked = levelId == 1;
      if (levelId > 1) {
        Map<String, dynamic>? previousLevelProgress = _userProgress[levelId - 1];
        isUnlocked = previousLevelProgress?['completed'] ?? false;
      }

      int stars = 0;
      if (isCompleted && levelProgress != null) {
        stars = (levelProgress['score'] ?? 0).clamp(0, 3);
      }

      print('🔧 Level $levelId: completed=$isCompleted, unlocked=$isUnlocked, stars=$stars');

      levels.add(
        LevelData(
          id: levelId,
          title: scenario['title'],
          isCompleted: isCompleted,
          isUnlocked: isUnlocked,
          stars: stars,
          scenarioData: scenario,
        ),
      );
    }

    return ModuleData(title: moduleTitle, levels: levels);
  }
}