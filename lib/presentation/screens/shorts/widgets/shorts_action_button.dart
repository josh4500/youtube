import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ShortsActionButton extends StatelessWidget {
  const ShortsActionButton({
    super.key,
    required this.title,
    required this.summary,
    required this.onTap,
  });
  final Widget title;
  final String summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: CustomInkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(64),
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 14,
        ),
        child: Column(
          children: <Widget>[
            title,
            const SizedBox(height: 8),
            Text(summary, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
