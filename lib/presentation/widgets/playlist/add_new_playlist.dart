import 'package:flutter/material.dart';

class AddNewPlaylist extends StatelessWidget {
  const AddNewPlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
            ),
            child: const Icon(Icons.add, size: 30),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('New playlist'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
