import 'package:flutter/material.dart';

class ComingSoonDialog extends StatelessWidget {
  final String module;
  final String level;

  const ComingSoonDialog({
    super.key,
    required this.module,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.construction, color: Color(0xFF9C27B0), size: 30),
          SizedBox(width: 10),
          Text('Coming Soon!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$module - $level',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text(
            'This level is currently under development. Stay tuned!',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it!', style: TextStyle(color: Color(0xFF9C27B0))),
        ),
      ],
    );
  }
}
