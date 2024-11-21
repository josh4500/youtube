import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class ChannelSubscribeTile extends StatelessWidget {
  const ChannelSubscribeTile({super.key, this.leading, required this.title});

  final Widget? leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO(josh4500): Make second type that is bigger
    return ColoredBox(
      color: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (leading != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: leading,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Text(
                        'Subscribe',
                        style: TextStyle(
                          color: Color(0xFFFF0000),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '74.9M',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
