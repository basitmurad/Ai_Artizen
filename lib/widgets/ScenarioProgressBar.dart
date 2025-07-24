import 'package:flutter/material.dart';

class ScenarioProgressBar extends StatelessWidget {
  final int currentIndex;
  final int total;

  const ScenarioProgressBar({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? (currentIndex + 1) / total : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
