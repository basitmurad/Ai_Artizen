// activity_card.dart
import 'dart:convert';

class ActivityCard {
  final String statement;
  final String correct;
  final String feedback;

  ActivityCard({
    required this.statement,
    required this.correct,
    required this.feedback,
  });

  factory ActivityCard.fromJson(Map<String, dynamic> json) {
    return ActivityCard(
      statement: json['statement'] ?? '',
      correct: json['correct'] ?? '',
      feedback: json['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statement': statement,
      'correct': correct,
      'feedback': feedback,
    };
  }

  @override
  String toString() {
    return 'ActivityCard(statement: $statement, correct: $correct, feedback: $feedback)';
  }
}

// activity.dart
class Activity {
  final String type;
  final String name;
  final List<ActivityCard> cards;
  final String completionMessage;

  Activity({
    required this.type,
    required this.name,
    required this.cards,
    required this.completionMessage,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      cards: (json['cards'] as List<dynamic>?)
          ?.map((cardJson) => ActivityCard.fromJson(cardJson))
          .toList() ?? [],
      completionMessage: json['completionMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'cards': cards.map((card) => card.toJson()).toList(),
      'completionMessage': completionMessage,
    };
  }

  @override
  String toString() {
    return 'Activity(type: $type, name: $name, cards: ${cards.length}, completionMessage: $completionMessage)';
  }
}

// scenario.dart
class Scenario {
  final int id;
  final String title;
  final String description;
  final String? question; // Optional, some scenarios have this
  final List<String> options;
  final int correctAnswer;
  final String feedback;
  final Activity activity;

  Scenario({
    required this.id,
    required this.title,
    required this.description,
    this.question,
    required this.options,
    required this.correctAnswer,
    required this.feedback,
    required this.activity,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      question: json['question'], // Can be null
      options: (json['options'] as List<dynamic>?)
          ?.map((option) => option.toString())
          .toList() ?? [],
      correctAnswer: json['correctAnswer'] ?? 1,
      feedback: json['feedback'] ?? '',
      activity: Activity.fromJson(json['activity'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'title': title,
      'description': description,
      'options': options,
      'correctAnswer': correctAnswer,
      'feedback': feedback,
      'activity': activity.toJson(),
    };

    // Only add question if it's not null
    if (question != null) {
      json['question'] = question;
    }

    return json;
  }

  // Helper method to get the question text (either question or description)
  String get questionText => question ?? description;

  // Helper method to check if user's answer is correct
  bool isCorrectAnswer(int userAnswer) => userAnswer == correctAnswer;

  // Helper method to get correct option text
  String get correctOptionText {
    if (correctAnswer > 0 && correctAnswer <= options.length) {
      return options[correctAnswer - 1]; // correctAnswer is 1-based
    }
    return '';
  }

  @override
  String toString() {
    return 'Scenario(id: $id, title: $title, options: ${options.length}, correctAnswer: $correctAnswer)';
  }
}

// level.dart
class Level {
  final String level;
  final List<Scenario> scenarios;

  Level({
    required this.level,
    required this.scenarios,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      level: json['level'] ?? '',
      scenarios: (json['scenarios'] as List<dynamic>?)
          ?.map((scenarioJson) => Scenario.fromJson(scenarioJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'scenarios': scenarios.map((scenario) => scenario.toJson()).toList(),
    };
  }

  // Helper methods
  String get levelName => level;

  int get scenarioCount => scenarios.length;

  // Get scenario by ID
  Scenario? getScenarioById(int id) {
    try {
      return scenarios.firstWhere((scenario) => scenario.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get level number (extract number from level string)
  int get levelNumber {
    final match = RegExp(r'Level (\d+)').firstMatch(level);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  // Get level type (Acquire, Deepen, Create)
  String get levelType {
    if (level.contains('Acquire')) return 'Acquire';
    if (level.contains('Deepen')) return 'Deepen';
    if (level.contains('Create')) return 'Create';
    return 'Unknown';
  }

  @override
  String toString() {
    return 'Level(level: $level, scenarios: ${scenarios.length})';
  }
}

// education_module.dart
class EducationModule {
  final String module;
  final List<Level> levels;

  EducationModule({
    required this.module,
    required this.levels,
  });

  factory EducationModule.fromJson(Map<String, dynamic> json) {
    return EducationModule(
      module: json['module'] ?? '',
      levels: (json['levels'] as List<dynamic>?)
          ?.map((levelJson) => Level.fromJson(levelJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'levels': levels.map((level) => level.toJson()).toList(),
    };
  }

  // Helper methods
  String get moduleName => module;

  int get levelCount => levels.length;

  int get totalScenarios => levels.fold(0, (sum, level) => sum + level.scenarioCount);

  // Get level by name
  Level? getLevelByName(String levelName) {
    try {
      return levels.firstWhere((level) => level.level == levelName);
    } catch (e) {
      return null;
    }
  }

  // Get level by number (1, 2, 3)
  Level? getLevelByNumber(int levelNumber) {
    try {
      return levels.firstWhere((level) => level.levelNumber == levelNumber);
    } catch (e) {
      return null;
    }
  }

  // Get all scenarios across all levels
  List<Scenario> get allScenarios {
    return levels.expand((level) => level.scenarios).toList();
  }

  // Get scenario by ID (searches across all levels)
  Scenario? getScenarioById(int id) {
    for (final level in levels) {
      final scenario = level.getScenarioById(id);
      if (scenario != null) return scenario;
    }
    return null;
  }

  // Get scenarios by level type
  List<Scenario> getScenariosByLevelType(String levelType) {
    final level = levels.where((l) => l.levelType == levelType).firstOrNull;
    return level?.scenarios ?? [];
  }

  @override
  String toString() {
    return 'EducationModule(module: $module, levels: ${levels.length}, totalScenarios: $totalScenarios)';
  }
}

// Updated JsonDataManager2 with proper model integration



