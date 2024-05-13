import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ShortsHistoryOff extends StatelessWidget {
  const ShortsHistoryOff({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(YTIcons.shorts_search, size: 36),
            ),
          ),
          const Spacer(),
          const Text(
            'Shorts recommendation are off',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Your watch history is off, and we rely on watch history to tailor your Shorts feed. You can change your setting at any time, or try searching for Shorts instead. Learn more.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          CustomActionChip(
            title: 'Update setting',
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(24),
            backgroundColor: Colors.white,
            alignment: Alignment.center,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
