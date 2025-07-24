// import 'package:flutter/material.dart';
//
// import '../models/JsonModel.dart';
//
//
//
// class ScenarioCard extends StatelessWidget {
//   final Scenario scenario;
//
//   const ScenarioCard({Key? key, required this.scenario}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Title
//           Text(
//             scenario.title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF4A90E2),
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           /// Description
//           Text(
//             scenario.description,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.black87,
//               height: 1.5,
//             ),
//           ),
//
//           /// Optional Question
//           if (scenario.question != null) ...[
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF4A90E2).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: const Color(0xFF4A90E2).withOpacity(0.3),
//                 ),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.help_outline, color: Color(0xFF4A90E2), size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       scenario.question!,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         color: Color(0xFF4A90E2),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


// widgets/scenario_card.dart
import 'package:flutter/material.dart';
import '../models/JsonModel.dart';

class ScenarioCard extends StatelessWidget {
  final Scenario scenario;

  const ScenarioCard({
    Key? key,
    required this.scenario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scenario Title
          Text(
            scenario.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),

          // Scenario Description
          Text(
            scenario.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),

          // If there's an image URL, show it
          // if (scenario.imageUrl != null && scenario.imageUrl!.isNotEmpty) ...[
          //   SizedBox(height: 16),
          //   ClipRRect(
          //     borderRadius: BorderRadius.circular(12),
          //     child: Image.network(
          //       scenario.imageUrl!,
          //       width: double.infinity,
          //       height: 200,
          //       fit: BoxFit.cover,
          //       errorBuilder: (context, error, stackTrace) {
          //         return Container(
          //           width: double.infinity,
          //           height: 200,
          //           decoration: BoxDecoration(
          //             color: Colors.grey.withOpacity(0.3),
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //           child: Icon(
          //             Icons.image_not_supported,
          //             color: Colors.white.withOpacity(0.5),
          //             size: 50,
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}