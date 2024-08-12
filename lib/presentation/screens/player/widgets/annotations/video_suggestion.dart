import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/app.dart';
import 'package:youtube_clone/presentation/screens/player/widgets/annotations/annotations_notification.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoSuggestion extends StatelessWidget {
  const VideoSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(child: Text('Suggested video')),
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
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://picsum.photos/300/300',
                        ),
                        fit: BoxFit.cover,
                      ),
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
            Row(
              children: [
                Expanded(
                  child: CustomActionChip(
                    title: 'Close',
                    onTap: () {
                      CloseAnnotationsNotification().dispatch(context);
                    },
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: const Color(0xFF232323),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
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
      ),
    );
  }
}
