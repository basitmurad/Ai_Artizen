class LevelData {
  final int id;
  final String title;
  final bool isCompleted;
  final bool isUnlocked;
  final int stars;
  final Map<String, dynamic> scenarioData;

  LevelData({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isUnlocked,
    required this.stars,
    required this.scenarioData,
  });
}
