import 'package:flutter/material.dart';

class CreateProgress extends StatelessWidget {
  const CreateProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: 0,
      minHeight: 8,
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Colors.white24,
    );
  }
}
