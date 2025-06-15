
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ModuleDefinition {
  final String id;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final String? jsonManager;
  final int maxLevels;
  final bool isAlwaysUnlocked;

  ModuleDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.jsonManager,
    this.maxLevels = 3,
    this.isAlwaysUnlocked = false,
  });
}
