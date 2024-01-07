import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class ShortsContextInfo extends StatelessWidget {
  const ShortsContextInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return TappableArea(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        color: Colors.black38,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Covid 19 . Get the latest information from the NCDC about COVID-19',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
