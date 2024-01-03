import 'package:flutter/material.dart';

class FoundTVs extends StatelessWidget {
  const FoundTVs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('No TVs found'),
          const SizedBox(height: 16),
          const Text(
            'Check your phone settings and try again. If that doesn\'t work, you can also link your TV and phone using a TV code.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsetsDirectional.zero,
              ),
            ),
            child: const Text('Get Help'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
