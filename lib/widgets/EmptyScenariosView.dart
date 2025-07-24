import 'package:flutter/material.dart';

class EmptyScenariosView extends StatelessWidget {
  const EmptyScenariosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.white.withOpacity(0.7),
          ),
          SizedBox(height: 16),
          Text(
            'No scenarios found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
