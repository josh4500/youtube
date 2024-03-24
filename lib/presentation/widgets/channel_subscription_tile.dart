import 'package:flutter/material.dart';

class ChannelSubscribeTile extends StatelessWidget {
  const ChannelSubscribeTile({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // TODO(Josh): Make second type that is bigger
    return ColoredBox(
      color: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const SizedBox(width: 60),
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
