import 'package:flutter/material.dart';

class VideoContext extends StatelessWidget {
  const VideoContext({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: const TextSpan(
                text: 'TRT is a Turkish public broadcast service. ',
                children: [
                  TextSpan(
                    text: 'Wikipedia ',
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.open_in_new,
                          color: Colors.blue,
                          size: 13.5,
                        ),
                      )
                    ],
                    style: TextStyle(fontSize: 13.5, color: Colors.blue),
                  ),
                ],
                style: TextStyle(fontSize: 13.5),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 24),
          const Icon(Icons.more_vert_outlined, size: 16),
        ],
      ),
    );
  }
}
