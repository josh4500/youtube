import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 44),
              const CircleAvatar(
                backgroundColor: Colors.grey,
                maxRadius: 16,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: '@BussyBoyBonanza',
                              children: [
                                TextSpan(text: ' · '),
                                TextSpan(text: '7mo ago'),
                              ],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Cutting fundig on precautions is going to cost more in the long run',
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '1.5k',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.thumb_down_outlined,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
