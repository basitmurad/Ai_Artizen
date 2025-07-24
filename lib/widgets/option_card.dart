// import 'package:flutter/material.dart';
// import '../models/JsonModel.dart';
//
// class OptionCard extends StatelessWidget {
//   final Scenario scenario;
//   final int optionIndex;
//   final String optionText;
//   final bool isSelected;
//   final void Function(Scenario, int) onSelect;
//
//   const OptionCard({
//     Key? key,
//     required this.scenario,
//     required this.optionIndex,
//     required this.optionText,
//     required this.isSelected,
//     required this.onSelect,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => onSelect(scenario, optionIndex),
//           borderRadius: BorderRadius.circular(16),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: isSelected
//                     ? const Color(0xFF4A90E2)
//                     : Colors.white.withOpacity(0.3),
//                 width: isSelected ? 2 : 1,
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: isSelected
//                           ? const Color(0xFF4A90E2)
//                           : Colors.white.withOpacity(0.5),
//                       width: 2,
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       optionIndex.toString(),
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     optionText,
//                     style: TextStyle(
//                       color: isSelected ? Colors.black87 : Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// widgets/option_card.dart
import 'package:flutter/material.dart';
import '../models/JsonModel.dart';

class OptionCard extends StatelessWidget {
  final Scenario scenario;
  final int optionIndex;
  final String optionText;
  final bool isSelected;
  final Function(Scenario, int) onSelect;

  // NEW: Additional properties for answer prevention
  final bool isAnswered;
  final bool isCorrectOption;
  final bool wasUserCorrect;

  const OptionCard({
    Key? key,
    required this.scenario,
    required this.optionIndex,
    required this.optionText,
    required this.isSelected,
    required this.onSelect,
    this.isAnswered = false,
    this.isCorrectOption = false,
    this.wasUserCorrect = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    Color borderColor;
    Color textColor = Colors.white;
    IconData? statusIcon;

    if (isAnswered) {
      // Show results after answer is submitted
      if (isCorrectOption) {
        // This is the correct answer
        cardColor = Colors.green.withOpacity(0.3);
        borderColor = Colors.green;
        statusIcon = Icons.check_circle;
      } else if (isSelected && !wasUserCorrect) {
        // This was the user's wrong selection
        cardColor = Colors.red.withOpacity(0.3);
        borderColor = Colors.red;
        statusIcon = Icons.cancel;
      } else {
        // Other options after answering
        cardColor = Colors.grey.withOpacity(0.3);
        borderColor = Colors.grey;
        textColor = Colors.grey[300]!;
      }
    } else {
      // Normal state before answering
      if (isSelected) {
        cardColor = Colors.white.withOpacity(0.2);
        borderColor = Colors.white;
      } else {
        cardColor = Colors.transparent;
        borderColor = Colors.white.withOpacity(0.3);
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : () => onSelect(scenario, optionIndex),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(
                color: borderColor,
                width: isSelected || isAnswered ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Option letter (A, B, C, D)
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isAnswered ? borderColor : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(64 + optionIndex), // A, B, C, D
                      style: TextStyle(
                        color: isAnswered ? Colors.white : textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Option text
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Status icon for answered scenarios
                if (statusIcon != null) ...[
                  SizedBox(width: 8),
                  Icon(
                    statusIcon,
                    color: borderColor,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}