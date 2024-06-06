import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoSuggestion extends StatelessWidget {
  const VideoSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Suggested video',
                ),
              ),
              AppbarAction(icon: Icons.close),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why the BJP has lost majority of the positions in the government',
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Harris Craycraft',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: CustomActionChip(
                  title: 'Close',
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Color(0xFF232323),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomActionChip(
                  title: 'Play now',
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
