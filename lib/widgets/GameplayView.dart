import 'package:flutter/material.dart';

import '../models/JsonModel.dart';

class GameplayView extends StatelessWidget {
  final List<Scenario> scenarios;
  final PageController pageController;
  final int currentScenarioIndex;
  final Function(int) onPageChanged;
  final Widget Function(Scenario, int) scenarioPageBuilder;
  final Widget progressBar;

  const GameplayView({
    super.key,
    required this.scenarios,
    required this.pageController,
    required this.currentScenarioIndex,
    required this.onPageChanged,
    required this.scenarioPageBuilder,
    required this.progressBar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar passed as a widget
        progressBar,

        // Scenarios PageView
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: scenarios.length,
            itemBuilder: (context, index) {
              return scenarioPageBuilder(scenarios[index], index);
            },
          ),
        ),
      ],
    );
  }
}
