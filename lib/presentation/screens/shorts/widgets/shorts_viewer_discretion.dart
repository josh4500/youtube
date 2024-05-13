import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ShortsViewerDiscretion extends StatelessWidget {
  const ShortsViewerDiscretion({
    super.key,
    required this.onClickContinue,
    required this.onClickSkipVideo,
  });
  final VoidCallback onClickContinue;
  final VoidCallback onClickSkipVideo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Text(
            'Viewer discretion is advice',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'The following content may contain suicide or self-harm topics.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          CustomActionChip(
            title: 'Continue',
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(24),
            backgroundColor: Colors.white,
            alignment: Alignment.center,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            onTap: onClickContinue,
          ),
          const SizedBox(height: 18),
          CustomActionChip(
            title: 'Skip video',
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(24),
            backgroundColor: Colors.white12,
            alignment: Alignment.center,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            onTap: onClickSkipVideo,
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
