import 'package:flutter/material.dart';
import '../models/JsonModel.dart';

class ScenarioNavigationButtons extends StatelessWidget {
  final Scenario scenario;
  final int index;
  final int totalScenarios;
  final bool hasAnswer;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ScenarioNavigationButtons({
    Key? key,
    required this.scenario,
    required this.index,
    required this.totalScenarios,
    required this.hasAnswer,
    required this.onPrevious,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastScenario = index == totalScenarios - 1;

    return Row(
      children: [
        // Previous button
        if (index > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: onPrevious,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18),
                  SizedBox(width: 8),
                  Text('Previous', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

        if (index > 0) SizedBox(width: 12),

        // Next/Submit button
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: hasAnswer ? onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
              hasAnswer ? Colors.white : Colors.white.withOpacity(0.3),
              foregroundColor:
              hasAnswer ? const Color(0xFF4A90E2) : Colors.white.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastScenario ? 'Complete Level' : 'Check Answer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(
                  isLastScenario ? Icons.check_circle : Icons.arrow_forward,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
