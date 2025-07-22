import 'package:flutter/material.dart';

class InstructionsDialog extends StatelessWidget {
  const InstructionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF4A90E2), size: 30),
          const SizedBox(width: 10),
          const Expanded(
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
            _buildInstructionSection(
              icon: Icons.trending_up,
              color: const Color(0xFF4CAF50),
              title: 'Level Progression',
              description:
              'Complete scenarios in each level to unlock the next level within the same module.',
            ),
            const SizedBox(height: 16),
            _buildInstructionSection(
              icon: Icons.lock_open,
              color: const Color(0xFFFF9800),
              title: 'Module Unlocking',
              description:
              'Complete ALL levels in a module to unlock the next module. Modules must be completed in order.',
            ),
            const SizedBox(height: 16),
            _buildInstructionSection(
              icon: Icons.star,
              color: const Color(0xFFFFD700),
              title: 'Scoring System',
              description:
              'Answer correctly to earn coins and stars. Complete activities when you get answers wrong to learn more!',
            ),
            const SizedBox(height: 16),
            _buildCurrentProgressSection(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Got it!',
            style: TextStyle(
              color: Color(0xFF4A90E2),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionSection({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentProgressSection() {
    // Replace this with actual current progress UI if needed.
    return Row(
      children: const [
        Icon(Icons.timeline, color: Colors.blue),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Your current progress is saved and shown here based on completed modules and levels.',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
