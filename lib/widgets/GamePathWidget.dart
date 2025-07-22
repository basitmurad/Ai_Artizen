import 'package:flutter/material.dart';
import '../dialoge/InstructionsDialog.dart';

class GamePathWidget extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback playGameSound;
  final Widget Function() buildFloatingMascot;
  final List<Widget> Function() buildAllModules;

  const GamePathWidget({
    Key? key,
    required this.isPlaying,
    required this.playGameSound,
    required this.buildFloatingMascot,
    required this.buildAllModules,
  }) : super(key: key);

  @override
  _GamePathWidgetState createState() => _GamePathWidgetState();
}

class _GamePathWidgetState extends State<GamePathWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.buildFloatingMascot(),
                const SizedBox(height: 25),
                const Text(
                  "🚀 Start Your AI Learning Journey",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Need guidance? Tap below to see how to unlock levels and progress!",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Buttons: Help & Sound
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const InstructionsDialog(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: widget.playGameSound,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.isPlaying ? Icons.stop : Icons.volume_up,
                          color: const Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...widget.buildAllModules(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
