import 'package:flutter/material.dart';
import '../home/ScenarioScreen.dart';
import '../models/LevelData.dart';
import '../json/JsonDataManager.dart';

// Main Level Dialog Widget
class LevelDetailsDialog extends StatelessWidget {
  final LevelData level;
  final VoidCallback? onNavigateToScenario;

  const LevelDetailsDialog({
    Key? key,
    required this.level,
    this.onNavigateToScenario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        level.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LevelDetailsHeader(levelId: level.id),
          SizedBox(height: 8),
          LevelDescription(description: level.scenarioData['description']),
          SizedBox(height: 12),
          if (level.isCompleted) LevelCompletionStatus(level: level),
        ],
      ),
      actions: [
        LevelDialogActions(
          level: level,
          onNavigateToScenario: onNavigateToScenario,
        ),
      ],
    );
  }

  // Static method to show the dialog
  static void show(
      BuildContext context,
      LevelData level, {
        VoidCallback? onNavigateToScenario,
      }) {
    showDialog(
      context: context,
      builder: (context) => LevelDetailsDialog(
        level: level,
        onNavigateToScenario: onNavigateToScenario,
      ),
    );
  }
}

// Level Header Widget
class LevelDetailsHeader extends StatelessWidget {
  final int levelId;

  const LevelDetailsHeader({
    Key? key,
    required this.levelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Level $levelId',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        fontSize: 14,
      ),
    );
  }
}

// Level Description Widget
class LevelDescription extends StatelessWidget {
  final String? description;

  const LevelDescription({
    Key? key,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description ?? 'Scenario content...',
      style: TextStyle(
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}

// Level Completion Status Widget
class LevelCompletionStatus extends StatelessWidget {
  final LevelData level;

  const LevelCompletionStatus({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 4),
          Text(
            '${level.stars}/3 stars earned',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          SizedBox(width: 6),
          Icon(Icons.monetization_on, color: Colors.amber, size: 16),
          SizedBox(width: 4),
          Text(
            '${level.stars * 10} coins',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog Action Buttons Widget
class LevelDialogActions extends StatelessWidget {
  final LevelData level;
  final VoidCallback? onNavigateToScenario;

  const LevelDialogActions({
    Key? key,
    required this.level,
    this.onNavigateToScenario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onNavigateToScenario?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: level.isCompleted ? Colors.blue : Color(0xFFFFD700),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            level.isCompleted ? 'Review' : 'Start',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Level Tap Handler Class
class LevelTapHandler {
  final BuildContext context;
  final Function(Map<String, dynamic>)? onLevelCompleted;

  LevelTapHandler({
    required this.context,
    this.onLevelCompleted,
  });

  // Handle level tap with dialog
  void handleLevelTap(LevelData level) {
    LevelDetailsDialog.show(
      context,
      level,
      onNavigateToScenario: () => _navigateToScenario(level),
    );
  }

  // Navigate to scenario screen
  Future<void> _navigateToScenario(LevelData level) async {
    final result = await ScenarioNavigator.navigate(
      context,
      level: level,
      moduleTitle: JsonDataManager.getModuleTitle(),
    );

    // Handle completion callback
    if (result != null && result['completed'] == true) {
      onLevelCompleted?.call(result);
    }
  }
}

// Scenario Navigator Class
class ScenarioNavigator {
  static Future<Map<String, dynamic>?> navigate(
      BuildContext context, {
        required LevelData level,
        required String moduleTitle,
        Duration transitionDuration = const Duration(milliseconds: 500),
      }) async {
    return await Navigator.push<Map<String, dynamic>>(
      context,
      PageRouteBuilder<Map<String, dynamic>>(
        pageBuilder: (context, animation, secondaryAnimation) => ScenarioScreen(
          level: level,
          moduleTitle: moduleTitle,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          );
        },
        transitionDuration: transitionDuration,
      ),
    );
  }
}

// Alternative: Simple Level Action Handler (if you prefer functional approach)
class LevelActionHandler {
  static void handleLevelTap(
      BuildContext context,
      LevelData level, {
        Function(Map<String, dynamic>)? onLevelCompleted,
      }) {
    final handler = LevelTapHandler(
      context: context,
      onLevelCompleted: onLevelCompleted,
    );
    handler.handleLevelTap(level);
  }

  static Future<void> navigateToScenario(
      BuildContext context,
      LevelData level, {
        Function(Map<String, dynamic>)? onLevelCompleted,
      }) async {
    final result = await ScenarioNavigator.navigate(
      context,
      level: level,
      moduleTitle: JsonDataManager.getModuleTitle(),
    );

    if (result != null && result['completed'] == true) {
      onLevelCompleted?.call(result);
    }
  }
}