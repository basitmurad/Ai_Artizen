// import 'package:flutter/material.dart';
// import '../models/JsonModel.dart';
//
// class ScenarioNavigationButtons extends StatelessWidget {
//   final Scenario scenario;
//   final int index;
//   final int totalScenarios;
//   final bool hasAnswer;
//   final VoidCallback onPrevious;
//   final VoidCallback onNext;
//
//   const ScenarioNavigationButtons({
//     Key? key,
//     required this.scenario,
//     required this.index,
//     required this.totalScenarios,
//     required this.hasAnswer,
//     required this.onPrevious,
//     required this.onNext,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final isLastScenario = index == totalScenarios - 1;
//
//     return Row(
//       children: [
//         // Previous button
//         if (index > 0)
//           Expanded(
//             child: ElevatedButton(
//               onPressed: onPrevious,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.arrow_back, size: 18),
//                   SizedBox(width: 8),
//                   Text('Previous', style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//             ),
//           ),
//
//         if (index > 0) SizedBox(width: 12),
//
//         // Next/Submit button
//         Expanded(
//           flex: 2,
//           child: ElevatedButton(
//             onPressed: hasAnswer ? onNext : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor:
//               hasAnswer ? Colors.white : Colors.white.withOpacity(0.3),
//               foregroundColor:
//               hasAnswer ? const Color(0xFF4A90E2) : Colors.white.withOpacity(0.5),
//               padding: EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   isLastScenario ? 'Complete Level' : 'Check Answer',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(width: 8),
//                 Icon(
//                   isLastScenario ? Icons.check_circle : Icons.arrow_forward,
//                   size: 18,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/JsonModel.dart';

class ScenarioNavigationButtons extends StatefulWidget {
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
  State<ScenarioNavigationButtons> createState() => _ScenarioNavigationButtonsState();
}

class _ScenarioNavigationButtonsState extends State<ScenarioNavigationButtons> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playGameSound() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(AssetSource('sound1.mp3'));
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error playing/stopping sound: $e');
      // Multiple fallback options:

      // Option 1: Just haptic feedback (recommended)
      HapticFeedback.selectionClick();

      // Option 2: Try to play a different asset sound as backup
      // try {
      //   await _audioPlayer.play(AssetSource('backup.mp3'));
      // } catch (backupError) {
      //   HapticFeedback.selectionClick();
      // }

      // Option 3: Platform-specific handling
      // if (Platform.isIOS) {
      //   HapticFeedback.selectionClick();
      // } else if (Platform.isAndroid) {
      //   HapticFeedback.vibrate();
      // }
    }
  }
  // Listen to audio player state changes
  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      } else if (state == PlayerState.playing) {
        if (mounted) {
          setState(() {
            _isPlaying = true;
          });
        }
      }
    });
  }

  /// Handle previous button press with sound and haptic feedback
  void _handlePreviousPress() {
    _playGameSound();
    // Add haptic feedback for better user experience
    HapticFeedback.lightImpact();
    widget.onPrevious();
  }

  /// Handle next button press with sound and haptic feedback
  void _handleNextPress() {
    _playGameSound();

    final isLastScenario = widget.index == widget.totalScenarios - 1;

    if (isLastScenario) {
      // Stronger haptic feedback for completion
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final isLastScenario = widget.index == widget.totalScenarios - 1;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Previous button
          if (widget.index > 0)
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 150),
                child: ElevatedButton(
                  onPressed: _handlePreviousPress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black26,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Show sound indicator if playing
                      if (_isPlaying) ...[
                        SizedBox(width: 4),
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          if (widget.index > 0) SizedBox(width: 8),

          // Next/Submit button with enhanced styling
          Expanded(
            flex: 2,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: widget.hasAnswer ? _handleNextPress : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.hasAnswer
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  foregroundColor: widget.hasAnswer
                      ? const Color(0xFF4A90E2)
                      : Colors.white.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: widget.hasAnswer ? 4 : 1,
                  shadowColor: widget.hasAnswer ? Colors.black38 : Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastScenario ? 'Complete Level' : 'Check Answer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: Icon(
                        isLastScenario ? Icons.check_circle : Icons.arrow_forward,
                        size: 18,
                        key: ValueKey(isLastScenario ? 'complete' : 'next'),
                      ),
                    ),
                    // Show sound indicator if playing
                    if (_isPlaying) ...[
                      SizedBox(width: 8),
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.hasAnswer
                                ? const Color(0xFF4A90E2)
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}